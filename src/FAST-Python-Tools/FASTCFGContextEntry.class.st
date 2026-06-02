Class {
	#name : 'FASTCFGContextEntry',
	#superclass : 'Object',
	#instVars : [
		'conditional',
		'currentBlocks',
		'isLoop'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGContextEntry >> addBlock: aBlock [

	currentBlocks add: aBlock
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
FASTCFGContextEntry >> currentBlocks [
	"Reutrn the blocks that were already built in the current branch of the context entry I represent.
	
	At first it will be the blocks of the true branch. Once we close it once, it will be the blocks of the false branch.
	
	This is useful in order to know if a block we are creating is the first one of a branch or of it should follow already existing blocks.."

	^ currentBlocks
]

{ #category : 'accessing' }
FASTCFGContextEntry >> flushCurrentBlocks [

	currentBlocks := OrderedCollection new
]

{ #category : 'initialization' }
FASTCFGContextEntry >> initialize [

	super initialize.
	currentBlocks := OrderedCollection new.
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
