Class {
	#name : 'FASTCFGBlock',
	#superclass : 'FASTCFGAbstractBlock',
	#instVars : [
		'nextBlock'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGBlock >> addNextBlock: aBlock [

	self nextBlock ifNotNil: [ self error: 'This basic block already has a next block and cannot have multiple.' ].
	aBlock addPreviousBlock: self.
	^ self nextBlock: aBlock
]

{ #category : 'testing' }
FASTCFGBlock >> endsWithBreakStatement [

	^ self statements last isBreakStatement
]

{ #category : 'testing' }
FASTCFGBlock >> isFull [

	^ self nextBlock isNotNil
]

{ #category : 'accessing' }
FASTCFGBlock >> nextBlock [
	^ nextBlock
]

{ #category : 'accessing' }
FASTCFGBlock >> nextBlock: anObject [
	nextBlock := anObject
]

{ #category : 'accessing' }
FASTCFGBlock >> nextBlockForValues [

	^{ #next -> self nextBlock }
]

{ #category : 'accessing' }
FASTCFGBlock >> nextBlocks [

	^ self nextBlock
		  ifNil: [ Array empty ]
		  ifNotNil: [ { self nextBlock } ]
]

{ #category : 'printing' }
FASTCFGBlock >> printOn: aStream [

	super printOn: aStream.
	
	"Printing the condition since it is the most important part of the block"
	self statements ifNotEmpty: [
			aStream
				nextPutAll: ' [ ';
				nextPutAll: self statements first sourceCode.

			self statements size > 1 ifTrue: [ aStream nextPutAll: ' ... ' ].
			aStream nextPutAll: ' ]' ]
]
