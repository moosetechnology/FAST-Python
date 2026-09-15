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
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableExcludesArgumentsAndPlainReads [

	self parseAndResolve: 'x = 1

print(x)

y = x'.

	self assertEmpty: model module statements first left allCallsOnVariable
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableOnInstantiation [

	| call |
	self parseAndResolve: 'x = []

x()'.

	call := model module statements second.

	self assert: model module statements first left allCallsOnVariable size equals: 1.
	self assert: model module statements first left allCallsOnVariable first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableOnMethodCall [

	| writeAccess readAccess |
	self parseAndResolve: 'x = []

x.append(1)'.

	writeAccess := model module statements first left.
	readAccess := model module statements second callee value.

	self assert: writeAccess allCallsOnVariable size equals: 1.
	self assert: readAccess allCallsOnVariable size equals: 1.
	self assert: writeAccess allCallsOnVariable first identicalTo: model module statements second.
	self assert: readAccess allCallsOnVariable first identicalTo: model module statements second
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableOnMultipleCalls [

	self parseAndResolve: 'x = []

x.a(1)

x.b(2)'.

	self assert: model module statements first left allCallsOnVariable size equals: 2.
	self assertCollection: model module statements first left allCallsOnVariable hasSameElements: {
			model module statements second.
			model module statements third }
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableOnSubscriptReceiver [

	| call |
	self parseAndResolve: 'x = []

x[3]()'.

	call := model module statements second.

	self assert: model module statements first left allCallsOnVariable size equals: 1.
	self assert: model module statements first left allCallsOnVariable first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableVersionOnInstantiation [

	| call |
	self parseAndResolve: 'x = []

x()'.

	call := model module statements second.

	self assert: model module statements first left allCallsOnVariableVersion size equals: 1.
	self assert: model module statements first left allCallsOnVariableVersion first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableVersionOnPhi [

	| call receiverRead |
	self parseAndResolve: 'if z > 3:
	x = []

else:
	x = []

x.c()'.

	call := model module statements last.
	receiverRead := call callee value.

	self assert: receiverRead allCallsOnVariableVersion size equals: 1.
	self assert: receiverRead allCallsOnVariableVersion first identicalTo: call
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableVersionOnSimpleCase [

	| readAccess |
	self parseAndResolve: 'x = []

x.append(1)'.

	readAccess := model module statements second callee value.

	self assert: readAccess allCallsOnVariableVersion size equals: 1.
	self assert: readAccess allCallsOnVariableVersion first identicalTo: model module statements second
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testAllCallsOnVariableVersionOnlyReachableAccesses [

	| firstRead |
	self parseAndResolve: 'x = []

x.a(1)

x = []

x.b(2)'.

	firstRead := model module statements second callee value.

	self assert: firstRead allCallsOnVariableVersion size equals: 1.
	self assert: firstRead allCallsOnVariableVersion first identicalTo: model module statements second
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnInstantiationIsExcluded [

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
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnSubscriptReceiverIsExcluded [

	self parseAndResolve: 'x = []

x[3]()'.
	self assertEmpty: model module statements first left callsOnVariable
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableOnlyReceiverCalls [

	self parseAndResolve: 'x = []

x()

x[3]()

x.y()'.
	self assert: model module statements first left callsOnVariable size equals: 1.
	self assert: model module statements first left callsOnVariable first identicalTo: model module statements fourth
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnInstantiationIsExcluded [

	self parseAndResolve: 'x = []

x()'.
	self assertEmpty: model module statements first left callsOnVariableVersion
]

{ #category : 'tests' }
FASTPythonCallsOnVariableTest >> testCallsOnVariableVersionOnPhi [

	| call receiverRead |
	self parseAndResolve:
		'if z > 3:
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
