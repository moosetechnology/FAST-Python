Class {
	#name : 'FASTCFGContextEntry',
	#superclass : 'Object',
	#instVars : [
		'conditional',
		'trueBlocks',
		'falseBlocks',
		'isOpen',
		'isLoop'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGContextEntry >> addBlock: aBlock [

	isOpen
		ifTrue: [ trueBlocks add: aBlock ]
		ifFalse: [ falseBlocks add: aBlock ]
]

{ #category : 'accessing' }
FASTCFGContextEntry >> blocksInCurrentBranch [
	"If we are in a true branch, return the blocks of the true branch. Else, return the blocks of the false branch."

	^ self isOpen
		  ifTrue: [ self trueBlocks ]
		  ifFalse: [ self falseBlocks ]
]

{ #category : 'accessing' }
FASTCFGContextEntry >> close [

	isOpen := false
]

{ #category : 'accessing' }
FASTCFGContextEntry >> conditional [
	^ conditional
]

{ #category : 'accessing' }
FASTCFGContextEntry >> conditional: anObject [
	conditional := anObject
]

{ #category : 'accessing' }
FASTCFGContextEntry >> falseBlocks [
	^ falseBlocks
]

{ #category : 'initialization' }
FASTCFGContextEntry >> initialize [

	super initialize.
	trueBlocks := OrderedCollection new.
	falseBlocks := OrderedCollection new.
	isOpen := true.
	isLoop := false
]

{ #category : 'accessing' }
FASTCFGContextEntry >> isLoop [
	^ isLoop
]

{ #category : 'accessing' }
FASTCFGContextEntry >> isLoop: anObject [
	isLoop := anObject
]

{ #category : 'accessing' }
FASTCFGContextEntry >> isOpen [
	^ isOpen
]

{ #category : 'printing' }
FASTCFGContextEntry >> printOn: aStream [

	super printOn: aStream.

	aStream nextPutAll: ' [ '.
	self conditional
		ifNil: [ aStream nextPutAll: 'Root' ]
		ifNotNil: [ self conditional printOn: aStream ].
	aStream nextPutAll: ' ]'.

	self isLoop ifTrue: [ aStream nextPutAll: ' - Loop' ]
]

{ #category : 'accessing' }
FASTCFGContextEntry >> trueBlocks [
	^ trueBlocks
]
