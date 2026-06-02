Class {
	#name : 'FASTCFGConditionalBlock',
	#superclass : 'FASTCFGAbstractBlock',
	#instVars : [
		'nextBlocks'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGConditionalBlock >> addNextBlock: aBlock [

	self nextBlocks size > 1 ifTrue: [
		self error: 'A conditional block should have only 2 children. The first in case the condition is true. The second in case the condition is false.' ].
	aBlock addPreviousBlock: self.
	^ self nextBlocks add: aBlock
]

{ #category : 'testing' }
FASTCFGConditionalBlock >> endsWithBreakStatement [
	"I return true if I have my two next blocks and they both end with a break statement."

	^ self isFull and: [ self nextBlocks allSatisfy: #endsWithBreakStatement ]
]

{ #category : 'initialization' }
FASTCFGConditionalBlock >> initialize [

	super initialize.
	nextBlocks := OrderedCollection new: 2 "There will be only a true and false next blocks."
]

{ #category : 'testing' }
FASTCFGConditionalBlock >> isConditional [

	^ true
]

{ #category : 'testing' }
FASTCFGConditionalBlock >> isFull [
	"I return true if both my true and false next block are resolved."

	^ self nextBlocks size = 2
]

{ #category : 'accessing' }
FASTCFGConditionalBlock >> nextBlockForValues [

	^ {
		  (true -> self nextTrueBlock).
		  (false -> self nextFalseBlock) }
]

{ #category : 'accessing' }
FASTCFGConditionalBlock >> nextBlocks [

	^ nextBlocks
]

{ #category : 'accessing' }
FASTCFGConditionalBlock >> nextFalseBlock [

	^ [ self nextBlocks second ]
		  on: SubscriptOutOfBounds
		  do: [ nil ]
]

{ #category : 'accessing' }
FASTCFGConditionalBlock >> nextTrueBlock [

	^ self nextBlocks first
]

{ #category : 'printing' }
FASTCFGConditionalBlock >> printOn: aStream [

	super printOn: aStream.
	
	"Printing the condition since it is the most important part of the block"
	self statements ifNotEmpty: [
			aStream nextPutAll: ' [ '.

			self statements size > 1 ifTrue: [ aStream nextPutAll: ' ... ' ].
			aStream
				nextPutAll: self statements last sourceCode;
				nextPutAll: ' ]' ]
]
