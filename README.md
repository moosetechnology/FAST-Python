# FAST-Python

Famix AST representation for Python based on TreeSitter

<!-- TOC -->

- [FAST-Python](#fast-python)
  - [Installation](#installation)
  - [Quick start](#quick-start)
  - [Documentation](#documentation)
  - [Control flow graph](#control-flow-graph)
  - [Local resolutions](#local-resolutions)
  - [Single Static Assignment (SSA)](#single-static-assignment-ssa)
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

You can find the documentation on some analysis possible here: [Analysis documentation](resources/doc/analysis.md).


## Control flow graph

It is possible to get a control flow graph of your python entities like this:

```smalltalk
FASTPythonCFGVisitor buildCFGOf: aModel allFunctionDefinitions first.

"or"

aModel allFunctionDefinitions first cfg
```

A CFG can be done on a function, method, class, module or lambda. 

You can visualize it in the inspector as a visualization and you can also export your CFG as a mermaid visualization using `#asMermaidScript`

For more information check the analysis documentation linked above.

## Local resolutions

It is possible to apply a local name resolution on a FAST-Python model by executing this piece of code:

```smalltalk
FASTPythonLocalResolverVisitor resolve: model module "Can be any behavioral entity"
```

Once this is executed, all nodes resolved will be able to provide a `#localDeclaration` pointing to the declaration/first use of the entity. This local declaration also knows all the `#localUses` of the entity.

For more information check the analysis documentation linked above.

## Single Static Assignment (SSA)

It is possible to build the SSA of a FAST-Python model like this:


It can be run like this:

```smalltalk
FASTPythonSSAVisitor resolve: model module
```

Then we can ask to any node representing a variable access `#ssaVersion`. This version is able to tell us where are the read and write accesses of this particular version of the variable.

For more information check the analysis documentation linked above.

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
