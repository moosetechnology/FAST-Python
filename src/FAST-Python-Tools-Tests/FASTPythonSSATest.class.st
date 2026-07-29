Class {
	#name : 'FASTPythonSSATest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Tools-Tests-Algos',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Algos'
}

{ #category : 'parsing' }
FASTPythonSSATest >> parseAndResolve: aString [

	model := self parse: aString.

	FASTPythonSSAVisitor resolve: model module
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testSingleAssignement [

	| assignedVar |
	self parseAndResolve: 'x = 5'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.

	self assert: assignedVar localDeclaration newVersionNumber equals: 2
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testSingleAssignementAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'x = 5
	
print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.

	usedVar := model module statements second arguments first.
	self assert: assignedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - non local declarations' }
FASTPythonSSATest >> testUndeclaredVariable [

	| undeclared |
	self parseAndResolve: 'print(x)'.

	undeclared := model module statements first arguments first.
	self assert: undeclared ssaVersion isNil
]
