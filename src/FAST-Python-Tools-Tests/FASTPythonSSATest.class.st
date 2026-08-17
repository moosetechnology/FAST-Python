Class {
	#name : 'FASTPythonSSATest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Algos',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Algos'
}

{ #category : 'parsing' }
FASTPythonSSATest >> parseAndResolve: aString [

	self parse: aString.
	FASTPythonSSAVisitor resolve: model module
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementInAssignment [

	| assignedVar1 assignedVar2 assignedVar3 usedVar1 usedVar2 usedVar3 usedVar4 |
	self parseAndResolve: 'x = y = 3

print(x)
print(y)

x = 5

print(x)
print(y)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first right left.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'y_1'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 3.

	usedVar1 := model module statements second arguments first.
	self assert: usedVar1 ssaVersion identicalTo: assignedVar1 ssaVersion.

	usedVar2 := model module statements third arguments first.
	self assert: usedVar2 ssaVersion identicalTo: assignedVar2 ssaVersion.

	assignedVar3 := model module statements fourth left.
	self assert: assignedVar3 ssaVersion version equals: 2.
	self assert: assignedVar3 ssaName equals: 'x_2'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar3 := model module statements fifth arguments first.
	self assert: usedVar3 ssaVersion identicalTo: assignedVar3 ssaVersion.

	usedVar4 := model module statements sixth arguments first.
	self assert: usedVar4 ssaVersion identicalTo: assignedVar2 ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementInIfInBothBranchesAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'if y < 2:
    x = 4
else:
    x = 5
    
print(x)'.

	assignedVar1 := model module statements first thenClause statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first elseClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementInIfInThenAndUsage [

	| assignedVar2 usedVar |
	self parseAndResolve: 'if y < 2:
    x = 4
    
print(x)'.

	assignedVar2 := model module statements first thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'x_1'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementInIfInThenAndUsage2 [

	| assignedVar2 usedVar |
	self parseAndResolve: 'if y < 2:
    x = 4
else:
	function()
    
print(x)'.

	assignedVar2 := model module statements first thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'x_1'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion
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

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementNotUpdatedInIfAndUsage2 [

	| assignedVar usedVar |
	self parseAndResolve: 'x = 3

if y < 2:
    function1()
    
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

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementOfAttribute [

	| assignedVar |
	self parseAndResolve: 'x.y = 5'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x.y_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 1
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementOfAttributeAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'x.y = 5
	
print(x.y)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x.y_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementOfAttributeDoesNotClashWithIdentifier [ 

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 5

y.x = 6

x = 7

print(y.x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second left.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'y.x_1'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements third left.
	self assert: assignedVar3 ssaVersion version equals: 2.
	self assert: assignedVar3 ssaName equals: 'x_2'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 1.

	usedVar := model module statements fourth arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion
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
FASTPythonSSATest >> testForVariablesInListUsed [

	| assignedVarA assignedVarB usedVarA usedVarB |
	self parseAndResolve: 'for [a, b] in data:
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
FASTPythonSSATest >> testFunctionParameterModified [

	| parameterDeclaration assignedVar parameterUsage |
	self parseAndResolve: 'def func(x):
	if a:
		x = 2

	print(x)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.
	self assert: parameterDeclaration ssaVersion localDeclaration equals: parameterDeclaration localDeclaration.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.
	
	assignedVar := model module statements first statements first thenClause statements first left.
	self assert: assignedVar ssaVersion version equals: 2.
	self assert: assignedVar ssaName equals: 'x_2'.
	self assert: assignedVar ssaVersion localDeclaration equals: parameterDeclaration ssaVersion localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements second arguments first.
	self assert: parameterUsage ssaVersion isPhi.
	self assertCollection: parameterUsage ssaVersion ssaVariables hasSameElements: {
			parameterDeclaration ssaVersion.
			assignedVar ssaVersion }
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testFunctionParameterUsed [

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

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testFunctionWithDictionarySplatParameter [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'def sample(**kwargs):
    print(kwargs)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'kwargs_1'.
	self assert: parameterDeclaration ssaVersion localDeclaration equals: parameterDeclaration localDeclaration.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements first arguments first.
	self deny: parameterUsage ssaVersion isPhi.
	self assert: parameterUsage ssaVersion equals: parameterDeclaration ssaVersion
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testFunctionWithListSplatParameter [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'def sample(*args):
    print(args)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'args_1'.
	self assert: parameterDeclaration ssaVersion localDeclaration equals: parameterDeclaration localDeclaration.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements first arguments first.
	self deny: parameterUsage ssaVersion isPhi.
	self assert: parameterUsage ssaVersion equals: parameterDeclaration ssaVersion
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testFunctionWithSeparatorsParameters [

	| parameterDeclaration assignedVar parameterUsage |
	self parseAndResolve: 'def func(*, /, x):
	if a:
		x = 2

	print(x)'.

	parameterDeclaration := model module statements first parameters third.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.
	self assert: parameterDeclaration ssaVersion localDeclaration equals: parameterDeclaration localDeclaration.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.
	
	assignedVar := model module statements first statements first thenClause statements first left.
	self assert: assignedVar ssaVersion version equals: 2.
	self assert: assignedVar ssaName equals: 'x_2'.
	self assert: assignedVar ssaVersion localDeclaration equals: parameterDeclaration ssaVersion localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements second arguments first.
	self assert: parameterUsage ssaVersion isPhi.
	self assertCollection: parameterUsage ssaVersion ssaVariables hasSameElements: {
			parameterDeclaration ssaVersion.
			assignedVar ssaVersion }
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testFunctionWithTypedParameters [

	| parameterDeclaration assignedVar parameterUsage |
	self parseAndResolve: 'def func(x: Index):
	if a:
		x = 2

	print(x)'.

	parameterDeclaration := model module statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.
	self assert: parameterDeclaration ssaVersion localDeclaration equals: parameterDeclaration localDeclaration.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.
	
	assignedVar := model module statements first statements first thenClause statements first left.
	self assert: assignedVar ssaVersion version equals: 2.
	self assert: assignedVar ssaName equals: 'x_2'.
	self assert: assignedVar ssaVersion localDeclaration equals: parameterDeclaration ssaVersion localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements second arguments first.
	self assert: parameterUsage ssaVersion isPhi.
	self assertCollection: parameterUsage ssaVersion ssaVariables hasSameElements: {
			parameterDeclaration ssaVersion.
			assignedVar ssaVersion }
]

{ #category : 'tests' }
FASTPythonSSATest >> testGlobalReferencedInDefaultParameter [

	| assignedVar usedVar |
	self parseAndResolve: 'x = 5
	
def function(arg = x):
	return arg'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second parameters first defaultValue.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testLambdaParameterUsed [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'l = lambda x: x + 2

l(4)'.

	parameterDeclaration := model module statements first right parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'x_1'.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first right expression leftOperand.
	self assert: parameterUsage ssaVersion identicalTo: parameterDeclaration ssaVersion
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testListAssignement [

	| assignedVarX assignedVarY |
	self parseAndResolve: '[x, y] = [5, 6]'.

	assignedVarX := model module statements first left initializers first.
	self assert: assignedVarX ssaVersion version equals: 1.
	self assert: assignedVarX ssaName equals: 'x_1'.

	assignedVarY := model module statements first left initializers second.
	self assert: assignedVarY ssaVersion version equals: 1.
	self assert: assignedVarY ssaName equals: 'y_1'
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testListInListAssignement [

	| assignedVarX assignedVarY assignedVarZ |
	self parseAndResolve: '[x, [y, z]] = [5, [6, 7]]'.

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

{ #category : 'tests - parameters' }
FASTPythonSSATest >> testMethodParameterUsed [

	| parameterDeclaration parameterUsage |
	self parseAndResolve: 'class C():
	def method(self):
		return self'.

	parameterDeclaration := model module statements first statements first parameters first.
	self assert: parameterDeclaration ssaVersion version equals: 1.
	self assert: parameterDeclaration ssaName equals: 'self_1'.
	self assert: parameterDeclaration ssaVersion localUses size equals: 2.

	parameterUsage := model module statements first statements first statements first expression.
	self assert: parameterUsage ssaVersion identicalTo: parameterDeclaration ssaVersion
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testReAssignedVariableInFor [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 2
for y in range(5):
    x = 5

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testReAssignedVariableWithForVariable [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 2
	
for x in range(5):
    pass

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
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
FASTPythonSSATest >> testReAssignementInIfInBothBranchesAndUsage [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4
else:
    x = 5
    
print(x)'.

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
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second elseClause statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementInIfInThenAndUsage [

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
FASTPythonSSATest >> testReAssignementInIfInThenAndUsage2 [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4
    x = 6
    
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
	self assert: assignedVar2 ssaVersion localUses size equals: 1.

	assignedVar3 := model module statements second thenClause statements second left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - match' }
FASTPythonSSATest >> testReAssignementInMatchAllCasesThenAndUsage [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 4
match toto:
  case 1:
    x = 5
  case 2:
    x = 8

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second cases first statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second cases second statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - match' }
FASTPythonSSATest >> testReAssignementInMatchThenAndUsage [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 4
match toto:
  case 1:
    x = 5
  case 2:
    x = 8
  case 3:
    function1()
  case 4:
    function2()

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second cases first statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second cases second statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - match' }
FASTPythonSSATest >> testReAssignementInMatchWithDefaultThenAndUsage [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 4
match toto:
  case 1:
    x = 5
  case 3:
    function1()
  case 4:
    function2()
  case _:
    x = 8

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second cases first statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second cases fourth statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementInMultipleIfsAndUsage [

	| assignedVar1 assignedVar2 assignedVar3 usedVar1 usedVar2 |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4

print(x)

if y > 2:
	x = 5
    
print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 3.

	assignedVar2 := model module statements second thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 3.

	usedVar1 := model module statements third arguments first.
	self assert: usedVar1 ssaVersion isPhi.
	self assertCollection: usedVar1 ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }.

	assignedVar3 := model module statements fourth thenClause statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar2 := model module statements fifth arguments first.
	self assert: usedVar2 ssaVersion isPhi.
	self assertCollection: usedVar2 ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testReAssignementInMultipleIfsAndUsage2 [

	| assignedVar1 assignedVar2 assignedVar3 assignedVar4 assignedVar5 usedVar1 usedVar2 |
	self parseAndResolve: 'x = 3

if y < 2:
    x = 4
else:
	x = 6

print(x)

if y > 2:
	x = 5
else:
	x = 7
    
print(x)'.

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
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second elseClause statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar3 localDeclaration.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar1 := model module statements third arguments first.
	self assert: usedVar1 ssaVersion isPhi.
	self assertCollection: usedVar1 ssaVersion ssaVariables hasSameElements: {
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }.

	assignedVar4 := model module statements fourth thenClause statements first left.
	self assert: assignedVar4 ssaVersion version equals: 4.
	self assert: assignedVar4 ssaName equals: 'x_4'.
	self assert: assignedVar4 ssaVersion localDeclaration equals: assignedVar4 localDeclaration.
	self assert: assignedVar4 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar4 ssaVersion localUses size equals: 2.

	assignedVar5 := model module statements fourth elseClause statements first left.
	self assert: assignedVar5 ssaVersion version equals: 5.
	self assert: assignedVar5 ssaName equals: 'x_5'.
	self assert: assignedVar5 ssaVersion localDeclaration equals: assignedVar5 localDeclaration.
	self assert: assignedVar5 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar5 ssaVersion localUses size equals: 2.

	usedVar2 := model module statements fifth arguments first.
	self assert: usedVar2 ssaVersion isPhi.
	self assertCollection: usedVar2 ssaVersion ssaVariables hasSameElements: {
			assignedVar4 ssaVersion.
			assignedVar5 ssaVersion }
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

{ #category : 'tests - subscripts' }
FASTPythonSSATest >> testSubscriptAssignement [

	| assignedVar |
	self parseAndResolve: 'x[3] = 5'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x[3]_1'.

	self assert: assignedVar localDeclaration newVersionNumber equals: 2.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 1
]

{ #category : 'tests - subscripts' }
FASTPythonSSATest >> testSubscriptAssignementAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'x[3] = 5
	
print(x[3])'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x[3]_1'.
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

{ #category : 'tests - calls' }
FASTPythonSSATest >> testVariableAttributeUsedinACall [

	| assignedVar usedVar |
	self parseAndResolve: 'x.y = z
	
x.y()'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x.y_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second callee.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - calls' }
FASTPythonSSATest >> testVariableSliceUsedinACall [

	| assignedVar usedVar |
	self parseAndResolve: 'x[1] = z
	
x[1]()'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x[1]_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second callee.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - calls' }
FASTPythonSSATest >> testVariableUsedinACall [

	| assignedVar usedVar |
	self parseAndResolve: 'x = z
	
x()'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localDeclaration equals: assignedVar localDeclaration.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second callee.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]
