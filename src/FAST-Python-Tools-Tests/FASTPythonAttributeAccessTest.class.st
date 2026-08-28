Class {
	#name : 'FASTPythonAttributeAccessTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Model',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Model'
}

{ #category : 'tests' }
FASTPythonAttributeAccessTest >> testIsInstanceVariableAccess [

	| writeAccess writeAccessToObject readAccess |
	self parse: 'class Class:
	def method(self, author: str, obj):
		self.author = author
		obj.toto = author
		return self.author'.

	writeAccess := model module statements first statements first statements first left.
	self assert: writeAccess name equals: 'author'.
	self assert: writeAccess isInstanceVariableAccess.

	writeAccessToObject := model module statements first statements first statements second left.
	self assert: writeAccessToObject name equals: 'toto'.
	self deny: writeAccessToObject isInstanceVariableAccess.

	readAccess := model module statements first statements first statements third expression.
	self assert: readAccess name equals: 'author'.
	self assert: readAccess isInstanceVariableAccess
]

{ #category : 'tests' }
FASTPythonAttributeAccessTest >> testIsWriteVariableAccess [

	| writeAccess readAccess |
	self parse: 'class Class:
	def method(self, author: str, obj):
		self.author = author
		return self.author'.

	writeAccess := model module statements first statements first statements first left.
	self assert: writeAccess name equals: 'author'.
	self assert: writeAccess isInstanceVariableAccess.
	self assert: writeAccess isVariableWriteAccess.

	readAccess := model module statements first statements first statements second expression.
	self assert: readAccess name equals: 'author'.
	self assert: readAccess isInstanceVariableAccess.
	self deny: readAccess isVariableWriteAccess
]

{ #category : 'tests' }
FASTPythonAttributeAccessTest >> testMethodDefinition [

	| method |
	self parse: 'class Class:
	def method(self, author: str):
		self.author = author
		return self.author'.

	method := model module statements first statements first.

	self assert: method statements first left methodDefinition equals: method.
	self assert: method statements second expression methodDefinition equals: method
]
