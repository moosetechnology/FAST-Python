Class {
	#name : 'FASTPyAssignmentTest',
	#superclass : 'FASTPythonEntityTest',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
FASTPyAssignmentTest >> testIsDefinition [

	self parse: 'x: int
y = 3'.


	self assert: model module statements first isDeclaration.
	self deny: model module statements second isDeclaration
]
