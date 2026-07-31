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

{ #category : 'tests - for' }
FASTPythonSSATest >> testForVariableUsed [

	| assignedVar usedVar |
	self parseAndResolve: 'for x in range(5):
    print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.

	usedVar := model module statements first statements first arguments first.
	self assert: assignedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testForVariablesInTupleUsed [

	| assignedVarA assignedVarB usedVarA usedVarB |
	self parseAndResolve: 'for a, b in data:
    print(a, b)'.

	assignedVarA := model module statements first left initializers first.
	self assert: assignedVarA ssaVersion version equals: 1.
	self assert: assignedVarA ssaName equals: 'a_1'.

	usedVarA := model module statements first statements first arguments first.
	self assert: assignedVarA ssaVersion identicalTo: assignedVarA ssaVersion.

	assignedVarB := model module statements first left initializers second.
	self assert: assignedVarB ssaVersion version equals: 1.
	self assert: assignedVarB ssaName equals: 'b_1'.

	usedVarB := model module statements first statements first arguments first.
	self assert: assignedVarB ssaVersion identicalTo: assignedVarB ssaVersion
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testParameterUsed [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'def func(x):
	print(x)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.

	parameterUsage := model module statements first statements first arguments first.
	self assert: parameterDeclaration ssaVersion identicalTo: parameterDeclaration ssaVersion
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

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testTupleAssignement [

	| assignedVarX assignedVarY |
	self parseAndResolve: 'x, y = 5, 6'.

	assignedVarX := model module statements first left initializers first.
	self assert: assignedVarX ssaVersion version equals: 1.
	self assert: assignedVarX ssaName equals: 'x_1'.

	assignedVarY := model module statements first left initializers second.
	self assert: assignedVarY ssaVersion version equals: 1.
	self assert: assignedVarY ssaName equals: 'y_1'
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testTupleInTupleAssignement [

	| assignedVarX assignedVarY assignedVarZ |
	self parseAndResolve: 'x, (y, z) = 5, (6, 7)'.

	assignedVarX := model module statements first left initializers first.
	self assert: assignedVarX ssaVersion version equals: 1.
	self assert: assignedVarX ssaName equals: 'x_1'.

	assignedVarY := model module statements first left initializers second initializers first.
	self assert: assignedVarY ssaVersion version equals: 1.
	self assert: assignedVarY ssaName equals: 'y_1'.

	assignedVarZ := model module statements first left initializers second initializers second.
	self assert: assignedVarZ ssaVersion version equals: 1.
	self assert: assignedVarZ ssaName equals: 'z_1'
]

{ #category : 'tests - non local declarations' }
FASTPythonSSATest >> testUndeclaredVariable [

	| undeclared |
	self parseAndResolve: 'print(x)'.

	undeclared := model module statements first arguments first.
	self assert: undeclared ssaVersion isNil
]
