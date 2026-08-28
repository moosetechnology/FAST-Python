Class {
	#name : 'FASTPythonUsedVariablesTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesAssignmentWithExpression [

	self parseAndResolve: 'y = 1
z = 2
x = y + z'.
	self assertCollection: model module statements third usedVariables hasSameElements: {
			model module statements third left.
			model module statements third right leftOperand.
			model module statements third right rightOperand }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesAttributeAccess [

	self parseAndResolve: 'class A:
    pass
obj = A()
obj.x = 1'.
	self assertCollection: model module statements third left usedVariables hasSameElements: {
			model module statements third left.
			model module statements third left value }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesBinaryOperator [

	self parseAndResolve: 'x = 1
y = 2
z = x + y'.
	self assertCollection: model module statements third right usedVariables hasSameElements: {
			model module statements third right leftOperand.
			model module statements third right rightOperand }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesBooleanOperator [

	self parseAndResolve: 'x = 1
y = 2
z = x and y'.
	self assertCollection: model module statements third right usedVariables hasSameElements: {
			model module statements third right leftOperand.
			model module statements third right rightOperand }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesComparison [

	self parseAndResolve: 'a = 1
b = 2
c = a < b'.
	self assertCollection: model module statements third right usedVariables hasSameElements: {
			model module statements third right operands first.
			model module statements third right operands second }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesComprehension [

	| comp |
	self parseAndResolve: 'items = [1, 2, 3]
result = [x for x in items]'.
	comp := model module statements second right.
	self assertCollection: comp usedVariables hasSameElements: {
			comp body.
			comp forClauses first left.
			comp forClauses first right }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesDeeplyNested [

	self parseAndResolve: 'y = 1
x = 1 + (2 + (3 + (4 + y)))'.
	self
		assertCollection: model module statements second right usedVariables
		hasSameElements: { model module statements second right rightOperand rightOperand rightOperand rightOperand }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesExcludesFunctionCall [

	self parseAndResolve: 'def f():
    pass
f()'.

	self assertCollection: model module usedVariables hasSameElements: #(  )
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesExcludesFunctionDefinition [

	self parseAndResolve: 'def f():
    pass'.

	self assertCollection: model module usedVariables hasSameElements: #(  )
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesForLoop [

	self parseAndResolve: 'items = [1]
for i in items:
    print(i)'.
	{
		model module statements second left.
		model module statements second right.
		model module statements second statements first arguments first } do: [ :each | self assert: (model module statements second usedVariables includes: each) ]
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesFunctionBody [

	| funcDef |
	self parseAndResolve: 'def f(x):
    y = x + 1
    return y'.
	funcDef := model module statements first.
	self assertCollection: funcDef usedVariables hasSameElements: {
			funcDef parameters first.
			funcDef statements first left.
			funcDef statements first right leftOperand.
			funcDef statements second expression }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesFunctionCallArgument [

	self parseAndResolve: 'def f(a, b):
    pass
x = 1
y = 2
f(x, y)'.
	self assertCollection: model module statements fourth usedVariables hasSameElements: {
			model module statements fourth arguments first.
			model module statements fourth arguments second }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesIfStatement [

	self parseAndResolve: 'x = 1
y = 2
if x:
    z = y'.
	{
		model module statements third condition.
		model module statements third thenClause statements first left.
		model module statements third thenClause statements first right } do: [ :each | self assert: (model module statements third usedVariables includes: each) ]
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesIncludesParameter [

	| funcDef |
	self parseAndResolve: 'def f(x):
    return x'.
	funcDef := model module statements first.
	self assertCollection: funcDef usedVariables hasSameElements: {
			funcDef parameters first.
			funcDef statements first expression }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesMultipleVariables [

	self parseAndResolve: 'x = 1
y = 2
print(x, y)'.
	self assertCollection: model module usedVariables hasSameElements: {
			model module statements first left.
			model module statements second left.
			model module statements third arguments first.
			model module statements third arguments second }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesNestedBinaryOperators [

	self parseAndResolve: 'a = 1
b = 2
c = 3
d = 4
z = a + (b * (c - d))'.
	self assertCollection: model module statements fifth right usedVariables hasSameElements: {
			model module statements fifth right leftOperand.
			model module statements fifth right rightOperand leftOperand.
			model module statements fifth right rightOperand rightOperand leftOperand.
			model module statements fifth right rightOperand rightOperand rightOperand }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesNestedCall [

	self parseAndResolve: 'def f(a):
    pass
def g(a):
    pass
x = 1
r(g(x))'.
	self assertCollection: model module statements fourth usedVariables hasSameElements: { model module statements fourth arguments first arguments first }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesNoVariables [

	self parseAndResolve: 'x = 1'.

	self assertCollection: model module statements first right usedVariables hasSameElements: #(  )
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesOnSubtree [

	self parseAndResolve: 'x = 1
y = 2
if y:
    z = x + y'.
	{
		model module statements third condition.
		model module statements third thenClause statements first left.
		model module statements third thenClause statements first right leftOperand.
		model module statements third thenClause statements first right rightOperand } do: [ :each |
		self assert: (model module statements third usedVariables includes: each) ]
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesReadAccess [

	self parseAndResolve: 'x = 1
print(x)'.
	self assertCollection: model module statements second usedVariables hasSameElements: { model module statements second arguments first }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesSimpleAssignment [

	self parseAndResolve: 'x = 1'.
	self assertCollection: model module statements first usedVariables hasSameElements: { model module statements first left }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesTernaryExpression [

	self parseAndResolve: 'x = 1
y = 2
z = 3
w = x if y else z'.
	self assertCollection: model module statements fourth right usedVariables hasSameElements: {
			model module statements fourth right condition.
			model module statements fourth right thenExpression.
			model module statements fourth right elseExpression }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesTupleAssignment [

	self parseAndResolve: 'x, y = 1, 2
print(x, y)'.
	self assertCollection: model module statements first usedVariables hasSameElements: {
			model module statements first left initializers first.
			model module statements first left initializers second }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesWalrus [

	self parseAndResolve: 'x = 1
if (y := x):
    pass'.
	self assertCollection: model module statements second condition usedVariables hasSameElements: {
			model module statements second condition.
			model module statements second condition value }
]

{ #category : 'tests' }
FASTPythonUsedVariablesTest >> testUsedVariablesWhileLoop [

	self parseAndResolve: 'x = 1
y = 2
while x:
    z = y'.
	{
		model module statements third condition.
		model module statements third statements first left.
		model module statements third statements first right } do: [ :each | self assert: (model module statements third usedVariables includes: each) ]
]
