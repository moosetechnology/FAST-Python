# FAST-Python

Famix AST representation for Python based on TreeSitter

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

## Local variable resolutions

It is possible to apply a local variable name resolution on a FAST-Python model by executing this piece of code:

```smalltalk
FASTPythonLocalResolverVisitor resolve: model module
```

Once this is executed, all nodes representing a variable will be able to provide a `#localDeclaration` pointing to the first use of the variable. This local declaration also knows all the `#localUses` of the variable.

### Limitations

This has some limitations. For example, if we import a global variable, we cannot know if this is a global variable or something else. So we will not link it to any declaration. 

Also, this kind of uses are not supported:

```python
a.b.c = 3
d = a.b
print(d.c)
```

Here `a.b.c` will have a local declaration, but it will not know that`d.c` is a local use of this declared variable.



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
