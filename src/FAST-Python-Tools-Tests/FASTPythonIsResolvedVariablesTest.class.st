Class {
	#name : 'FASTPythonIsResolvedVariablesTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnAssignmentLHS [

	self parseAndResolve: 'x = 1'.
	self assert: model module statements first left isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnAttributeAccessRead [

	self parseAndResolve: 'obj = []
y = obj.x'.
	self deny: model module statements second right isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnAttributeAccessWrite [

	self parseAndResolve: 'obj = []
obj.x = 1'.
	self assert: model module statements second left isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnBinaryOperator [

	self parseAndResolve: 'x = 1
y = 2
z = x + y'.
	self assert: model module statements third right leftOperand isResolvedVariable.
	self assert: model module statements third right rightOperand isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnBooleanOperator [

	self parseAndResolve: 'x = 1
y = 2
z = x and y'.
	self assert: model module statements third right leftOperand isResolvedVariable.
	self assert: model module statements third right rightOperand isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnChainedAttributeRead [

	self parseAndResolve: 'obj = None
y = obj.x.y'.
	self deny: model module statements second right isResolvedVariable.
	self deny: model module statements second right value isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnChainedAttributeWrite [

	self parseAndResolve: 'obj = None
obj.x.y = 1'.
	self assert: model module statements second left isResolvedVariable.
	self deny: model module statements second left value isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnChainedSubscript [

	self parseAndResolve: 'x = [[1, 2], [3, 4]]
y = x[0][0]'.
	self deny: model module statements second right isResolvedVariable.
	self deny: model module statements second right value isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnClassName [

	self parseAndResolve: 'class A:
    pass
a = A()'.
	self deny: model module statements second right callee isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnComprehensionVariable [

	self parseAndResolve: 'items = [1, 2, 3]
result = [x for x in items]'.
	self assert: model module statements second right body isResolvedVariable.
	self assert: model module statements second right forClauses first left isResolvedVariable.
	self assert: model module statements second right forClauses first right isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnForLoopIterable [

	self parseAndResolve: 'items = [1]
for i in items:
    print(i)'.
	self assert: model module statements second right isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnForLoopVariable [

	self parseAndResolve: 'items = [1]
for i in items:
    print(i)'.
	self assert: model module statements second left isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnFunctionCallCallee [

	self parseAndResolve: 'def f():
    pass
f()'.
	self deny: model module statements second callee isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnFunctionDefinition [

	self parseAndResolve: 'def f():
    pass'.
	self deny: model module statements first isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnIfCondition [

	self parseAndResolve: 'x = 1
if x:
    pass'.
	self assert: model module statements second condition isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnLiteral [

	self parseAndResolve: 'x = 1'.
	self deny: model module statements first right isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnParameterDeclaration [

	self parseAndResolve: 'def f(x):
    pass'.
	self assert: model module statements first parameters first isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnParameterRead [

	self parseAndResolve: 'def f(x):
    return x'.
	self assert: model module statements first statements first expression isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnReadAccess [

	self parseAndResolve: 'x = 1
print(x)'.
	self assert: model module statements second arguments first isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnSubscriptIndexVariable [

	self parseAndResolve: 'x = [1, 2, 3]
i = 0
y = x[i]'.
	self assert: model module statements third right indices first isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnSubscriptRead [

	self parseAndResolve: 'x = [1, 2, 3]
y = x[0]'.
	self deny: model module statements second right isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnSubscriptWrite [

	self parseAndResolve: 'x = [1, 2, 3]
x[0] = 4'.
	self deny: model module statements second left isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnTernary [

	self parseAndResolve: 'x = 1
y = 2
z = 3
w = x if y else z'.
	self assert: model module statements fourth right condition isResolvedVariable.
	self assert: model module statements fourth right thenExpression isResolvedVariable.
	self assert: model module statements fourth right elseExpression isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnTupleVariable [

	self parseAndResolve: 'x, y = 1, 2
print(x, y)'.
	self assert: model module statements second arguments first isResolvedVariable.
	self assert: model module statements second arguments second isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnUnresolvedName [

	self parseAndResolve: 'print(x)'.
	self deny: model module statements first arguments first isResolvedVariable
]

{ #category : 'tests' }
FASTPythonIsResolvedVariablesTest >> testIsResolvedVariableOnWhileCondition [

	self parseAndResolve: 'x = 1
while x:
    pass'.
	self assert: model module statements second condition isResolvedVariable
]
