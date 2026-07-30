Class {
	#name : 'FASTPythonLocalResolverTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Tools-Tests-Algos',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Algos'
}

{ #category : 'resolving' }
FASTPythonLocalResolverTest >> parseAndResolve: aString [

	model := self parse: aString.

	FASTPythonLocalResolverVisitor resolve: model module
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testAssignementToTuple [

	| assignedVariableX assignedVariableY usedVariableX |
	self parseAndResolve: 'x, y = 1, 2

print(x)'.

	assignedVariableX := model module statements first left initializers first.
	self assert: assignedVariableX localDeclaration equals: assignedVariableX.
	self assert: assignedVariableX localDeclaration name equals: 'x'.
	self assert: assignedVariableX localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariableX localDeclaration isVariableWriteAccess.
	self deny: assignedVariableX localDeclaration isNonLocalDeclaration.
	self assert: assignedVariableX localDeclaration localUses size equals: 2.
	self assert: assignedVariableX localDeclaration localUses first equals: assignedVariableX.

	usedVariableX := model module statements second arguments first.
	self assert: usedVariableX localDeclaration equals: assignedVariableX.
	self assert: usedVariableX equals: assignedVariableX localDeclaration localUses second.

	assignedVariableY := model module statements first left initializers second.
	self assert: assignedVariableY localDeclaration equals: assignedVariableY.
	self assert: assignedVariableY localDeclaration name equals: 'y'.
	self assert: assignedVariableY localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariableY localDeclaration isVariableWriteAccess.
	self deny: assignedVariableY localDeclaration isNonLocalDeclaration.
	self assert: assignedVariableY localDeclaration localUses size equals: 1.
	self assert: assignedVariableY localDeclaration localUses first equals: assignedVariableY
]

{ #category : 'tests - non local declarations' }
FASTPythonLocalResolverTest >> testAttributeAccessHalfResolved [
	"Here x is resolved but y is not resolved locally."

	| import importedEntity receiver value |
	self parseAndResolve: 'import x

x.y'.

	import := model module statements first.
	importedEntity := import importedEntities first.
	self assert: importedEntity localDeclaration equals: import.
	self assert: importedEntity localDeclaration importedEntities first segments last equals: 'x'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	receiver := model module statements second value.
	self assert: receiver localDeclaration equals: import.
	self deny: receiver localDeclaration isNonLocalDeclaration.
	self assert: receiver localDeclaration localUses second equals: receiver.
	
	value := model module statements second.
	self assert: value localDeclaration name equals: 'y'.
	self assert: value localDeclaration isNonLocalDeclaration.
	self assert: value localDeclaration localUses size equals: 1.
	self assert: value localDeclaration localUses first equals: value
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testCommentedGlobalUsage [

	| assignedVariable |
	self parseAndResolve: 'x = 3

# {x: 2}'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 1.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testDeclarationAndUsageOfGlobalInModule [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testFromImportedEntity [

	| import importedEntity call |
	self parseAndResolve: 'from matplotlib import __version__

print(__version__)'.

	import := model module statements first.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self deny: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first segments last equals: '__version__'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements second arguments first.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testFromImportedEntityWithAlias [

	| import importedEntity call |
	self parseAndResolve: 'from matplotlib import __version__ as v

print(v)'.

	import := model module statements first.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self assert: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first alias equals: 'v'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements second arguments first.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testFromImportedEntityWithAliasDoesNotShadowVariable [

	| import importedEntity call assignedVariable usedVariable1 usedVariable2 |
	self parseAndResolve: 'x = 1

print(x)

from y import x as func
	
func()

print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable1 := model module statements second arguments first.
	self assert: usedVariable1 localDeclaration equals: assignedVariable.
	self assert: usedVariable1 equals: assignedVariable localDeclaration localUses second.

	usedVariable2 := model module statements fifth arguments first.
	self assert: usedVariable2 localDeclaration equals: assignedVariable.
	self assert: usedVariable2 equals: assignedVariable localDeclaration localUses third.

	import := model module statements third.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self assert: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first alias equals: 'func'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements fourth callee.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - functions' }
FASTPythonLocalResolverTest >> testFunctionDeclaredAndCalled [

	| functionDefinition call |
	self parseAndResolve: 'def func():
	pass
	
func()'.

	functionDefinition := model module statements first.
	self assert: functionDefinition localDeclaration equals: functionDefinition.
	self assert: functionDefinition localDeclaration name equals: 'func'.
	self deny: functionDefinition localDeclaration isNonLocalDeclaration.
	self assert: functionDefinition localDeclaration localUses size equals: 2.
	self assert: functionDefinition localDeclaration localUses first equals: functionDefinition.

	call := model module statements second callee.
	self assert: call localDeclaration equals: functionDefinition.
	self assert: call equals: functionDefinition localDeclaration localUses second
]

{ #category : 'tests - parameters' }
FASTPythonLocalResolverTest >> testFunctionParameter [

	| declaration usedVariable |
	self parseAndResolve: 'def funct(y):
		return y'.

	declaration := model module statements first parameters first.
	self assert: declaration localDeclaration equals: declaration.
	self assert: declaration localDeclaration name equals: 'y'.
	self assert: declaration localDeclaration isVariableWriteAccess.
	self deny: declaration localDeclaration isNonLocalDeclaration.
	self assert: declaration localDeclaration localUses size equals: 2.
	self assert: declaration localDeclaration localUses first equals: declaration.

	usedVariable := model module statements first statements first expression.
	self assert: usedVariable localDeclaration equals: declaration.
	self assert: usedVariable equals: declaration localDeclaration localUses second
]

{ #category : 'tests - parameters' }
FASTPythonLocalResolverTest >> testFunctionParameterWithDefaultValue [

	| declaration usedVariable |
	self parseAndResolve: 'def funct(y=3):
		return y'.

	declaration := model module statements first parameters first.
	self assert: declaration localDeclaration equals: declaration.
	self assert: declaration localDeclaration name equals: 'y'.
	self assert: declaration localDeclaration isVariableWriteAccess.
	self deny: declaration localDeclaration isNonLocalDeclaration.
	self assert: declaration localDeclaration localUses size equals: 2.
	self assert: declaration localDeclaration localUses first equals: declaration.

	usedVariable := model module statements first statements first expression.
	self assert: usedVariable localDeclaration equals: declaration.
	self assert: usedVariable equals: declaration localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalAndTemporaryOfTheSameNameInFunction [

	| assignedGlobal usedGlobal assignedTemporary temporaryUsage1 temporaryUsage2 |
	self parseAndResolve: 'glob = 1

def fun():
    glob = 3
    print(glob)
    return glob

fun()
print(glob)'.

	assignedGlobal := model module statements first left.
	self assert: assignedGlobal localDeclaration equals: assignedGlobal.
	self assert: assignedGlobal localDeclaration name equals: 'glob'.
	self assert: assignedGlobal localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedGlobal localDeclaration isNonLocalDeclaration.
	self assert: assignedGlobal localDeclaration localUses size equals: 2.
	self assert: assignedGlobal localDeclaration localUses first equals: assignedGlobal.

	usedGlobal := model module statements fourth arguments first.
	self assert: usedGlobal localDeclaration equals: assignedGlobal.
	self assert: usedGlobal equals: assignedGlobal localDeclaration localUses second.

	assignedTemporary := model module statements second statements first left.
	self assert: assignedTemporary localDeclaration equals: assignedTemporary.
	self assert: assignedTemporary localDeclaration name equals: 'glob'.
	self assert: assignedTemporary localDeclaration variableDeclarator equals: model module statements second statements first.
	self deny: assignedTemporary localDeclaration isNonLocalDeclaration.
	self assert: assignedTemporary localDeclaration localUses size equals: 3.
	self assert: assignedTemporary localDeclaration localUses first equals: assignedTemporary.

	temporaryUsage1 := model module statements second statements second arguments first.
	self assert: temporaryUsage1 localDeclaration equals: assignedTemporary.
	self assert: temporaryUsage1 equals: assignedTemporary localDeclaration localUses second.

	temporaryUsage2 := model module statements second statements third expression.
	self assert: temporaryUsage2 localDeclaration equals: assignedTemporary.
	self assert: temporaryUsage2 equals: assignedTemporary localDeclaration localUses third
]

{ #category : 'tests - shadowing' }
FASTPythonLocalResolverTest >> testGlobalShadowedByImport [
	"Here we cannot know if the second printing is of a variable."

	| assignedVariable usedVariable import importedEntity usedImportedEntity |
	self parseAndResolve: 'x = 1
print(x)

import x

print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second.

	import := model module statements third.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self deny: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first segments last equals: 'x'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	usedImportedEntity := model module statements fourth arguments first.
	self assert: usedImportedEntity localDeclaration equals: import.
	self assert: usedImportedEntity equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - shadowing' }
FASTPythonLocalResolverTest >> testGlobalShadowedByImportAlias [
	"Here we cannot know if the second printing is of a variable."

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
print(x)

import a as x

print(x)'.

	self skip. "We need to update the behavior"
	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second.

	self deny: model module statements fourth arguments first hasLocalDeclaration
]

{ #category : 'tests - shadowing' }
FASTPythonLocalResolverTest >> testGlobalShadowedByImportInFunction [

	| assignedVariable usedVariable1 usedVariable2 |
	self parseAndResolve: 'matplotlib = 3

print(matplotlib)

def f():
    import matplotlib
    return matplotlib

print(matplotlib)'.

	self skip. "To update and fix"
	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'matplotlib'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable1 := model module statements second arguments first.
	self assert: usedVariable1 localDeclaration equals: assignedVariable.
	self assert: usedVariable1 equals: assignedVariable localDeclaration localUses second.

	usedVariable2 := model module statements fourth arguments first.
	self assert: usedVariable2 localDeclaration equals: assignedVariable.
	self assert: usedVariable2 equals: assignedVariable localDeclaration localUses third
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsageInCall [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInDictionaryValue [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 3

{x: 2}'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second initializers first key.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInFunction [

	| assignedVariable usedVariable |
	self parseAndResolve: 'glob = 1

def fun():
    return glob

print(fun())'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'glob'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second statements first expression.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInLambda [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 1

lambda: x'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second expression.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInList [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 3

[ x ]'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second initializers first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInSet [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 3

{ x }'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second initializers first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - globals' }
FASTPythonLocalResolverTest >> testGlobalUsedInTuple [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 3

(x, 2)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second initializers first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - shadowing' }
FASTPythonLocalResolverTest >> testImportShadowedByImport [
	"Here we cannot know if the second printing is of a variable."

	| import importedEntity1 usedImportedEntity1 importedEntity2 usedImportedEntity2 |
	self parseAndResolve: 'import time
	
print(time)

from time import time

print(time)'.

	import := model module statements first.
	importedEntity1 := import importedEntities anyOne.
	self assert: importedEntity1 localDeclaration equals: import.
	self deny: importedEntity1 localDeclaration importedEntities first hasAlias.
	self assert: importedEntity1 localDeclaration importedEntities first segments last equals: 'time'.
	self deny: importedEntity1 localDeclaration isNonLocalDeclaration.
	self assert: importedEntity1 localDeclaration localUses size equals: 4.
	self assert: importedEntity1 localDeclaration localUses first equals: importedEntity1.

	usedImportedEntity1 := model module statements second arguments first.
	self assert: usedImportedEntity1 localDeclaration equals: import.
	self assert: usedImportedEntity1 equals: importedEntity1 localDeclaration localUses second.

	importedEntity2 := model module statements third importedEntities anyOne.
	self assert: importedEntity2 localDeclaration equals: import.
	self assert: importedEntity2 localDeclaration localUses third equals: importedEntity2.

	usedImportedEntity2 := model module statements fourth arguments first.
	self assert: usedImportedEntity2 localDeclaration equals: import.
	self assert: usedImportedEntity2 equals: importedEntity2 localDeclaration localUses fourth
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testImportedEntity [

	| import importedEntity call |
	self parseAndResolve: 'import func
	
func()'.

	import := model module statements first.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self deny: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first segments last equals: 'func'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements second callee.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testImportedEntityWithAlias [

	| import importedEntity call |
	self parseAndResolve: 'import functi as func
	
func()'.

	import := model module statements first.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self assert: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first alias equals: 'func'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements second callee.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - imports' }
FASTPythonLocalResolverTest >> testImportedEntityWithAliasDoesNotShadowVariable [

	| import importedEntity call assignedVariable usedVariable1 usedVariable2 |
	self parseAndResolve: 'x = 1

print(x)

import x as func
	
func()

print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable1 := model module statements second arguments first.
	self assert: usedVariable1 localDeclaration equals: assignedVariable.
	self assert: usedVariable1 equals: assignedVariable localDeclaration localUses second.

	usedVariable2 := model module statements fifth arguments first.
	self assert: usedVariable2 localDeclaration equals: assignedVariable.
	self assert: usedVariable2 equals: assignedVariable localDeclaration localUses third.

	import := model module statements third.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self assert: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first alias equals: 'func'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	call := model module statements fourth callee.
	self assert: call localDeclaration equals: import.
	self assert: call equals: importedEntity localDeclaration localUses second
]

{ #category : 'tests - parameters' }
FASTPythonLocalResolverTest >> testLambdaParameter [

	| declaration usedVariable |
	self parseAndResolve: 'lambda y: y'.

	declaration := model module statements first parameters first.
	self assert: declaration localDeclaration equals: declaration.
	self assert: declaration localDeclaration name equals: 'y'.
	self assert: declaration localDeclaration isVariableWriteAccess.
	self deny: declaration localDeclaration isNonLocalDeclaration.
	self assert: declaration localDeclaration localUses size equals: 2.
	self assert: declaration localDeclaration localUses first equals: declaration.

	usedVariable := model module statements first expression.
	self assert: usedVariable localDeclaration equals: declaration.
	self assert: usedVariable equals: declaration localDeclaration localUses second
]

{ #category : 'tests - local variables' }
FASTPythonLocalResolverTest >> testLocalVariableInFunction [

	| assignedVariable usedVariable |
	self parseAndResolve: 'def f():
	x = 1
	return x
	
print(f())'.

	assignedVariable := model module statements first statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements first statements second expression.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - methods' }
FASTPythonLocalResolverTest >> testMethodRedefined [

	| declaration1 declaration2 |
	self parseAndResolve: 'class C:
    def meth(self):
        return self

    def meth(self):
        return self'.

	declaration1 := model module statements first statements first.
	self assert: declaration1 localDeclaration equals: declaration1.
	self assert: declaration1 localDeclaration name equals: 'meth'.
	self deny: declaration1 localDeclaration isNonLocalDeclaration.
	self assert: declaration1 localDeclaration localUses size equals: 2.
	self assert: declaration1 localDeclaration localUses first equals: declaration1.

	declaration2 := model module statements first statements second.
	self assert: declaration2 localDeclaration equals: declaration1.
	self assert: declaration1 localDeclaration localUses second equals: declaration2
]

{ #category : 'tests - parameters' }
FASTPythonLocalResolverTest >> testMethodSelfParameter [

	| declaration usedVariable |
	self parseAndResolve: 'class C:
    def meth(self):
        return self'.

	declaration := model module statements first statements first parameters first.
	self assert: declaration localDeclaration equals: declaration.
	self assert: declaration localDeclaration name equals: 'self'.
	self assert: declaration localDeclaration isVariableWriteAccess.
	self deny: declaration localDeclaration isNonLocalDeclaration.
	self assert: declaration localDeclaration localUses size equals: 2.
	self assert: declaration localDeclaration localUses first equals: declaration.

	usedVariable := model module statements first statements first statements first expression.
	self assert: usedVariable localDeclaration equals: declaration.
	self assert: usedVariable equals: declaration localDeclaration localUses second
]

{ #category : 'tests - parameters' }
FASTPythonLocalResolverTest >> testMethodSelfParameterWithDifferentName [

	| declaration usedVariable |
	self parseAndResolve: 'class C:
    def meth(this):
        return this'.

	declaration := model module statements first statements first parameters first.
	self assert: declaration localDeclaration equals: declaration.
	self assert: declaration localDeclaration name equals: 'this'.
	self assert: declaration localDeclaration isVariableWriteAccess.
	self deny: declaration localDeclaration isNonLocalDeclaration.
	self assert: declaration localDeclaration localUses size equals: 2.
	self assert: declaration localDeclaration localUses first equals: declaration.

	usedVariable := model module statements first statements first statements first expression.
	self assert: usedVariable localDeclaration equals: declaration.
	self assert: usedVariable equals: declaration localDeclaration localUses second
]

{ #category : 'tests - non local declarations' }
FASTPythonLocalResolverTest >> testNonLocalMethodAndVariable [

	| nonLocalCall nonLocalAccess |
	self parseAndResolve: 'print(x)'.

	nonLocalCall := model module statements first callee.
	self assert: nonLocalCall localDeclaration name equals: 'print'.
	self assert: nonLocalCall localDeclaration isNonLocalDeclaration.
	self assert: nonLocalCall localDeclaration localUses size equals: 1.
	self assert: nonLocalCall localDeclaration localUses first equals: nonLocalCall.

	nonLocalAccess := model module statements first arguments first.
	self assert: nonLocalAccess localDeclaration name equals: 'x'.
	self assert: nonLocalAccess localDeclaration isNonLocalDeclaration.
	self assert: nonLocalAccess localDeclaration localUses size equals: 1.
	self assert: nonLocalAccess localDeclaration localUses first equals: nonLocalAccess
]

{ #category : 'tests - shadowing' }
FASTPythonLocalResolverTest >> testParameterShadowedByAssignement [

	| parameter usedParameter assignedVariable usedVariable |
	self parseAndResolve: 'def func(param):
    print(param)
    param = 3
    print(param)'.

	parameter := model module statements first parameters first.
	self assert: parameter localDeclaration equals: parameter.
	self assert: parameter localDeclaration name equals: 'param'.
	self deny: parameter localDeclaration isNonLocalDeclaration.
	self assert: parameter localDeclaration localUses size equals: 2.
	self assert: parameter localDeclaration localUses first equals: parameter.

	usedParameter := model module statements first statements first arguments first.
	self assert: usedParameter localDeclaration equals: parameter.
	self assert: usedParameter equals: parameter localDeclaration localUses second.

	assignedVariable := model module statements first statements second left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'param'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first statements second.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements first statements third arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testTwoAssignationsCreateOneDeclaration [

	| assignedVariable1 assignedVariable2 usedVariable |
	self parseAndResolve: 'x = 1
x = 2
x'.

	assignedVariable1 := model module statements first left.
	self assert: assignedVariable1 localDeclaration equals: assignedVariable1.
	self assert: assignedVariable1 localDeclaration name equals: 'x'.
	self assert: assignedVariable1 localDeclaration isVariableWriteAccess.
	self assert: assignedVariable1 localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable1 localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable1 localDeclaration localUses size equals: 3.
	self assert: assignedVariable1 localDeclaration localUses first equals: assignedVariable1.

	assignedVariable2 := model module statements second left.
	self assert: assignedVariable2 localDeclaration equals: assignedVariable1.
	self assert: assignedVariable2 equals: assignedVariable1 localDeclaration localUses second.

	usedVariable := model module statements third.
	self assert: usedVariable localDeclaration equals: assignedVariable1.
	self assert: usedVariable equals: assignedVariable1 localDeclaration localUses third
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testTwoResolutionsDoNotClash [

	| assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
print(x)'.

	"Do a second resolution to ensure the first one is cleared"
	FASTPythonLocalResolverVisitor resolve: model module.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableAccessedInForIn [

	| assignedVariable usedVariable |
	self parseAndResolve: 'fruits = ["apple", "banana", "cherry"]
for x in fruits:
  pass'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'fruits'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.

	usedVariable := model module statements second right.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableAccessedInIf [

	| assignedVariable usedVariable1 usedVariable2 |
	self parseAndResolve: 'glob = 1

if glob < 3:
    print(glob)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'glob'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.

	usedVariable1 := model module statements second condition operands first.
	self assert: usedVariable1 localDeclaration equals: assignedVariable.
	self assert: usedVariable1 equals: assignedVariable localDeclaration localUses second.

	usedVariable2 := model module statements second thenClause statements first arguments first.
	self assert: usedVariable2 localDeclaration equals: assignedVariable.
	self assert: usedVariable2 equals: assignedVariable localDeclaration localUses third
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableDeclaredInFor [

	| declared usedVariable |
	self parseAndResolve: 'for x in "banana":
    i = 2

print(i)'.

	declared := model module statements first statements first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'i'.
	self assert: declared localDeclaration variableDeclarator equals: model module statements first statements first.
	self assert: declared localDeclaration isVariableWriteAccess.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - while' }
FASTPythonLocalResolverTest >> testVariableDeclaredInWhile [

	| declared usedVariable |
	self parseAndResolve: 'while False:
    i = 2

print(i)'.

	declared := model module statements first statements first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'i'.
	self assert: declared localDeclaration isVariableWriteAccess.
	self assert: declared localDeclaration variableDeclarator equals: model module statements first statements first.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - comprehensions' }
FASTPythonLocalResolverTest >> testVariableInListComprehensions [

	| declared usedVariable |
	self parseAndResolve: 'fruits = ["apple", "banana", "cherry", "kiwi", "mango"]

[x for x in fruits]'.

	declared := model module statements second forClauses first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'x'.
	self assert: declared localDeclaration isVariableWriteAccess.
	self assert: declared localDeclaration variableDeclarator equals: model module statements second forClauses first.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements second body.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - comprehensions' }
FASTPythonLocalResolverTest >> testVariableInListComprehensionsDoesNotLeak [
	"Here the x of the comprehension should not leek outside of it if we consider we are in Python 3"

	| import importedEntity declared usedVariable usedImportedEntity |
	self parseAndResolve: 'import x
	
fruits = ["apple", "banana", "cherry", "kiwi", "mango"]

[x for x in fruits]

print(x)'.

	import := model module statements first.
	importedEntity := import importedEntities anyOne.
	self assert: importedEntity localDeclaration equals: import.
	self deny: importedEntity localDeclaration importedEntities first hasAlias.
	self assert: importedEntity localDeclaration importedEntities first segments last equals: 'x'.
	self deny: importedEntity localDeclaration isNonLocalDeclaration.
	self assert: importedEntity localDeclaration localUses size equals: 2.
	self assert: importedEntity localDeclaration localUses first equals: importedEntity.

	usedImportedEntity := model module statements fourth arguments first.
	self assert: usedImportedEntity localDeclaration equals: import.
	self assert: usedImportedEntity equals: importedEntity localDeclaration localUses second.

	declared := model module statements third forClauses first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'x'.
	self assert: declared localDeclaration isVariableWriteAccess.
	self assert: declared localDeclaration variableDeclarator equals: model module statements third forClauses first.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements third body.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfFor [

	| declared usedVariable |
	self parseAndResolve: 'for x in "banana":
  print(x)'.

	declared := model module statements first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'x'.
	self assert: declared localDeclaration variableDeclarator equals: model module statements first.
	self assert: declared localDeclaration isVariableWriteAccess.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements first statements first arguments first.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForClashingWithOtherVariables [

	| assignedVariable assignedVariableInFor usedVariable |
	self parseAndResolve: 'x = 3

for x in range(5):
    print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	assignedVariableInFor := model module statements second left.
	self assert: assignedVariableInFor localDeclaration equals: assignedVariable.
	self assert: assignedVariableInFor equals: assignedVariableInFor localDeclaration localUses second.

	usedVariable := model module statements second statements first arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: usedVariable localDeclaration localUses third
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForRedefinedInside [

	| declared usedVariable |
	self parseAndResolve: 'for x in range(5):
    x += 1'.

	declared := model module statements first left.
	self assert: declared localDeclaration equals: declared.
	self assert: declared localDeclaration name equals: 'x'.
	self assert: declared localDeclaration variableDeclarator equals: model module statements first.
	self assert: declared localDeclaration isVariableWriteAccess.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements first statements first left.
	self assert: usedVariable localDeclaration equals: declared.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForStaysAfterFor [

	| assignedVariable usedVariable |
	self parseAndResolve: 'for x in range(5):
    pass

print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'x'.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: usedVariable localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForWithTuple [

	| declaredA usedVariableA declaredB usedVariableB |
	self parseAndResolve: 'for a, b in arg:
  print(a, b)'.

	declaredA := model module statements first left initializers first.
	self assert: declaredA localDeclaration equals: declaredA.
	self assert: declaredA localDeclaration name equals: 'a'.
	self assert: declaredA localDeclaration variableDeclarator equals: model module statements first.
	self assert: declaredA localDeclaration isVariableWriteAccess.
	self deny: declaredA localDeclaration isNonLocalDeclaration.
	self assert: declaredA localDeclaration localUses size equals: 2.
	self assert: declaredA localDeclaration localUses first equals: declaredA.

	usedVariableA := model module statements first statements first arguments first.
	self assert: usedVariableA localDeclaration equals: declaredA.
	self assert: usedVariableA equals: declaredA localDeclaration localUses second.

	declaredB := model module statements first left initializers second.
	self assert: declaredB localDeclaration equals: declaredB.
	self assert: declaredB localDeclaration name equals: 'b'.
	self assert: declaredA localDeclaration variableDeclarator equals: model module statements first.
	self assert: declaredB localDeclaration isVariableWriteAccess.
	self deny: declaredB localDeclaration isNonLocalDeclaration.
	self assert: declaredB localDeclaration localUses size equals: 2.
	self assert: declaredB localDeclaration localUses first equals: declaredB.

	usedVariableB := model module statements first statements first arguments second.
	self assert: usedVariableB localDeclaration equals: declaredB.
	self assert: usedVariableB equals: declaredB localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableRedefinedInIf [

	| assignedVariable assignedVariable2 usedVariable |
	self parseAndResolve: 'glob = 1

if True:
    glob = 3

print(glob)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable localDeclaration equals: assignedVariable.
	self assert: assignedVariable localDeclaration name equals: 'glob'.
	self assert: assignedVariable localDeclaration isVariableWriteAccess.
	self assert: assignedVariable localDeclaration variableDeclarator equals: model module statements first.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.

	assignedVariable2 := model module statements second thenClause statements first left.
	self assert: assignedVariable2 localDeclaration equals: assignedVariable.
	self assert: assignedVariable2 equals: assignedVariable localDeclaration localUses second.

	usedVariable := model module statements third arguments first.
	self assert: usedVariable localDeclaration equals: assignedVariable.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses third
]
