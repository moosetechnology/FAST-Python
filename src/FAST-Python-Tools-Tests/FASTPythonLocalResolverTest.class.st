Class {
	#name : 'FASTPythonLocalResolverTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Tools-Tests-Utilities',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Utilities'
}

{ #category : 'resolving' }
FASTPythonLocalResolverTest >> parseAndResolve: aString [

	model := self parse: aString.

	FASTPythonLocalResolverVisitor resolve: model module
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testDeclarationAndUsageOfGlobalInModule [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testTwoAssignationsCreateOneDeclaration [

	| assignment1 assignment2 assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x = 2
x'.

	assignment1 := model module statements first.
	assignedVariable := assignment1 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	assignment2 := model module statements second.
	assignedVariable := assignment2 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable equals: assignedVariable localDeclaration localUses second.

	usedVariable := model module statements third.
	self assert: usedVariable localDeclaration equals: assignment1.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses third
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testUsageInCall [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
print(x)'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableAccessedInForIn [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'fruits = ["apple", "banana", "cherry"]
for x in fruits:
  pass'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'fruits'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.

	usedVariable := model module statements second right.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableOfFor [

	| for declared usedVariable |
	self parseAndResolve: 'for x in "banana":
  print(x)'.

	for := model module statements first.
	declared := for left.
	self assert: declared localDeclaration equals: for.
	self assert: declared localDeclaration left sourceCode equals: 'x'.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := for statements first arguments first.
	self assert: usedVariable localDeclaration equals: for.
	self assert: usedVariable equals: declared localDeclaration localUses second
]
