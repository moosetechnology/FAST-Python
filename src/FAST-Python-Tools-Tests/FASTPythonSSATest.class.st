Class {
	#name : 'FASTPythonSSATest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Tools-Tests-Utilities',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Utilities'
}

{ #category : 'parsing' }
FASTPythonSSATest >> parseAndResolve: aString [

	model := self parse: aString.

	FASTPythonSSAVisitor resolve: model module
]

{ #category : 'tests' }
FASTPythonSSATest >> testSingleAssignement [

	| assignedVar |
	self parseAndResolve: 'x = 5'.

	assignedVar := model module statements first left.

	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.

	self assert: assignedVar localDeclaration newVersionNumber equals: 2
]
