"
Tests for the nodes using a variable. #allNodesUsingMe returns, for a node representing a variable, all the nodes having this variable inside of them: the ancestors of each access of the variable, stopping (exclusively) at the first FASTTStatementBlock (Module, function, method, clause, ...). It requires the local resolution. #allNodesUsingMyVersion does the same but only for the accesses reachable from the current SSA version of the receiver. It requires the SSA.
"
Class {
	#name : 'FASTPythonNodesUsingVariableTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeOnAttributeAccess [
	self parseAndResolve: 'x = []

x.append(1)'.

	self assert: (model module statements first left allNodesUsingMe) size equals: 3.
	self assertCollection: (model module statements first left allNodesUsingMe) hasSameElements: { model module statements first. model module statements second callee. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeOnConditionOfControlStatement [

	self parseAndResolve: 'x = 1

if x > 3:
	y = 2'.

	self assert: model module statements first left allNodesUsingMe size equals: 3.
	self assertCollection: model module statements first left allNodesUsingMe hasSameElements: {
			model module statements first.
			model module statements second condition.
			model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeOnMultipleUsages [

	self parseAndResolve: 'x = 1

print(x)

print(x + x)'.

	self assert: model module statements first left allNodesUsingMe size equals: 4.
	self assertCollection: model module statements first left allNodesUsingMe hasSameElements: {
			model module statements first.
			model module statements second.
			model module statements third arguments first.
			model module statements third }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeOnNestedExpression [
	self parseAndResolve: 'x = 1

y = x + 1'.

	self assert: (model module statements first left allNodesUsingMe) size equals: 3.
	self assertCollection: (model module statements first left allNodesUsingMe) hasSameElements: { model module statements first. model module statements second. model module statements second right }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeOnSimpleCase [
	| writeAccess readAccess |
	self parseAndResolve: 'x = 1

print(x)'.

	writeAccess := model module statements first left.
	readAccess := model module statements second arguments first.

	self assert: writeAccess allNodesUsingMe size equals: 2.
	self assert: readAccess allNodesUsingMe size equals: 2.
	self assertCollection: writeAccess allNodesUsingMe hasSameElements: { model module statements first. model module statements second }.
	self assertCollection: readAccess allNodesUsingMe hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeStopsAtFunction [
	| function |
	self parseAndResolve: 'x = 1

def f():
	print(x)'.

	function := model module statements second.

	self assert: (model module statements first left allNodesUsingMe) size equals: 2.
	self assertCollection: (model module statements first left allNodesUsingMe) hasSameElements: { model module statements first. function statements first }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMeStopsAtIfBody [
	| writeAccess |
	self parseAndResolve: 'if z:
	x = 2

print(x)'.

	writeAccess := model module statements first thenClause statements first left.

	self assert: writeAccess allNodesUsingMe size equals: 2.
	self assertCollection: writeAccess allNodesUsingMe hasSameElements: { model module statements first thenClause statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMyVersionOnPhi [
	| printRead ifStatement |
	self parseAndResolve: 'if z > 3:
	x = 2
else:
	x = 3

print(x)'.

	ifStatement := model module statements first.
	printRead := model module statements second arguments first.

	self assert: printRead allNodesUsingMyVersion size equals: 3.
	self assertCollection: printRead allNodesUsingMyVersion hasSameElements: { ifStatement thenClause statements first. ifStatement elseClause statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMyVersionOnSimpleCase [
	| readAccess writeAccess |
	self parseAndResolve: 'x = 1

print(x)'.

	readAccess := model module statements second arguments first.
	writeAccess := model module statements first left.

	self assert: readAccess allNodesUsingMyVersion size equals: 2.
	self assert: writeAccess allNodesUsingMyVersion size equals: 2.
	self assertCollection: readAccess allNodesUsingMyVersion hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testAllNodesUsingMyVersionOnlyReachableAccesses [
	| firstRead |
	self parseAndResolve: 'x = 1

print(x)

x = 2

print(x)'.

	firstRead := model module statements second arguments first.

	self assert: firstRead allNodesUsingMyVersion size equals: 2.
	self assertCollection: firstRead allNodesUsingMyVersion hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMeDeduplicatesStatementOfMultipleUsages [
	self parseAndResolve: 'x = 1

print(x + x)'.

	self assert: (model module statements first left statementsUsingMe) size equals: 2.
	self assertCollection: (model module statements first left statementsUsingMe) hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMeExcludesIntermediateNodes [
	| function |
	self parseAndResolve: 'x = 1

def f():
	return x + 3'.

	function := model module statements second.

	self assert: (model module statements first left statementsUsingMe) size equals: 2.
	self assertCollection: (model module statements first left statementsUsingMe) hasSameElements: { model module statements first. function statements first }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMeOnConditionOfControlStatement [
	| ifStatement |
	self parseAndResolve: 'x = 1

if x > 3:
	y = 2'.

	ifStatement := model module statements second.

	self assert: (model module statements first left statementsUsingMe) size equals: 2.
	self assertCollection: (model module statements first left statementsUsingMe) hasSameElements: { model module statements first. ifStatement }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMeOnSimpleCase [
	| writeAccess readAccess |
	self parseAndResolve: 'x = 1

print(x)'.

	writeAccess := model module statements first left.
	readAccess := model module statements second arguments first.

	self assert: writeAccess statementsUsingMe size equals: 2.
	self assert: readAccess statementsUsingMe size equals: 2.
	self assertCollection: writeAccess statementsUsingMe hasSameElements: { model module statements first. model module statements second }.
	self assertCollection: readAccess statementsUsingMe hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMyVersionDeduplicatesStatement [

	self parseAndResolve: 'x = 1

print(x + x)'.

	self assert: model module statements second arguments first leftOperand statementsUsingMyVersion size equals: 2.
	self assertCollection: model module statements second arguments first leftOperand statementsUsingMyVersion hasSameElements: {
			model module statements first.
			model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMyVersionOnPhi [
	| printRead ifStatement |
	self parseAndResolve: 'if z > 3:
	x = 2
else:
	x = 3

print(x)'.

	ifStatement := model module statements first.
	printRead := model module statements second arguments first.

	self assert: printRead statementsUsingMyVersion size equals: 3.
	self assertCollection: printRead statementsUsingMyVersion hasSameElements: { ifStatement thenClause statements first. ifStatement elseClause statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMyVersionOnSimpleCase [
	| readAccess |
	self parseAndResolve: 'x = 1

print(x)'.

	readAccess := model module statements second arguments first.

	self assert: readAccess statementsUsingMyVersion size equals: 2.
	self assertCollection: readAccess statementsUsingMyVersion hasSameElements: { model module statements first. model module statements second }
]

{ #category : 'tests' }
FASTPythonNodesUsingVariableTest >> testStatementsUsingMyVersionOnlyReachableAccesses [
	| firstRead |
	self parseAndResolve: 'x = 1

print(x)

x = 2

print(x)'.

	firstRead := model module statements second arguments first.

	self assert: firstRead statementsUsingMyVersion size equals: 2.
	self assertCollection: firstRead statementsUsingMyVersion hasSameElements: { model module statements first. model module statements second }
]
