# Doing analysis on FASTPython

A general note: When we import an entity, we cannot know if it is a variable, a function, a class... So the analysis works better for entities declared in the file for multiple parts of this documentation.

> Note: Currently, analysis done with FASTPython are mostly done to analyse variables. So the documentation will be centered on analysis of variables and the algos are mostly tested on variables analysis and not functions, methods, ...ß

- [Doing analysis on FASTPython](#doing-analysis-on-fastpython)
  - [Local resolution](#local-resolution)
    - [Shadowing](#shadowing)
    - [Querying local resolver information](#querying-local-resolver-information)
  - [Static Single Assignment (SSA)](#static-single-assignment-ssa)
    - [Building](#building)
    - [Exploiting the SSA](#exploiting-the-ssa)
    - [Assigned expressions](#assigned-expressions)
  - [Limitations of local resolver and SSA](#limitations-of-local-resolver-and-ssa)
    - [Attribute accesses](#attribute-accesses)
    - [Subscript content](#subscript-content)
    - [Instance variables](#instance-variables)
    - [Python 2 VS Python 3](#python-2-vs-python-3)
    - [Global and Non local statement](#global-and-non-local-statement)
  - [FAST Python visitor](#fastpython-visitor)
  - [Control Flow Graph (CFG)](#control-flow-graph-cfg)
  - [FAST utilities](#fast-utilities)
  - [API](#api)
    - [Variables analysis](#variables-analysis)
      - [Knowing what is a variable](#knowing-what-is-a-variable)
      - [Accessing the SSA versions of a variable](#accessing-the-ssa-versions-of-a-variable)
      - [Getting the accesses of a variable](#getting-the-accesses-of-a-variable)
      - [Knowing what uses a variable](#knowing-what-uses-a-variable)
      - [Getting the internal accesses of a variable](#getting-the-internal-accesses-of-a-variable)
      - [Getting the calls on a variable](#getting-the-calls-on-a-variable)
      - [Getting the assigned expressions](#getting-the-assigned-expressions)
  - [Examples of analysis](#examples-of-analysis)

## Local resolution

FASTPython includes `FASTPythonLocalResolverVisitor`. Its goal is to link each entities to their first declaration. This works for all named entities.
You can link:
- Variables
- Functions
- Methods
- Imports

During analysis it is recommended to have a resolved FASTPython:

```smalltalk
FASTPythonLocalResolverVisitor resolve: aModule "could be any behavioral entity of a FASTPython model."
```

Once this is done, you can ask any node that can represent a variable for its `#localDeclaration`. It will return the first definition of the entity if it is in the file. If the entity is not declared in the file, it will return a `FASTNonLocalDeclaration`.

The local declaration knows all the usages of the entity in the model. We can get them by asking `#localUses`.

### Shadowing

In Python anything named can shadow anything named. For example we can declare a global variable then shadow it with an import, then shadow it with a function...

In the case of a shadowing, we manage it in two distinct ways:
- If we know for sure that the entity will be the same kind of entity (for example, if the entity stays a variable because we assign two times values to the same variable), then they keep the same local declaration
- If the entity kind is different (for example we shadow a global variable with a function) or if we are not sure (if we shadow something with an imported entity for example), then we create a new local declaration

When a new declaration shadows an existing one, the two declarations are linked via `#shadowedBy` and `#shadowing`. Each declaration in the chain keeps its own `#localUses` (the entities that resolve to it). Usages always resolve to the most recent declaration.

For example:

```python
x = 1              # Declaration 1: Variable
from os import x   # Declaration 2: Import (shadows Declaration 1)
def x():           # Declaration 3: Function (shadows Declaration 2)
    pass
print(x)           # Links to Declaration 3
```

After running the local resolver:

```smalltalk
varDecl := model module statements first left.      "FASTPyVariable"
importStmt := model module statements second.       "FASTPyImportFromStatement"
funcDecl := model module statements third.          "FASTPyFunctionDefinition"

varDecl shadowedBy.        "=> FASTPyImportFromStatement"
importStmt shadowedBy.     "=> FASTPyFunctionDefinition"
importStmt shadowing.      "=> FASTPyVariable"
funcDecl shadowing.        "=> FASTPyImportFromStatement"

varDecl localUses size.     "1  (just the assignment)"
importStmt localUses size. "1  (just the import)"
funcDecl localUses size.   "2  (the definition + print(x))"
```

Each declaration in the chain is independent: they each track their own local uses, and `#shadowedBy`/`#shadowing` form a linked list from the first declaration to the last.

Note that if two assignments target the same variable with no other kind of entity in between, no shadowing link is created. Since both are the same kind of entity (variable), they share the same local declaration:

```python
x = 1
x = 2
print(x)
```

Here both `x = 1` and `x = 2` resolve to the same `FASTPyVariable` declaration. `#shadowedBy` is nil. To distinguish between the two assignments and trace which one impacts a given use, use [SSA](#static-single-assignment-ssa) which creates a separate version for each assignment.

### Querying local resolver information

It is possible to ask a few things to the nodes once the resolution is done:
- `node localDeclaration` returns the first node that declared the entity we are querying
- `node localDeclaration localUses` returns all uses of the node (declarations and usage)
- `node isResolvedVariable` returns `true` if the node resolves to a local variable declaration (not an unresolved name, not a function, not a method, not an import)
- `node usedVariables` returns all entities in the node and its subtree that have been resolved to local variable declarations (includes the node itself if it is a resolved variable).
- `node allAccesses` if the node is a variable, returns all the read and write accesses to the variable
- `node allReadAccesses` if the node is a variable, returns all the read accesses to the variable
- `node allWriteAccesses` if the node is a variable, returns all the write accesses to the variable
- `node internalAccesses` if the node is a variable, returns all the internal accesses done on the variable, i.e. the attribute accesses and subscripts such as `x.y` and `x[3]`, on all the accesses of the variable
- `node allNodesUsingMe` if the node is a variable, returns all the nodes using the variable: for each access of the variable, all its ancestors up to the statement containing it, without going further than the statement blocks (Module, function, method, clauses, ...). For example, for `return x + 3`, it returns the return statement and the binary operation
- `node statementsUsingMe` if the node is a variable, returns the statements using the variable: same as `allNodesUsingMe` but only the statement of each access, without the intermediate nodes
- `node callsOnVariable` if the node is a variable, returns the calls made on the variable, i.e. the `FASTPyCall` nodes having the variable as receiver: the callee of the call is the read of the variable itself (such as the invocation or instantiation `x()`) or an internal access on the variable (such as `x.append(1)` or `x[3]()`)
- `node variableDeclarator` if the node that is a variable write access, it will return the node assigning the variable (can be an assignment, augmented assignment, for loop or for in clause)

On the model:
- `model allResolvedVariables` returns all nodes in the model that resolve to a variable declaration. This is a shortcut for querying the model-level view of all resolved variables.


## Static Single Assignment (SSA)

### Building

FASTPython includes `FASTPythonSSAVisitor` to build a SSA form of the AST. The goal of the SSA is to know for each use of a variable, the assignation or assignations linked to this usage.

It can be run like this:

```smalltalk
FASTPythonSSAVisitor resolve: model module
```

Another possibility is to import via `FASTPythonImporter` using `#parseAndResolve:` or `parseFileAndResolve:` instead of just parsing.

```smalltalk
FASTPythonImporter parseAndResolve: 'x = 3
print(x)' withPlateformLineEndings
```

### Exploiting the SSA

Two little examples:

```python
x.y = 4         # x.y_1
print(x.y)      # x.y_1
x.y = 6         # x.y_2
print(x.y)      # x.y_2
```

Here we have only one variable, but with two assignments. We know that the first printing prints the value assigned in line 1 and the second prints the value in the second assignment.

```python
x.y = 4         # x.y_1
print(x.y)      # x.y_1

if z > 3:
    x.y = 3     # x.y_2

print(x.y)      # Phi(x.y_1, x.y_2)
```

In this new case, the second printing can have two different value depending on z. Then, we return a collection of those values.

You can ask any node representing a variable for its `#ssaVersion`. This version can either be a `FASTVariableVersionSSA` or a `FASTPhiVersionSSA`. It will be a Phi if it can have multiple versions.

All versions know the local declaration of the variable (which allow to find all usages independently of the assignment) and you can use `#localUses` to find all the uses of the variable **for the current SSA version**.

For example:

```python
x = 2           # x_1
print(x)        # x_1

if z > 3:
    x = 3       # x_2
    print(x)    # x_2
else:
    x = 4       # x_3

print(x)        # Phi(x_2, x_3)
```

Asking `#ssaVersion` to the `FASTPyVariable` node of `x = 3`, it will return the version number 2. If you ask its local uses, it will return. The one of the assignment (write access), the one of the second printing (read access) and the one of the last printing (read access).

It is possible to ask to a model or a group for the SSA versions inside it using `#allSSAVersions`. On a node representing a variable, `#allSSAVersions` returns all the SSA versions this variable can get, including its Phi versions, and `#allSSABasicVersions` returns the same but without the Phi versions. Both require the SSA resolution to be done.

On top of this, it is possible to get information via the SSA directly with the API of the variables nodes:
- `node versionAccesses` returns all the read and write accesses for this sepcific version of the variable
- `node versionReadAccesses` returns all the real accesses for this specific version of the variable
- `node versionWriteAccesses` returns all the write accesses for this specific version of the variable
- `node allNodesUsingMyVersion` same as `allNodesUsingMe` but only with the accesses reachable from the current SSA version of the node. In case of a Phi version, the accesses of all the reachable versions are considered
- `node statementsUsingMyVersion` same as `statementsUsingMe` but only with the accesses reachable from the current SSA version of the node
- `node callsOnVariableVersion` same as `callsOnVariable` but only with the reads reachable from the current SSA version of the node

### Assigned expressions

It is also possible to query what is assigned in variables once the SSA is done:
- `node variableDeclarator` for a node that is a write access to a variable, it will return the node assigning the variable
- `node assignedExpressionsMap` for a variable, return a map of all expressions used to assigned the variable. The keys of the map are the write accesses that can impact the value of this variable. In some cases there will be only one. But if the variable is assigned in a conditional expression, it will get one entry by assignment that can impact the current variable value
- `node transitiveAssignedExpressions` for a node doing an assignment (the `variableDeclarator` of a write access), returns the expressions used in the assignment and, for each variable used in those expressions, the expressions assigned to that variable, recursively
- `node transitiveAssignedExpressionsMap` for a variable, same as `assignedExpressionsMap` but the values are the transitive assigned expressions of each write access

Be carful, `x = 3` is not the only way to assign a variable. Take those cases into account:

```python
x = 3
```

For x

Assigned expression: `3`

```python
x, (y, z) = (3, (4, 5))
```

Assigned expression: `(3, (4, 5))`

> Note: in case of tuples or lists, we do not select the right element in the tuple/list. Especially since it can be given via a variable or a call.

```python
for x in range(0):
    print(x)
```

Assigned expression: `range(0)`

```python
[c for c in coll]
```

Assigned expression: `coll`

```python
x += 1
```

Assigned expression: `1`

Be carful, it does not know with the addition method of `x` will do if it is an object.

The transitive variants go one step further than the direct assignment: for each variable used in the assigned expressions, the expressions assigned to that variable are added, and so on recursively. Both need the SSA resolution. The result contains each expression only once, even if it can be reached through multiple paths.

For example:

```python
y = 1

x = y

print(x)
```

The assignment `x = y` assigns the expression `y`. Since `y` is itself assigned `1`, the transitive version returns both:

```smalltalk
model module statements second transitiveAssignedExpressions. "an OrderedCollection(PyIdentifier(12 - 12) PyInteger(5 - 5))"

model module statements second assignedExpressions. "an Array(PyIdentifier(12 - 12)) <= The non transitive version returns only the read of `y`"
```

On the map side, the receiver is the variable read and each value is transitive:

```smalltalk
model module statements third arguments first transitiveAssignedExpressionsMap

"a Dictionary(
	PyVariable(8 - 8)->an OrderedCollection(PyIdentifier(12 - 12) PyInteger(5 - 5)) )"
```

In case of a phi version, the map has one entry per assignment that can impact the value, each with its own transitive expressions:

```python
y = 1

if z > 3:
	x = y
else:
	x = 2

print(x)
```

```smalltalk
model module statements last arguments first transitiveAssignedExpressionsMap

"a Dictionary(
	PyVariable(19 - 19)->an OrderedCollection(PyIdentifier(23 - 23) PyInteger(5 - 5))
	PyVariable(32 - 32)->an OrderedCollection(PyInteger(36 - 36)) )"
```

## Limitations of local resolver and SSA

Multiple limitations are present in those two algorithms. Some because it is impossible to do. Some others because we did not take the time to push the implementation further.

### Attribute accesses

Attribute accesses globaly work, but not in some specific cases. Here is an example:

```python
x.y.z = 3
a = x.y
print(a.z)
```

Here the printing of `a.z` should be linked to the declaration `x.y.z = 3` but this is currently not supported.


### Subscript content

Currently to identify a subscript in the local resolver and the SSA, we check the content of the subscript as a string but this is too lax. Here are a few examples of problems with subscripts:

```python
x = 2

y[x] = 3

x = 3

y[x]
```

Here the second subscript will declare the first one as local declaration even if it is a different index in this case.

```python
x[0:4]

x[:4]
```

Here the two subscripts are the same, byt since we compare strings, it will be seen as different.

We could improve this by checking the expression instide instead of the souce code.

### Instance variables

Instance variables cannot be managed well by a SSA since there are no declaration of instance variables in python and we do not know in which order the methods will be invoked.

Some API to query instance variables is also available and will be described later in this documentation.

### Python 2 VS Python 3

The local resolver and SSA are currently based on Python 3 behavior and not Python 2. In the future we could support both.

This has some implications, for example:

```python
[x for x in coll]
print(x)
```

Here, the printing will be linked to an nonlocal declaration because in Python 3, list comprehensions are scoped and x is only declared in the comprehension. In Python 2, x would have leaked the comprehension.

### Global and Non local statement

The local resolver handles global and non local statements. A `global x` inside a function redirects the variable resolution to the module-scope declaration of `x`. A `nonlocal x` redirects to the nearest enclosing scope that defines `x`. This means writes inside the function (including walrus operators) create new SSA versions of the outer declaration.

## FAST Python visitor

FASTPython comes with a visitor either used in the form of a trait to use with `FASTPyTVisitor` or a class to subclass with `FASTPythonVisitor`.

Be careful, in some usage of the visitor some visit methods need to be overriden to change the visit order. For example, in a visitor I needed to ensure that function parameters are visited before the statements of the function.

For more information about FASTPython visitor you can read [this blog post on the Moose wiki](https://modularmoose.org/blog/2026-05-20-improving-visitor-generator-copy/).

## Control Flow Graph (CFG)

It is possible to get a control flow graph of a behavioral entities in FASTPython.

I can be used like this:

```smalltalk
FASTPythonCFGVisitor buildCFGOf: aModel allFunctionDefinitions first.

"or"

aModel allFunctionDefinitions first cfg
```

I can take one of five different entities to build a CFG:

•	a FASTPyModule
•	a FASTPyFunctionDefinition
•	a FASTPyMethodDefinition
•	a FASTPyLambda
•	a FASTPyClassDefinition

It is also possible to ask for a "full" CFG that returns a dictionary with the CFG on the entity and also the CFGs of all definitions found inside of this entity.

Once we have the CFG, we can use `FASTCFGTVisitor` to visit it. This visitor will visit all expressions in the CFG and all the next blocks.
It has the nice feature of visiting all blocks inside a conditional node before visiting the next blocks. It visit them branch by branch and allows the user to hook behavior between the branches.

This visitor and the python visitor are used to build the SSA if you need an example of real usage.

For more information on FAST CFG you can read this [article on the Moose wiki](https://modularmoose.org/developers/fast-cfg/).

## FAST utilities

Some properties and helpers got added to FAST to get more information out of the AST. Here some of them will be described.

Some general properties got added such as:
- `FASTPyMethodDefinition>>isStatic` to know if a method is static
- `FASTPyMethodDefinition>>isAbstract` to know if a method is abstract
- `FASTPyMethodDefinition>>selfName` to know the name of the self parameter (will be nil for static methods)

For nodes representing a write access to a variable (it is possible to find them easily once we resolved our project with the local resolver or the SSA), we can find the expressions used in their writing by using `#assignedExpressions` on the node doing the assignment, i.e. the `variableDeclarator` of the write access, not on the variable itself.

> Note: you can find some warnings on this in the section [Querying local resolver information](#querying-local-resolver-information). They are the same.

A node can also be accessed internally, via an attribute access such as `x.y` or a subscript such as `x[3]`. For a node used as the accessed object of such an access, `#internalAccess` returns that access. It returns `nil` if the node is not accessed internally.

`#internalAccess` is mostly used by `#internalAccesses`, which returns all the internal accesses done on a variable, and requires the local resolution to be done.

TODO: Document more

## API

This section references the API available to analyse a FASTPython model. For now, FAST-Python was mostly used to analyse variables, so the API is centered on variables analysis.

The requirement column indicates what needs to be done on the model before using the selector:
- Vanilla: nothing, it works on the freshly imported model
- LR: the local resolution needs to be done
- SSA: the SSA resolution needs to be done (which includes the local resolution)

### Variables analysis

#### Knowing what is a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `isResolvedVariable` | `FASTPyEntity` | LR | Returns `true` if the node resolves to a local variable declaration (not an unresolved name, function, method or import) |
| `usedVariables` | `FASTPyEntity` | LR | Returns all the entities of the node and its subtree resolving to local variable declarations (includes the node itself if it is one) |
| `allResolvedVariables` | `FASTPyModel` | LR | Returns every entity of the model resolving to a variable declaration |

#### Accessing the SSA versions of a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `ssaVersion` | `FASTPyEntity` representing a variable | SSA | Returns the current SSA version of the variable. It is a `FASTVariableVersionSSA` or a `FASTVariablePhiVersionSSA` if the value can come from multiple assignments |
| `allSSAVersions` | `FASTPyEntity` representing a variable | SSA | Returns all the SSA versions the variable can get, including the Phi versions |
| `allSSABasicVersions` | `FASTPyEntity` representing a variable | SSA | Same as `#allSSAVersions` but without the Phi versions |

#### Getting the accesses of a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `allAccesses` | Any access of a variable | LR | Returns all the read and write accesses to the variable |
| `allReadAccesses` | Any access of a variable | LR | Returns all the read accesses to the variable |
| `allWriteAccesses` | Any access of a variable | LR | Returns all the write accesses to the variable |
| `variableDeclarator` | A write access of a variable | LR | Returns the node assigning the variable (assignment, augmented assignment, for loop or for in clause) |
| `versionAccesses` | Any access of a variable | SSA | Returns the read and write accesses for the current SSA version of the receiver |
| `versionReadAccesses` | Any access of a variable | SSA | Returns the read accesses for the current SSA version of the receiver |
| `versionWriteAccesses` | Any access of a variable | SSA | Returns the write accesses for the current SSA version of the receiver |

#### Knowing what uses a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `allNodesUsingMe` | Any access of a variable | LR | Returns all the nodes using the variable: the ancestors of each of its accesses, up to the statement containing it, without going further than the statement blocks |
| `statementsUsingMe` | Any access of a variable | LR | Same as `#allNodesUsingMe` but only the statements, without the intermediate nodes |
| `allNodesUsingMyVersion` | Any access of a variable | SSA | Same as `#allNodesUsingMe` but only with the accesses reachable from the current SSA version |
| `statementsUsingMyVersion` | Any access of a variable | SSA | Same as `#statementsUsingMe` but only with the accesses reachable from the current SSA version |

#### Getting the internal accesses of a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `internalAccess` | `FASTPyEntity` | Vanilla | Returns the attribute access or subscript directly accessing the node, or `nil` |
| `internalAccesses` | Any access of a variable | LR | Returns all the internal accesses done on the variable, on all its accesses |

#### Getting the calls on a variable

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `callsOnVariable` | Any access of a variable | LR | Returns the `FASTPyCall` nodes having the variable as receiver: the callee is the read of the variable itself (invocation or instantiation `x()`) or an internal access on it (`x.append(1)`, `x[3]()`) |
| `callsOnVariableVersion` | Any access of a variable | SSA | Same as `#callsOnVariable` but only with the reads reachable from the current SSA version |

#### Getting the assigned expressions

| Selector | Receiver | Requirement | Description |
|---|---|---|---|
| `assignedExpressions` | An assignment node (the `variableDeclarator` of a write access) | Vanilla | Returns the expressions used by this assignment. Returns an empty collection on any other node |
| `assignedExpressionsMap` | Any access of a variable | SSA | Returns a map with, as key, each write access impacting the value of the variable, and as value, the expressions used by that assignment |
| `transitiveAssignedExpressions` | An assignment node (the `variableDeclarator` of a write access) | SSA | Same as `#assignedExpressions` but the variables used in the assigned expressions are followed: the expressions assigned to them are added, recursively |
| `transitiveAssignedExpressionsMap` | Any access of a variable | SSA | Same as `#assignedExpressionsMap` but each value is the transitive assigned expressions of the corresponding assignment |

## Examples of analysis

In this section I'll show how to answer some questions I was asked to answer with FAST-Python.

The examples will use `#parseAndResolve:` from the python importer that parse a piece of code and launch the local resolver and SSA resolution. Each question provides its own piece of code. The python code is passed with `withPlatformLineEndings` since cr line returns are not supported in Python parsers.

**Where is a variable written/defined?**

To know the write accesses that can impact a specific use of the variable:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x)' withPlatformLineEndings.

lastVariableAccess := model module statements last arguments first.

lastVariableAccess ssaVersion. "a FASTVariablePhiVersionSSA ['x_3', 'x_2'] <= We see here that this variable can come from 2 assignments depending on a condition>"

lastVariableAccess versionWriteAccesses. "an OrderedCollection(PyVariable(18 - 18) PyVariable(36 - 36))"
```

This will return the write accesses that impacted this use of the variable. It will ignore the write accesses that cannot have an impact of this variable.

To get all the write accesses of the variable independently of versions:

```smalltalk
variable := model module statements first left. "We could get any access to the variable here, not only the first one."

variable allWriteAccesses  "an OrderedCollection(PyVariable(1 - 1) PyVariable(18 - 18) PyVariable(36 - 36))"
```

> We can also use `#allAccesses` and `#versionAccesses` to mix read and write accesses.

**Where is a variable read?**

To get the reads of the current SSA version of the variable:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x)' withPlatformLineEndings.

lastVariableAccess := model module statements last arguments first.

lastVariableAccess versionReadAccesses "an OrderedCollection(PyIdentifier(50 - 50))"
```

This will return every reading of the variable you are checking for the current SSA version. It ignores all read accesses that are not for this version of the variable.

To get all the read accesses of the variable independently of versions:

```smalltalk
variable := model module statements first left. "We could get any access to the variable here, not only the first one."

variable allReadAccesses.  "an OrderedCollection(PyIdentifier(14 - 14) PyIdentifier(50 - 50))"
```

**What is the assignment node of the variable I am manipulating?**

It is possible to get the nodes doing the assignments this way:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x)' withPlatformLineEndings.

lastVariableAccess := model module statements last arguments first.

lastVariableAccess ssaVersion writeAccesses collect: [ :access | access variableDeclarator ] "an OrderedCollection(PyAssignment(18 - 22) PyAssignment(36 - 40))"
```

The assignments nodes can be an assignment, a for, an augmented assignment or a for in clause.

Do not forget that an assignment can be done to a tuple or list.

Also, there can be multiple ones, as shown in the example, in case of a phi version.

**What expressions are used to do the assignment?**

It is possible to know all possible expressions involved in the assignment of a variable like this:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x)' withPlatformLineEndings.

lastVariableAccess := model module statements last arguments first.

lastVariableAccess assignedExpressionsMap

"a Dictionary(
	PyVariable(18 - 18)->#( PyInteger(22 - 22) )
	PyVariable(36 - 36)->#( PyInteger(40 - 40) ) )"
```

It returns a dictionary with the possible write accesses as key and the expressions involved in the writing as values.

> Note: you can find some warnings on this in the section [Querying local resolver information](#querying-local-resolver-information). They are the same.

> Note 2: You can use `#assignedExpressions` on the `variableDeclarator` of a specific write access to have information only on this one.

**What expressions are transitively used to do the assignment?**

`#transitiveAssignedExpressionsMap` works like `#assignedExpressionsMap` but also follows the variables used in the assigned expressions: for each of them, it adds the expressions assigned to that variable, and so on recursively:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'y = 1

x = y

print(x)' withPlatformLineEndings.

model module statements last arguments first transitiveAssignedExpressionsMap

"a Dictionary(
	PyVariable(8 - 8)->an OrderedCollection(PyIdentifier(12 - 12) PyInteger(5 - 5)) )"
```

The read of `y` is part of the result since `y` is itself assigned `1`.

> Note: `#transitiveAssignedExpressions` is the equivalent of `#assignedExpressions`: call it on the `variableDeclarator` of a specific write access to have the transitive expressions of only this one.

**How to know what nodes are variables?**

The local resolver resolves each entity to its declaration. `#isResolvedVariable` returns `true` only if the entity's local declaration is a variable (identifier, parameter, walrus). It returns `false` for unresolved names, functions, methods, imports, literals, and operators:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x)' withPlatformLineEndings.

firstVariableAccess := model module statements first left.
firstVariableAccess isResolvedVariable. "true  (x is a variable)"

ifStatement := model module statements fourth.
ifStatement isResolvedVariable. "false (an if statement is not a variable)"
```

At the model level, `#allResolvedVariables` returns every entity in the model that resolves to a variable declaration:

```smalltalk
model allResolvedVariables. "all resolved variable entities across the entire model"
```

**How to find all variables used in a node?**

`#usedVariables` collects all resolved variable entities within a node and its subtree. It includes the node itself if it is a resolved variable. It requires the local resolution to have been done:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

y = x + 1' withPlatformLineEndings.

firstPrint := model module statements second. "print(x)"
firstPrint usedVariables. "an IdentitySet(PyIdentifier(14 - 14))"
```

This works on any AST node — an expression, a statement, or an entire module. For example, on a binary operator:

```smalltalk
binaryExpr := model module statements third right. "x + 1"
binaryExpr usedVariables. "an IdentitySet(PyIdentifier(22 - 22)) <= the literal 1 is not a variable"
```

**How can I find every internal access done on a variable? (subscripts and attributes)**

A variable can also be accessed internally, via a subscript (`x[3]`) or an attribute (`x.y`). `#internalAccesses` returns all such accesses done on the variable, on any of its accesses. It requires the local resolution to be done:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = []

x.append(1)

print(x[0])' withPlatformLineEndings.

model module statements first left internalAccesses

"an OrderedCollection(
	PyAttributeAccess(9 - 16)
	PySubscript(28 - 31) )"
```

The result contains the `x.append` attribute access, done on the write access of `x`, and the `x[0]` subscript, done on its read in the print.

**Which nodes and which statements use a variable?**

`#allNodesUsingMe` returns all the nodes using a variable: for each of its accesses, the ancestors up to the statement containing it, without going further than the statement blocks (Module, function, method, clauses, ...). `#statementsUsingMe` returns the same but only the statements, without the intermediate nodes. Both need the local resolution to be done:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 1

def f():
	return x + 3' withPlatformLineEndings.

model module statements first left allNodesUsingMe

"a Set(
	PyReturnStatement(18 - 29)
	PyAssignment(1 - 5)
	PyBinaryOperator(25 - 29) )"

model module statements first left statementsUsingMe

"a Set(
	PyReturnStatement(18 - 29)
	PyAssignment(1 - 5) )"
```

The binary operation is part of `#allNodesUsingMe` but not of `#statementsUsingMe`.

Their SSA counterparts, `#allNodesUsingMyVersion` and `#statementsUsingMyVersion`, only consider the accesses reachable from the current SSA version of the variable. In case of a Phi version, the accesses of all the reachable versions are considered:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = 2

print(x)

x = 3

if z > 4:
	x = 5

print(x + 1)' withPlatformLineEndings.

lastVariableAccess := model module statements last arguments first leftOperand.

lastVariableAccess allNodesUsingMe

"a Set(
	PyBinaryOperator(49 - 53)
	PyCall(8 - 15)
	PyAssignment(18 - 22)
	PyCall(43 - 54)
	PyAssignment(1 - 5)
	PyAssignment(36 - 40) ) <= all the accesses of x, whatever their version"

lastVariableAccess allNodesUsingMyVersion

"a Set(
	PyAssignment(36 - 40)
	PyBinaryOperator(49 - 53)
	PyCall(43 - 54)
	PyAssignment(18 - 22) ) <= only the nodes using the current version of x"

lastVariableAccess statementsUsingMyVersion

"a Set(
	PyAssignment(36 - 40)
	PyCall(43 - 54)
	PyAssignment(18 - 22) ) <= same without the intermediate nodes"
```

**Which calls are made on a variable?**

`#callsOnVariable` returns the calls made on a variable: the `FASTPyCall` nodes having the variable as receiver. The callee of the call is the read of the variable itself (invocation or instantiation `x()`) or an internal access on the variable (`x.append(1)`). Calls where the variable is only an argument, such as `print(x)`, are not included. `#callsOnVariableVersion` is its SSA counterpart: it only considers the reads reachable from the current SSA version:

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = []

x.append(1)

x()

print(x)' withPlatformLineEndings.

model module statements first left callsOnVariable

"an OrderedCollection(
	PyCall(9 - 19)
	PyCall(22 - 24) ) <= the x.append(1) call and the x() instantiation, print(x) is excluded"
```

```smalltalk
model := FASTPythonImporter parseAndResolve: 'x = []

x.a(1)

x = []

x.b(2)' withPlatformLineEndings.

(model module statements second callee value) callsOnVariableVersion

"an OrderedCollection(
	PyCall(9 - 14) ) <= only the call of the current version"

(model module statements last callee value) callsOnVariableVersion

"an OrderedCollection(
	PyCall(25 - 30) )"
```