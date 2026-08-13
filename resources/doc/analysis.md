# Doing analysis on FASTPython

A general note: When we import an entity, we cannot know if it is a variable, a function, a class... So the analysis works better for entities declared in the file for multiple parts of this documentation.

> Note: Currently, analysis done with FASTPython are mostly done to analyse variables. So the documentation will be centered on analysis of variables and the algos are mostly tested on variables analysis and not functions, methods, ...ß

- [Doing analysis on FASTPython](#doing-analysis-on-fastpython)
  - [Local resolution](#local-resolution)
    - [Shadowing](#shadowing)
  - [Static Single Assignment (SSA)](#static-single-assignment-ssa)
  - [Limitations of local resolver and SSA](#limitations-of-local-resolver-and-ssa)
    - [Attribute accesses](#attribute-accesses)
    - [Subscript content](#subscript-content)
    - [Instance variables](#instance-variables)
    - [Python 2 VS Python 3](#python-2-vs-python-3)
    - [Global and Non local statement](#global-and-non-local-statement)
  - [FAST Python visitor](#fastpython-visitor)
  - [Control Flow Graph (CFG)](#control-flow-graph-cfg)
  - [FAST utilities](#fast-utilities)
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


## Static Single Assignment (SSA)

FASTPython includes `FASTPythonSSAVisitor` to build a SSA form of the AST. The goal of the SSA is to know for each use of a variable, the assignation or assignations linked to this usage. 

It can be run like this:

```smalltalk
FASTPythonSSAVisitor resolve: model module
```

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

All versions know the local declaration of the variable (which allow to find all usages independently of the assignemnt) and you can use `#localUses` to find all the uses of the variable **for the current SSA version**.

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

It is possible to ask to a model or a group for the SSA versions inside it using `#allSSAVersions`. 

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

For now the LR does not manage global and non local statements.

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

TODO: Document more 

## Examples of analysis

In this section I'll show how to answer some questions we might have.

The examples will use `#parseAndResolve:` from the python importer that parse a piece of code and launch the local resolver and SSA resolution.

For example: 

```smalltalk
code := 'x = 2
print(x)' withPlatformLineEndings. "Platform line ending are needed because cr line returns are not supported in Python parsers."

model := FASTPythonImporter parseAndResolve: code. "Import and resolve with local resolver and SSA."
```

Let's use this piece of Python code as example:

```python
x = 2

print(x)

x = 3

if z > 4:
	x = 5
	
print(x)
```

**Where is a variable defined?**

We can do this:

```smalltalk
lastVariableAccess := model module statements last arguments first.

lastVariableAccess ssaVersion. "a FASTVariablePhiVersionSSA ['x_3', 'x_2'] <= We see here that this variable can come from 2 assignments depending on a condition>"

lastVariableAccess versionWriteAccesses. "an OrderedCollection(PyVariable(18 - 18) PyVariable(36 - 36))"
```

This will return the write accesses that impacted this use of the variable. It will ignore the write accesses that cannot have an impact of this variable.

**Where is a variable read?**

With the same python snippet as before we can do:

```smalltalk
lastVariableAccess := model module statements last arguments first.

lastVariableAccess versionReadAccesses "an OrderedCollection(PyIdentifier(50 - 50))"
```

This will return every reading of the variable you are checking for the current SSA version. It ignores all read accesses that are not for this version of the variable.

**Where is a variable read independently of versions?**

Let's imagine we want all read access to the variable and not just the ones for the current SSA version. We can do:

```smalltalk
variable := model module statements first left. "We could get any access to the variable here, not only the first one."

variable allReadAccesses.  "an OrderedCollection(PyIdentifier(14 - 14) PyIdentifier(50 - 50))"
```
**Where is a variable writen independently of version?**

Same as before, we can use the local declaration:

```smalltalk
variable := model module statements first left. "We could get any access to the variable here, not only the first one."

variable allWriteAccesses  "an OrderedCollection(PyVariable(1 - 1) PyVariable(18 - 18) PyVariable(36 - 36))"
```

> We can also use `#allAccesses` and `#versionAccesses` to mix read and write accesses.

**What is the assignment node of the variable I am manipulating?**

It is possible to get the nodes doing the assignemnts this way:

```smalltalk
lastVariableAccess := model module statements last arguments first.

lastVariableAccess ssaVersion writeAccesses collect: [ :access | access variableDeclarator ] "an OrderedCollection(PyAssignment(18 - 22) PyAssignment(36 - 40))"
```

The assignemnts nodes can be an assignemnt, a for, an augmented assignment or a for in clause. 

Do not forget that an assignemnt can be done to a tuple or list.

Also, there can be multiple ones, as shown in the example, in case of a phi version.