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
	self assert: assignedVariable localDeclaration localUses size equals: 1.

	usedVariable := model module statements second.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses anyOne
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testTwoAssignationsCreateOneVariable [

	| assignment1 assignment2 assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x = 2
x'.

	assignment1 := model module statements first.
	assignedVariable := assignment1 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.

	assignment2 := model module statements second.
	assignedVariable := assignment2 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable equals: assignedVariable localDeclaration localUses first.

	usedVariable := model module statements third.
	self assert: usedVariable localDeclaration equals: assignment1.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]
