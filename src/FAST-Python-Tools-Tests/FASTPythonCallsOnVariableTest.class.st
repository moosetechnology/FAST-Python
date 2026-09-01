"
Tests for the calls made on a variable. #callsOnVariable returns, for a variable, all the FASTPyCall having the variable as receiver: the callee of the call is the read of the variable itself (`x()`, invocation or instantiation) or an internal access on the variable (`x.append(1)`, `x[3]()`). It requires the local resolution. #callsOnVariableVersion does the same but only for the reads reachable from the current SSA version of the receiver. It requires the SSA.
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
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnInstantiation [
	| call |
	self parseAndResolve: 'x = []

x()'.

	call := model module statements second.

	self assert: (model module statements first left callsOnVariable) size equals: 1.
	self assert: (model module statements first left callsOnVariable) first identicalTo: call
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

	self assert: (model module statements first left callsOnVariable) size equals: 1.
	self assert: (model module statements first left callsOnVariable) first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnInstantiation [
	| call |
	self parseAndResolve: 'x = []

x()'.

	call := model module statements second.

	self assert: (model module statements first left callsOnVariableVersion) size equals: 1.
	self assert: (model module statements first left callsOnVariableVersion) first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnPhi [
	| call receiverRead |
	self parseAndResolve: 'if z > 3:
	x = []

else:
	x = []

x.c()'.

	call := model module statements last.
	receiverRead := call callee value.

	self assert: receiverRead callsOnVariableVersion size equals: 1.
	self assert: receiverRead callsOnVariableVersion first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnSimpleCase [
	| readAccess |
	self parseAndResolve: 'x = []

x.append(1)'.

	readAccess := model module statements second callee value.

	self assert: readAccess callsOnVariableVersion size equals: 1.
	self assert: readAccess callsOnVariableVersion first identicalTo: model module statements second
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnlyReachableAccesses [
	| firstRead |
	self parseAndResolve: 'x = []

x.a(1)

x = []

x.b(2)'.

	firstRead := model module statements second callee value.

	self assert: firstRead callsOnVariableVersion size equals: 1.
	self assert: firstRead callsOnVariableVersion first identicalTo: model module statements second
]
