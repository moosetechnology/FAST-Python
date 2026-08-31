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
