"
Tests for #internalAccesses: for a given variable, returns the accesses done directly on it, i.e. the attribute accesses and subscripts whose accessed object is the variable (x.y, x[3]), but not accesses chained on top of them (x.y.z).
"
Class {
	#name : 'FASTPythonInternalAccessesTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesExcludesCalls [
	| accesses |
	self parseAndResolve: 'x = 1

x()

x.y()'.

	accesses := model module statements last callee value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last callee
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesFromWriteAndReadReceivers [
	| writeAccess readAccess |
	self parseAndResolve: 'x = 1

print(x.y)'.

	writeAccess := model module statements first left.
	readAccess := model module statements last arguments first value.

	self assert: writeAccess internalAccesses size equals: 1.
	self assert: readAccess internalAccesses size equals: 1.
	self assert: writeAccess internalAccesses first identicalTo: readAccess internalAccesses first
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnAttributeRead [
	| accesses |
	self parseAndResolve: 'x = 1

print(x.y)'.

	accesses := model module statements last arguments first value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last arguments first
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnAttributeWrite [
	| accesses |
	self parseAndResolve: 'x = 1

x.y = 2'.

	accesses := model module statements second left value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements second left
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnAugmentedAssignment [
	| accesses |
	self parseAndResolve: 'x = 1

x.y += 1'.

	accesses := model module statements second left value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements second left
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnChainedAttributes [
	| accesses |
	self parseAndResolve: 'x = 1

print(x.y.z)'.

	accesses := model module statements last arguments first value value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last arguments first value
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnMixedChain [
	| accesses |
	self parseAndResolve: 'x = 1

print(x[3].y)'.

	accesses := model module statements last arguments first value value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last arguments first value
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnMultipleUsages [
	| accesses |
	self parseAndResolve: 'x = 1

print(x.y)

print(x.z)'.

	accesses := model module statements second arguments first value internalAccesses.

	self assert: accesses size equals: 2.
	self assertCollection: accesses hasSameElements: { model module statements second arguments first. model module statements last arguments first }
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnSliceSubscript [
	| accesses |
	self parseAndResolve: 'x = 1

print(x[1:4])'.

	accesses := model module statements last arguments first value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last arguments first
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnSubscriptRead [
	| accesses |
	self parseAndResolve: 'x = 1

print(x[3])'.

	accesses := model module statements last arguments first value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements last arguments first
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesOnSubscriptWrite [
	| accesses |
	self parseAndResolve: 'x = 1

x[0] = 2'.

	accesses := model module statements second left value internalAccesses.

	self assert: accesses size equals: 1.
	self assert: accesses first identicalTo: model module statements second left
]

{ #category : 'tests' }
FASTPythonInternalAccessesTest >> testInternalAccessesWithoutInternalAccess [

	self parseAndResolve: 'x = 1

print(x)'.

	self assertEmpty: model module statements last arguments first internalAccesses
]
