Class {
	#name : 'FASTPythonMethodDefinitionTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Model-Tests',
	#package : 'FAST-Python-Model-Tests'
}

{ #category : 'tests' }
FASTPythonMethodDefinitionTest >> testIsAbstract [

	| method1 method2 |
	self parse: 'class Class(ABC):
	def method(self, author: str):
		self.author = author
		return self.author
		
	@abstractmethod
	def method2(param):
		pass'.

	method1 := model module statements first statements first.
	self deny: method1 isAbstract.
	method2 := model module statements first statements second.
	self assert: method2 isAbstract
]

{ #category : 'tests' }
FASTPythonMethodDefinitionTest >> testIsStatic [

	| method1 method2 |
	self parse: 'class Class:
	def method(self, author: str):
		self.author = author
		return self.author
		
	@staticmethod
	def method2(param):
		return param'.

	method1 := model module statements first statements first.
	self deny: method1 isStatic.
	method2 := model module statements first statements second.
	self assert: method2 isStatic
]

{ #category : 'tests' }
FASTPythonMethodDefinitionTest >> testSelfName [

	| method1 method2 method3 |
	self parse: 'class Class:
	def method(self, author: str):
		self.author = author
		return self.author
		
	def method2(this):
		return this.author
		
	@staticmethod
	def method3(param):
		return param'.

	method1 := model module statements first statements first.
	self assert: method1 selfName equals: 'self'.
	method2 := model module statements first statements second.
	self assert: method2 selfName equals: 'this'.
	method3 := model module statements first statements third.
	self assert: method3 selfName isNil
]
