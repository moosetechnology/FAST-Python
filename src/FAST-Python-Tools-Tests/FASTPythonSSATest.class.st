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
FASTPythonSSATest >> testAssignementNotUpdatedInIfAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'x = 3

if y < 2:
    function1()
else:
	function2()
    
print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testForVariableUsed [

	| assignedVar usedVar |
	self parseAndResolve: 'for x in range(5):
    print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements first statements first arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testForVariablesInTupleUsed [

	| assignedVarA assignedVarB usedVarA usedVarB |
	self parseAndResolve: 'for a, b in data:
    print(a, b)'.

	assignedVarA := model module statements first left initializers first.
	self assert: assignedVarA ssaVersion version equals: 1.
	self assert: assignedVarA ssaName equals: 'a_1'.
	self assert: assignedVarA ssaVersion localUses size equals: 2.

	usedVarA := model module statements first statements first arguments first.
	self assert: usedVarA ssaVersion identicalTo: assignedVarA ssaVersion.

	assignedVarB := model module statements first left initializers second.
	self assert: assignedVarB ssaVersion version equals: 1.
	self assert: assignedVarB ssaName equals: 'b_1'.
	self assert: assignedVarB ssaVersion localUses size equals: 2.

	usedVarB := model module statements first statements first arguments second.
	self assert: usedVarB ssaVersion identicalTo: assignedVarB ssaVersion
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testParameterUsed [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'def func(x):
	print(x)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements first arguments first.
	self assert: parameterUsage ssaVersion identicalTo: parameterDeclaration ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignement [

	| assignedVar1 assignedVar2 |
	self parseAndResolve: 'x = 3

x = 4'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 1
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementAndUsage [

	| assignedVar1 assignedVar2 usedVar1 usedVar2 |
	self parseAndResolve: 'x = 3

print(x)

  x = 4
    
print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	usedVar1 := model module statements second arguments first.
	self deny: usedVar1 ssaVersion isPhi.
	self assert: usedVar1 ssaVersion identicalTo: assignedVar1 ssaVersion.

	assignedVar2 := model module statements third left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar2 := model module statements fourth arguments first.
	self deny: usedVar2 ssaVersion isPhi.
	self assert: usedVar2 ssaVersion identicalTo: assignedVar2 ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementInIf [

	| assignedVar1 assignedVar2 |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 1
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementInIfAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4
    
print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testSingleAssignement [

	| assignedVar |
	self parseAndResolve: 'x = 5'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.

	self assert: assignedVar localDeclaration newVersionNumber equals: 2.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 1
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testSingleAssignementAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'x = 5
	
print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
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
