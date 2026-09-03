Class {
	#name : 'FASTPythonParameterTest',
	#superclass : 'FASTPythonEntityTest',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
FASTPythonParameterTest >> testIsSelf [

	| method1 method2 |
	self parse: 'class Class(ABC):
	def method(self, author: str):
		self.author = author
		return self.author

	def method2(this):
		pass'.

	method1 := model module statements first statements first.
	self assert: method1 parameters first isSelf.
	self deny: method1 parameters second isSelf.

	method2 := model module statements first statements second.
	self assert: method2 parameters first isSelf
]
