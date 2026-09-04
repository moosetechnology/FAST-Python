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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - assignments' }
FASTPythonSSATest >> testAssignementToUnpackingAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'a, *b = [1, 2, 3]

print(a)'.

	assignedVar1 := model module statements first left initializers first.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'a_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first left initializers second expression.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'b_1'.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar1 ssaVersion
]

{ #category : 'tests - if' }
FASTPythonSSATest >> testAssignmentInIfWithMultipleElif [

	| assignedVar1 assignedVar2 assignedVar3 assignedVar4 usedVar |
	self parseAndResolve: 'x = 0

if a:
	x = 1
elif b:
	x = 2
elif c:
	x = 3
else:
	function()

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.

	assignedVar2 := model module statements second thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.

	assignedVar3 := model module statements second elifClauses first statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.

	assignedVar4 := model module statements second elifClauses second statements first left.
	self assert: assignedVar4 ssaVersion version equals: 4.
	self assert: assignedVar4 ssaName equals: 'x_4'.
	self assert: assignedVar4 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion.
			assignedVar3 ssaVersion.
			assignedVar4 ssaVersion }
]

{ #category : 'tests - if' }
FASTPythonSSATest >> testAssignmentInOneElif [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'if a:
	x = 1
elif b:
	x = 2
else:
	function()

print(x)'.

	assignedVar1 := model module statements first thenClause statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first elifClauses first statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - ternary' }
FASTPythonSSATest >> testAssignmentInTernaryExpressionAndUsage [

	| assignedVar1 usedVar assignedVar2 |
	self parseAndResolve: 'x = 3
	
(x := 1) if a else 2

print(x)'.
	self skip.
	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second thenExpression.
	self assert: assignedVar2 ssaVersion version equals: 1.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - ternary' }
FASTPythonSSATest >> testAssignmentToTernaryExpressionAndUsage [

	| assignedVar1 usedVar |
	self parseAndResolve: 'x = 1 if a else 2

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.
	self assert: assignedVar1 ssaVersion localUses first equals: assignedVar1.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar1 ssaVersion.
	self assert: usedVar equals: assignedVar1 ssaVersion localUses second
]

{ #category : 'tests - augmented assignments' }
FASTPythonSSATest >> testAugmentedAssignAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

x += 1

print(x)'.

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
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion
]

{ #category : 'tests - augmented assignments' }
FASTPythonSSATest >> testAugmentedAssignInConditional [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

if a:
	x += 1

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testForElseAndUsage [

	| assignedVar usedVar assignedVar2 |
	self parseAndResolve: 'for x in range(5):
    pass
else:
    x = 10

print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first elseClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - for' }
FASTPythonSSATest >> testForLoopReAssignAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

for i in range(5):
    x = i

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
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

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testGlobalReAssignmentBumpsVersionOfSharedModuleDeclaration [

	| assignedVar1 globalVar assignedVar2 usedVar1 usedVar2 |
	self parseAndResolve: 'x = 1

def f():
    global x
    x = 2
    print(x)

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	globalVar := model module statements second statements first variables first.
	self assert: globalVar ssaVersion identicalTo: assignedVar1 ssaVersion.

	assignedVar2 := model module statements second statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 3.

	usedVar1 := model module statements second statements third arguments first.
	self deny: usedVar1 ssaVersion isPhi.
	self assert: usedVar1 ssaVersion identicalTo: assignedVar2 ssaVersion.

	usedVar2 := model module statements third arguments first.
	self deny: usedVar2 ssaVersion isPhi.
	self assert: usedVar2 ssaVersion identicalTo: assignedVar2 ssaVersion
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

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testGlobalSharedByMultipleFunctions [

	| assignedVariable globalVariableInInc assignedVariableInInc usedVariableInInc globalVariableInReset assignedVariableInReset |
	self parseAndResolve: 'x = 1

def inc():
    global x
    x = x + 1

def reset():
    global x
    x = 0'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 3.

	globalVariableInInc := model module statements second statements first variables first.
	self assert: globalVariableInInc ssaVersion identicalTo: assignedVariable ssaVersion.

	assignedVariableInInc := model module statements second statements second left.
	self assert: assignedVariableInInc ssaVersion version equals: 2.
	self assert: assignedVariableInInc ssaName equals: 'x_2'.
	self assert: assignedVariableInInc ssaVersion localDeclaration equals: assignedVariableInInc localDeclaration.
	self assert: assignedVariableInInc ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInInc ssaVersion localUses size equals: 2.

	usedVariableInInc := model module statements second statements second right leftOperand.
	self deny: usedVariableInInc ssaVersion isPhi.
	self assert: usedVariableInInc ssaVersion identicalTo: assignedVariable ssaVersion.

	globalVariableInReset := model module statements third statements first variables first.
	self assert: globalVariableInReset ssaVersion identicalTo: assignedVariableInInc ssaVersion.

	assignedVariableInReset := model module statements third statements second left.
	self assert: assignedVariableInReset ssaVersion version equals: 3.
	self assert: assignedVariableInReset ssaName equals: 'x_3'.
	self assert: assignedVariableInReset ssaVersion localDeclaration equals: assignedVariableInReset localDeclaration.
	self assert: assignedVariableInReset ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInReset ssaVersion localUses size equals: 1
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testGlobalStatementAndInnerFunctions [

	| assignedVariable assignedVariableInOuterFunction globalVariable assignedVariableInInnerFunction |
	self parseAndResolve: 'x = 0

def outer():
    x = 1

    def inner():
        global x
        x = 2

    inner()'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 2.

	assignedVariableInOuterFunction := model module statements second statements first left.
	self assert: assignedVariableInOuterFunction ssaVersion version equals: 1.
	self assert: assignedVariableInOuterFunction ssaName equals: 'x_1'.
	self assert: assignedVariableInOuterFunction ssaVersion localDeclaration equals: assignedVariableInOuterFunction localDeclaration.
	self assert: assignedVariableInOuterFunction ssaVersion localUses size equals: 1.

	globalVariable := model module statements second statements second statements first variables first.
	self assert: globalVariable ssaVersion identicalTo: assignedVariable ssaVersion.

	assignedVariableInInnerFunction := model module statements second statements second statements second left.
	self assert: assignedVariableInInnerFunction ssaVersion version equals: 2.
	self assert: assignedVariableInInnerFunction ssaName equals: 'x_2'.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariableInInnerFunction localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localUses size equals: 1
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testGlobalStatementInFunction [

	| assignedVariable usedVariable |
	self parseAndResolve: 'def f():
    global x
    x = 2

print(x)'.

	assignedVariable := model module statements first statements second left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 2.

	usedVariable := model module statements second arguments first.
	self deny: usedVariable ssaVersion isPhi.
	self assert: usedVariable ssaVersion identicalTo: assignedVariable ssaVersion
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testGlobalStatementToExistingVar [

	| assignedVariable globalVariable usedVariableInFunction |
	self parseAndResolve: 'x = 1

def f():
	global x
	print(x)'.

	assignedVariable := model module statements first left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 3.

	globalVariable := model module statements second statements first variables first.
	self assert: globalVariable ssaVersion identicalTo: assignedVariable ssaVersion.

	usedVariableInFunction := model module statements second statements second arguments first.
	self deny: usedVariableInFunction ssaVersion isPhi.
	self assert: usedVariableInFunction ssaVersion identicalTo: assignedVariable ssaVersion
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

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testListComprehensionVariableDoesNotLeak [

	| usedVar |
	self parseAndResolve: '[i for i in items]

print(i)'.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion isNil
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
FASTPythonSSATest >> testNestedForLoop [

	| assignedVarX1 assignedVarX2 usedVar |
	self parseAndResolve: 'x = 1

for i in range(5):
    for j in range(5):
        x = i + j

print(x)'.

	assignedVarX1 := model module statements first left.
	self assert: assignedVarX1 ssaVersion version equals: 1.
	self assert: assignedVarX1 ssaName equals: 'x_1'.
	self assert: assignedVarX1 ssaVersion localUses size equals: 2.

	assignedVarX2 := model module statements second statements first statements first left.
	self assert: assignedVarX2 ssaVersion version equals: 2.
	self assert: assignedVarX2 ssaName equals: 'x_2'.
	self assert: assignedVarX2 ssaVersion localDeclaration equals: assignedVarX1 ssaVersion localDeclaration.
	self assert: assignedVarX2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVarX1 ssaVersion.
			assignedVarX2 ssaVersion }
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNestedFunctionShadowingOuter [

	| assignedOuter assignedInner usedOuter usedInner |
	self parseAndResolve: 'x = 1

def func():
    x = 2
    print(x)

func()

print(x)'.

	assignedOuter := model module statements first left.
	self assert: assignedOuter ssaVersion version equals: 1.
	self assert: assignedOuter ssaName equals: 'x_1'.
	self assert: assignedOuter ssaVersion localUses size equals: 2.

	assignedInner := model module statements second statements first left.
	self assert: assignedInner ssaVersion version equals: 1.
	self assert: assignedInner ssaName equals: 'x_1'.
	self assert: assignedInner ssaVersion localDeclaration equals: assignedInner localDeclaration.
	self deny: assignedInner ssaVersion localDeclaration identicalTo: assignedOuter localDeclaration.
	self assert: assignedInner ssaVersion localUses size equals: 2.

	usedInner := model module statements second statements second arguments first.
	self assert: usedInner ssaVersion identicalTo: assignedInner ssaVersion.

	usedOuter := model module statements fourth arguments first.
	self assert: usedOuter ssaVersion identicalTo: assignedOuter ssaVersion
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNonlocalStatementBindsToNearestEnclosingDeclaration [

	| assignedVariableInGrand assignedVariableInMiddle nonlocalVariable assignedVariableInInnerFunction |
	self parseAndResolve: 'def grand():
    x = 1

    def middle():
        x = 2

        def inner():
            nonlocal x
            x = 3

        inner()'.

	assignedVariableInGrand := model module statements first statements first left.
	self assert: assignedVariableInGrand ssaVersion version equals: 1.
	self assert: assignedVariableInGrand ssaName equals: 'x_1'.
	self assert: assignedVariableInGrand ssaVersion localDeclaration equals: assignedVariableInGrand localDeclaration.
	self assert: assignedVariableInGrand ssaVersion localUses size equals: 1.

	assignedVariableInMiddle := model module statements first statements second statements first left.
	self assert: assignedVariableInMiddle ssaVersion version equals: 1.
	self assert: assignedVariableInMiddle ssaName equals: 'x_1'.
	self assert: assignedVariableInMiddle ssaVersion localDeclaration equals: assignedVariableInMiddle localDeclaration.
	self assert: assignedVariableInMiddle ssaVersion localUses size equals: 2.

	nonlocalVariable := model module statements first statements second statements second statements first variables first.
	self assert: nonlocalVariable ssaVersion identicalTo: assignedVariableInMiddle ssaVersion.

	assignedVariableInInnerFunction := model module statements first statements second statements second statements second left.
	self assert: assignedVariableInInnerFunction ssaVersion version equals: 2.
	self assert: assignedVariableInInnerFunction ssaName equals: 'x_2'.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariableInInnerFunction localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariableInMiddle ssaVersion localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localUses size equals: 1
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNonlocalStatementReAssignmentBumpsVersionOfOuterDeclaration [

	| assignedVar1 nonlocalVar assignedVar2 usedVar1 usedVar2 |
	self parseAndResolve: 'def outer():
    x = 1
    def inner():
        nonlocal x
        x = 2
        print(x)

    inner()
    print(x)'.

	assignedVar1 := model module statements first statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	nonlocalVar := model module statements first statements second statements first variables first.
	self assert: nonlocalVar ssaVersion identicalTo: assignedVar1 ssaVersion.

	assignedVar2 := model module statements first statements second statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 3.

	usedVar1 := model module statements first statements second statements third arguments first.
	self deny: usedVar1 ssaVersion isPhi.
	self assert: usedVar1 ssaVersion identicalTo: assignedVar2 ssaVersion.

	usedVar2 := model module statements first statements fourth arguments first.
	self deny: usedVar2 ssaVersion isPhi.
	self assert: usedVar2 ssaVersion identicalTo: assignedVar2 ssaVersion
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNonlocalStatementSharedByInnerFunctions [

	| assignedVariable nonlocalVariableInInc assignedVariableInInc usedVariableInInc nonlocalVariableInReset assignedVariableInReset |
	self parseAndResolve: 'def outer():
    x = 1

    def inc():
        nonlocal x
        x = x + 1

    def reset():
        nonlocal x
        x = 0

    inc()
    reset()'.

	assignedVariable := model module statements first statements first left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 3.

	nonlocalVariableInInc := model module statements first statements second statements first variables first.
	self assert: nonlocalVariableInInc ssaVersion identicalTo: assignedVariable ssaVersion.

	assignedVariableInInc := model module statements first statements second statements second left.
	self assert: assignedVariableInInc ssaVersion version equals: 2.
	self assert: assignedVariableInInc ssaName equals: 'x_2'.
	self assert: assignedVariableInInc ssaVersion localDeclaration equals: assignedVariableInInc localDeclaration.
	self assert: assignedVariableInInc ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInInc ssaVersion localUses size equals: 2.

	usedVariableInInc := model module statements first statements second statements second right leftOperand.
	self deny: usedVariableInInc ssaVersion isPhi.
	self assert: usedVariableInInc ssaVersion identicalTo: assignedVariable ssaVersion.

	nonlocalVariableInReset := model module statements first statements third statements first variables first.
	self assert: nonlocalVariableInReset ssaVersion identicalTo: assignedVariableInInc ssaVersion.

	assignedVariableInReset := model module statements first statements third statements second left.
	self assert: assignedVariableInReset ssaVersion version equals: 3.
	self assert: assignedVariableInReset ssaName equals: 'x_3'.
	self assert: assignedVariableInReset ssaVersion localDeclaration equals: assignedVariableInReset localDeclaration.
	self assert: assignedVariableInReset ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInReset ssaVersion localUses size equals: 1
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNonlocalStatementWithMultipleVariables [

	| assignedVariableX assignedVariableY nonlocalVariableX nonlocalVariableY assignedVariableXInInnerFunction assignedVariableYInInnerFunction |
	self parseAndResolve: 'def outer():
    x = 1
    y = 2

    def inner():
        nonlocal x, y
        x = 10
        y = 20

    inner()'.

	assignedVariableX := model module statements first statements first left.
	self assert: assignedVariableX ssaVersion version equals: 1.
	self assert: assignedVariableX ssaName equals: 'x_1'.
	self assert: assignedVariableX ssaVersion localDeclaration equals: assignedVariableX localDeclaration.
	self assert: assignedVariableX ssaVersion localUses size equals: 2.

	assignedVariableY := model module statements first statements second left.
	self assert: assignedVariableY ssaVersion version equals: 1.
	self assert: assignedVariableY ssaName equals: 'y_1'.
	self assert: assignedVariableY ssaVersion localDeclaration equals: assignedVariableY localDeclaration.
	self assert: assignedVariableY ssaVersion localUses size equals: 2.

	nonlocalVariableX := model module statements first statements third statements first variables first.
	self assert: nonlocalVariableX ssaVersion identicalTo: assignedVariableX ssaVersion.

	nonlocalVariableY := model module statements first statements third statements first variables second.
	self assert: nonlocalVariableY ssaVersion identicalTo: assignedVariableY ssaVersion.

	assignedVariableXInInnerFunction := model module statements first statements third statements second left.
	self assert: assignedVariableXInInnerFunction ssaVersion version equals: 2.
	self assert: assignedVariableXInInnerFunction ssaName equals: 'x_2'.
	self assert: assignedVariableXInInnerFunction ssaVersion localDeclaration equals: assignedVariableXInInnerFunction localDeclaration.
	self assert: assignedVariableXInInnerFunction ssaVersion localDeclaration equals: assignedVariableX ssaVersion localDeclaration.
	self assert: assignedVariableXInInnerFunction ssaVersion localUses size equals: 1.

	assignedVariableYInInnerFunction := model module statements first statements third statements third left.
	self assert: assignedVariableYInInnerFunction ssaVersion version equals: 2.
	self assert: assignedVariableYInInnerFunction ssaName equals: 'y_2'.
	self assert: assignedVariableYInInnerFunction ssaVersion localDeclaration equals: assignedVariableYInInnerFunction localDeclaration.
	self assert: assignedVariableYInInnerFunction ssaVersion localDeclaration equals: assignedVariableY ssaVersion localDeclaration.
	self assert: assignedVariableYInInnerFunction ssaVersion localUses size equals: 1
]

{ #category : 'tests - scopes' }
FASTPythonSSATest >> testNonlocalStatementWriteInInnerFunctionAfterRead [

	| assignedVariable nonlocalVariable usedVariableBeforeWrite assignedVariableInInnerFunction usedVariableAfterCall |
	self parseAndResolve: 'def outer():
    x = 1

    def inner():
        nonlocal x
        print(x)
        x = 2

    inner()
    print(x)'.

	assignedVariable := model module statements first statements first left.
	self assert: assignedVariable ssaVersion version equals: 1.
	self assert: assignedVariable ssaName equals: 'x_1'.
	self assert: assignedVariable ssaVersion localDeclaration equals: assignedVariable localDeclaration.
	self assert: assignedVariable ssaVersion localUses size equals: 3.

	nonlocalVariable := model module statements first statements second statements first variables first.
	self assert: nonlocalVariable ssaVersion identicalTo: assignedVariable ssaVersion.

	usedVariableBeforeWrite := model module statements first statements second statements second arguments first.
	self deny: usedVariableBeforeWrite ssaVersion isPhi.
	self assert: usedVariableBeforeWrite ssaVersion identicalTo: assignedVariable ssaVersion.

	assignedVariableInInnerFunction := model module statements first statements second statements third left.
	self assert: assignedVariableInInnerFunction ssaVersion version equals: 2.
	self assert: assignedVariableInInnerFunction ssaName equals: 'x_2'.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariableInInnerFunction localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localDeclaration equals: assignedVariable ssaVersion localDeclaration.
	self assert: assignedVariableInInnerFunction ssaVersion localUses size equals: 2.

	usedVariableAfterCall := model module statements first statements fourth arguments first.
	self deny: usedVariableAfterCall ssaVersion isPhi.
	self assert: usedVariableAfterCall ssaVersion identicalTo: assignedVariableInInnerFunction ssaVersion
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

{ #category : 'tests - if' }
FASTPythonSSATest >> testReAssignementInBothBranchesOfNestedIf [

	| assignedVar1 assignedVar2 assignedVar3 usedVar |
	self parseAndResolve: 'x = 1

if a:
    if b:
        x = 2
    else:
        x = 3

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second thenClause statements first thenClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	assignedVar3 := model module statements second thenClause statements first elseClause statements first left.
	self assert: assignedVar3 ssaVersion version equals: 3.
	self assert: assignedVar3 ssaName equals: 'x_3'.
	self assert: assignedVar3 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar3 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion.
			assignedVar3 ssaVersion }
]

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
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

{ #category : 'tests - if' }
FASTPythonSSATest >> testReAssignementInNestedIf [

	| assignedVar1 usedVar assignedVar2 |
	self parseAndResolve: 'x = 1

if a:
    if b:
        x = 2

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second thenClause statements first thenClause statements first left.
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
FASTPythonSSATest >> testReAssignementUsingSelf [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

x = x + 4'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	usedVar := model module statements second right leftOperand.
	self assert: usedVar ssaVersion identicalTo: assignedVar1 ssaVersion.
	self assert: usedVar identicalTo: assignedVar1 ssaVersion localUses second.

	assignedVar2 := model module statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 1
]

{ #category : 'tests' }
FASTPythonSSATest >> testSSAVersionFollowPreviouslyShadowedName [

	| assignedVar1 assignedVar2 usedVar1 usedFunction usedVar2 |
	self parseAndResolve: 'x = 3

print(x)

def x(): pass

print(x)

x = 4

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	usedVar1 := model module statements second arguments first.
	self assert: usedVar1 ssaVersion identicalTo: assignedVar1 ssaVersion.

	usedFunction := model module statements fourth arguments first.
	self assert: usedFunction ssaVersion isNil.

	assignedVar2 := model module statements fifth left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar2 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar2 := model module statements sixth arguments first.
	self assert: usedVar2 ssaVersion identicalTo: assignedVar2 ssaVersion
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

{ #category : 'tests - try' }
FASTPythonSSATest >> testTryAssignAndUsage [

	| assignedVar usedVar |
	self parseAndResolve: 'try:
    x = 1
except:
    function()

print(x)'.

	assignedVar := model module statements first statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar ssaVersion
]

{ #category : 'tests - try' }
FASTPythonSSATest >> testTryExceptAssignAndUsage [

	| assignedVar1 usedVar |
	self parseAndResolve: 'try:
    function()
except:
    x = 1

print(x)'.

	assignedVar1 := model module statements first excepts first statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar1 ssaVersion
]

{ #category : 'tests - try' }
FASTPythonSSATest >> testTryExceptReAssignAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

try:
    function()
except:
    x = 1

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second excepts first statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion
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

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusAlongsidePlainAssignment [

	| walrus assignedVar2 usedVar |
	self parseAndResolve: 'x := 1
x = 2
print(x)'.

	walrus := model module statements first.
	self assert: walrus ssaVersion version equals: 1.
	self assert: walrus ssaName equals: 'x_1'.
	self assert: walrus ssaVersion localUses size equals: 1.

	assignedVar2 := model module statements second left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.
	self assert: assignedVar2 ssaVersion localDeclaration equals: walrus ssaVersion localDeclaration.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion identicalTo: assignedVar2 ssaVersion.
	self assert: usedVar equals: assignedVar2 ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusAndRead [

	| walrus usedVariable |
	self parseAndResolve: 'x := 1
print(x)'.

	walrus := model module statements first.
	self assert: walrus ssaVersion version equals: 1.
	self assert: walrus ssaName equals: 'x_1'.
	self assert: walrus ssaVersion localUses size equals: 2.
	self assert: walrus ssaVersion localUses first equals: walrus.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable ssaVersion identicalTo: walrus ssaVersion.
	self assert: usedVariable equals: walrus ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInComprehensionFilterLeaks [

	| walrus usedVariable |
	self parseAndResolve: 'result = [y for x in items if (y := x)]
print(y)'.

	self skip. "Todo"
	walrus := model module statements first right conditions first.
	self assert: walrus ssaVersion version equals: 1.
	self assert: walrus ssaName equals: 'y_1'.
	self assert: walrus ssaVersion localUses size equals: 2.
	self assert: walrus ssaVersion localUses first equals: walrus.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable ssaVersion identicalTo: walrus ssaVersion.
	self assert: usedVariable equals: walrus ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInConditionalBranch [

	| walrus1 walrus2 usedVar |
	self parseAndResolve: 'x := 0
if a:
    x := 1
print(x)'.

	walrus1 := model module statements first.
	self assert: walrus1 ssaVersion version equals: 1.
	self assert: walrus1 ssaName equals: 'x_1'.
	self assert: walrus1 ssaVersion localUses size equals: 2.

	walrus2 := model module statements second thenClause statements first.
	self assert: walrus2 ssaVersion version equals: 2.
	self assert: walrus2 ssaName equals: 'x_2'.
	self assert: walrus2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			walrus1 ssaVersion.
			walrus2 ssaVersion }
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInFunctionCallArgument [

	| walrus |
	self parseAndResolve: 'print(x := 5)'.

	walrus := model module statements first arguments first.
	self assert: walrus ssaVersion version equals: 1.
	self assert: walrus ssaName equals: 'x_1'.
	self assert: walrus ssaVersion localUses size equals: 1.
	self assert: walrus ssaVersion localUses first equals: walrus
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInTernaryThenBranch [

	| assignedVar1 usedVar walrus2 |
	self parseAndResolve: 'x = 3
(x := 1) if a else 2
print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	walrus2 := model module statements second thenExpression.
	self assert: walrus2 ssaVersion version equals: 2.
	self assert: walrus2 ssaName equals: 'x_2'.
	self assert: walrus2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			walrus2 ssaVersion }
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInWhileLoop [

	| walrusInit walrusCond usedVar |
	self parseAndResolve: 'x = 0
while (x := x + 1) < 10:
    pass
print(x)'.

	walrusInit := model module statements first left.
	self assert: walrusInit ssaVersion version equals: 1.
	self assert: walrusInit ssaName equals: 'x_1'.
	self assert: walrusInit ssaVersion localUses size equals: 1.

	walrusCond := model module statements second condition operands first.
	self assert: walrusCond ssaVersion version equals: 2.
	self assert: walrusCond ssaName equals: 'x_2'.
	self assert: walrusCond ssaVersion localUses size equals: 3. "A while will re-execute the assignment if the loop is executed at least once."

	usedVar := model module statements third arguments first.
	self deny: usedVar ssaVersion isPhi.
	self assert: usedVar ssaVersion identicalTo: walrusCond ssaVersion
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusInsideFunction [

	| walrus usedVariable funcDef |
	self parseAndResolve: 'def f():
    x := 1
    print(x)'.

	funcDef := model module statements first.
	walrus := funcDef statements first.
	self assert: walrus ssaVersion version equals: 1.
	self assert: walrus ssaName equals: 'x_1'.
	self assert: walrus ssaVersion localUses size equals: 2.
	self assert: walrus ssaVersion localUses first equals: walrus.

	usedVariable := funcDef statements second arguments first.
	self assert: usedVariable ssaVersion identicalTo: walrus ssaVersion.
	self assert: usedVariable equals: walrus ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusMultipleInExpression [

	| walrusA walrusB usedA usedB |
	self parseAndResolve: 'a := 1
b := 2
print(a + b)'.

	walrusA := model module statements first.
	self assert: walrusA ssaVersion version equals: 1.
	self assert: walrusA ssaName equals: 'a_1'.
	self assert: walrusA ssaVersion localUses size equals: 2.
	self assert: walrusA ssaVersion localUses first equals: walrusA.

	walrusB := model module statements second.
	self assert: walrusB ssaVersion version equals: 1.
	self assert: walrusB ssaName equals: 'b_1'.
	self assert: walrusB ssaVersion localUses size equals: 2.
	self assert: walrusB ssaVersion localUses first equals: walrusB.

	usedA := model module statements third arguments first leftOperand.
	self assert: usedA ssaVersion identicalTo: walrusA ssaVersion.
	self assert: usedA equals: walrusA ssaVersion localUses second.

	usedB := model module statements third arguments first rightOperand.
	self assert: usedB ssaVersion identicalTo: walrusB ssaVersion.
	self assert: usedB equals: walrusB ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusNestedWalruses [

	| walrusA walrusB usedA usedB |
	self parseAndResolve: 'a := (b := 3)
print(a, b)'.

	walrusA := model module statements first.
	self assert: walrusA ssaVersion version equals: 1.
	self assert: walrusA ssaName equals: 'a_1'.
	self assert: walrusA ssaVersion localUses size equals: 2.
	self assert: walrusA ssaVersion localUses first equals: walrusA.

	walrusB := walrusA value.
	self assert: walrusB ssaVersion version equals: 1.
	self assert: walrusB ssaName equals: 'b_1'.
	self assert: walrusB ssaVersion localUses size equals: 2.
	self assert: walrusB ssaVersion localUses first equals: walrusB.

	usedA := model module statements second arguments first.
	self assert: usedA ssaVersion identicalTo: walrusA ssaVersion.
	self assert: usedA equals: walrusA ssaVersion localUses second.

	usedB := model module statements second arguments second.
	self assert: usedB ssaVersion identicalTo: walrusB ssaVersion.
	self assert: usedB equals: walrusB ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusRebindingSameVariable [

	| walrus1 walrus2 usedVar |
	self parseAndResolve: 'x := 1
x := 2
print(x)'.

	walrus1 := model module statements first.
	self assert: walrus1 ssaVersion version equals: 1.
	self assert: walrus1 ssaName equals: 'x_1'.
	self assert: walrus1 ssaVersion localUses size equals: 1.

	walrus2 := model module statements second.
	self assert: walrus2 ssaVersion version equals: 2.
	self assert: walrus2 ssaName equals: 'x_2'.
	self assert: walrus2 ssaVersion localUses size equals: 2.
	self assert: walrus2 ssaVersion localDeclaration equals: walrus1 ssaVersion localDeclaration.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion identicalTo: walrus2 ssaVersion.
	self assert: usedVar equals: walrus2 ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusWithGlobalStatement [

	| assignedVar walrus usedVar funcDef |
	self parseAndResolve: 'x = 0
def f():
    global x
    x := 1
    print(x)'.

	assignedVar := model module statements first left.
	self assert: assignedVar ssaVersion version equals: 1.
	self assert: assignedVar ssaName equals: 'x_1'.
	self assert: assignedVar ssaVersion localUses size equals: 2.

	funcDef := model module statements second.
	walrus := funcDef statements second.
	self assert: walrus ssaVersion version equals: 2.
	self assert: walrus ssaName equals: 'x_2'.
	self assert: walrus ssaVersion localDeclaration equals: assignedVar ssaVersion localDeclaration.
	self assert: walrus ssaVersion localUses size equals: 2.
	self assert: walrus ssaVersion localUses first equals: walrus.

	usedVar := funcDef statements third arguments first.
	self assert: usedVar ssaVersion identicalTo: walrus ssaVersion.
	self assert: usedVar equals: walrus ssaVersion localUses second
]

{ #category : 'tests - walrus' }
FASTPythonSSATest >> testWalrusWithNonlocalStatement [

	| outerAssign walrus usedVar outerDef innerDef |
	self parseAndResolve: 'def outer():
    x = 0
    def inner():
        nonlocal x
        x := 1
        print(x)
    inner()'.

	outerDef := model module statements first.
	outerAssign := outerDef statements first left.
	self assert: outerAssign ssaVersion version equals: 1.
	self assert: outerAssign ssaName equals: 'x_1'.
	self assert: outerAssign ssaVersion localUses size equals: 2.

	innerDef := outerDef statements second.
	walrus := innerDef statements second.
	self assert: walrus ssaVersion version equals: 2.
	self assert: walrus ssaName equals: 'x_2'.
	self assert: walrus ssaVersion localDeclaration equals: outerAssign ssaVersion localDeclaration.
	self assert: walrus ssaVersion localUses size equals: 2.
	self assert: walrus ssaVersion localUses first equals: walrus.

	usedVar := innerDef statements third arguments first.
	self assert: usedVar ssaVersion identicalTo: walrus ssaVersion.
	self assert: usedVar equals: walrus ssaVersion localUses second
]

{ #category : 'tests - while' }
FASTPythonSSATest >> testWhileElseAndUsage [

	| assignedVar1 usedVar assignedVar2 |
	self parseAndResolve: 'while a:
    x = 1
else:
    x = 2

print(x)'.

	assignedVar1 := model module statements first statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements first elseClause statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements second arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]

{ #category : 'tests - while' }
FASTPythonSSATest >> testWhileLoopReAssignAndUsage [

	| assignedVar1 assignedVar2 usedVar |
	self parseAndResolve: 'x = 3

while a:
    x = 4

print(x)'.

	assignedVar1 := model module statements first left.
	self assert: assignedVar1 ssaVersion version equals: 1.
	self assert: assignedVar1 ssaName equals: 'x_1'.
	self assert: assignedVar1 ssaVersion localUses size equals: 2.

	assignedVar2 := model module statements second statements first left.
	self assert: assignedVar2 ssaVersion version equals: 2.
	self assert: assignedVar2 ssaName equals: 'x_2'.
	self assert: assignedVar2 ssaVersion localDeclaration equals: assignedVar1 ssaVersion localDeclaration.
	self assert: assignedVar2 ssaVersion localUses size equals: 2.

	usedVar := model module statements third arguments first.
	self assert: usedVar ssaVersion isPhi.
	self assertCollection: usedVar ssaVersion ssaVariables hasSameElements: {
			assignedVar1 ssaVersion.
			assignedVar2 ssaVersion }
]
