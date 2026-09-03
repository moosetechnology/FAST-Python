Class {
	#name : 'FASTPythonFunctionDefinitionTest',
	#superclass : 'FASTPythonEntityTest',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
FASTPythonFunctionDefinitionTest >> testIsAsync [

	self parse: 'def function(): pass
async def function2(): pass'.

	self deny: model module statements first isAsync.
	self assert: model module statements second isAsync
]
