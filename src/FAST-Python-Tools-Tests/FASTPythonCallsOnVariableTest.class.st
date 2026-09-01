"
Tests for the calls made on a variable. #callsOnVariable returns, for a variable, all the FASTPyCall whose receiver is the variable: the callee of the call is an internal access on the variable (`x.append(1)`, `x[3]()`). The calls of the variable itself, such as the instantiation `x()`, are not included since the variable is the callee and not the receiver. It requires the local resolution. #callsOnVariableVersion does the same but only for the reads reachable from the current SSA version of the receiver. It requires the SSA.
"
Class {
	#name : 'FASTPythonCallsOnVariableTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableExcludesArgumentsAndPlainReads [

	self parseAndResolve: 'x = 1

print(x)

y = x'.

	self assertEmpty: model module statements first left callsOnVariable
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableExcludesInstantiation [

	self parseAndResolve: 'x = []

x()'.

	self assertEmpty: model module statements first left callsOnVariable
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnMethodCall [
	| writeAccess readAccess |
	self parseAndResolve: 'x = []

x.append(1)'.

	writeAccess := model module statements first left.
	readAccess := model module statements second callee value.

	self assert: writeAccess callsOnVariable size equals: 1.
	self assert: readAccess callsOnVariable size equals: 1.
	self assert: writeAccess callsOnVariable first identicalTo: model module statements second.
	self assert: readAccess callsOnVariable first identicalTo: model module statements second
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnMultipleCalls [
	self parseAndResolve: 'x = []

x.a(1)

x.b(2)'.

	self assert: (model module statements first left callsOnVariable) size equals: 2.
	self assertCollection: (model module statements first left callsOnVariable) hasSameElements: { model module statements second. model module statements third }
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnSubscriptReceiver [

	| call |
	self parseAndResolve: 'x = []

x[3]()'.

	call := model module statements second.

	self assertEmpty: model module statements first left callsOnVariable
]
