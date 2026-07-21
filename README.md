# FAST-Python

Famix AST representation for Python based on TreeSitter

<!-- TOC -->

- [FAST-Python](#fast-python)
  - [Installation](#installation)
  - [Quick start](#quick-start)
  - [Documentation](#documentation)
  - [Control flow graph](#control-flow-graph)
  - [Local resolutions](#local-resolutions)
    - [Shadowing](#shadowing)
    - [Limitations](#limitations)
      - [Separated dotted names](#separated-dotted-names)
      - [Access to non local entities](#access-to-non-local-entities)
  - [Moose versions compatibility](#moose-versions-compatibility)
  - [TreeSitter python version compatibility](#treesitter-python-version-compatibility)
  - [Python version compatibility](#python-version-compatibility)
  - [Contact](#contact)

<!-- /TOC -->

## Installation

To install this project on your Pharo image, execute the following script: 

```Smalltalk
Metacello new
	githubUser: 'moosetechnology' project: 'FAST-Python' commitish: 'main' path: 'src';
	baseline: 'FASTPython';
	load
```

To add this project to your baseline:

```Smalltalk
spec
	baseline: 'FASTPython'
	with: [ spec repository: 'github://moosetechnology/FAST-Python:main/src' ]
```

Note you can replace the #master by another branch such as #development or a tag such as #v1.0.0, #v1.? or #v1.2.? .

## Quick start

In order to parse a chain of character or a file you can do this:

```st
    FASTPythonImporter parse: 'if x > 0:
    if x < 10:
        1
    else:
        2
else:
    3'
```

Or

```st
    FASTPythonImporter parseFile: myFile
```

## Documentation

The best documentation to read about this project is located in Pharo Tree Sitter's repository here: [https://github.com/Evref-BL/Pharo-Tree-Sitter/blob/main/resources/doc/fast_importer.md](https://github.com/Evref-BL/Pharo-Tree-Sitter/blob/main/resources/doc/fast_importer.md) and here: [https://github.com/Evref-BL/Pharo-Tree-Sitter/blob/main/resources/doc/ts_utilities.md](https://github.com/Evref-BL/Pharo-Tree-Sitter/blob/main/resources/doc/ts_utilities.md)


## Control flow graph

It is possible to get a control flow graph of your python entities like this:

```smalltalk
FASTPythonCFGVisitor buildCFGOf: aModel allFunctionDefinitions first.

"or"

aModel allFunctionDefinitions first cfg
```

A CFG can be done on a function, method, class, module or lambda. 

You can visualize it in the inspector as a visualization and you can also export your CFG as a mermaid visualization using `#asMermaidScript`

## Local resolutions

It is possible to apply a local name resolution on a FAST-Python model by executing this piece of code:

```smalltalk
FASTPythonLocalResolverVisitor resolve: model module "Can be any behavioral entity"
```

Once this is executed, all nodes resolved will be able to provide a `#localDeclaration` pointing to the declaration/first use of the entity. This local declaration also knows all the `#localUses` of the entity.

The local declaration can be multiple things such as:
- An assignement
- A function/class/method declaration
- An import
- A parameter declaration
- A for loop to declare a variable
- ...

### Shadowing

In Python anything named can shadow anything named. For example we can declare a global variable then shadow it with an import, then shadow it with a function...

In the case of a shadowing, we manage it in two distinct ways: 
- If we know for sure that the entity will be the same kind of entity (for example, if the entity stays a variable because we assign two times values to the same variable), then they keep the same local declaration
- If the entity kind is different (for example we shadow a global variable with a function) or if we are not sure (if we shadow something with an imported entity for example), then we create a new local declaration

### Limitations

This project has a few limitations.

#### Separated dotted names

In case we have a dotted name but we do not use the same way to declare it, we are currently not keeping track of the declaration. For example, ßhis kind of uses are not supported:

```python
a.b.c = 3
d = a.b
print(d.c)
```

Here `a.b.c` will have a local declaration, but it will not know that`d.c` is a local use of this declared variable.

#### Access to non local entities

If the code has access to entities that we do not know, then we create a `FASTNonLocalDeclaration`. For example:

```python
import x

x.y
```

Here, in the expression `x.y` we will be able to link `x` to its declaration in the import, but we have no declaration for y since this is done in another project.
In that case, we associate it to a non local declaration. 

But, this has the current limit that if you access multiple times this `y` field of `x`, then each of them ill have their own non local declaration. 
This is not the way I would like the project to work and this could be improved by having all references point to the same non local declaration object, but we need time for this :)

## Moose versions compatibility

| Version 	| Compatible Moose versions    |
|-------------	|------------------------------|
| v1.x.x       	| Moose 13 |


## TreeSitter python version compatibility

TreeSitter python changed after the version 0.25 to remove expression statement for the produced tree. The parser do not work in 100% of the case for version <= 0.25. So if you have tests that are not passing, first check the version of tree-sitter-python you are using.

## Python version compatibility

This importer should work for Python 2 and 3 (but Python 2 code has less test coverage).

Latest tested python version is 3.13.3. Features added after this release might not be taken into account.

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.fr
