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
