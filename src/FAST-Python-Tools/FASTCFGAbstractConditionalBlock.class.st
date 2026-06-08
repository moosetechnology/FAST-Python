Class {
	#name : 'FASTCFGAbstractConditionalBlock',
	#superclass : 'FASTCFGAbstractBlock',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'testing' }
FASTCFGAbstractConditionalBlock class >> isAbstract [

	^ self = FASTCFGAbstractConditionalBlock
]

{ #category : 'testing' }
FASTCFGAbstractConditionalBlock >> endsWithBreakStatement [
	"I return true if I have my two next blocks and they both end with a break statement."

	^ self isFull and: [ self nextBlocks allSatisfy: #endsWithBreakStatement ]
]

{ #category : 'testing' }
FASTCFGAbstractConditionalBlock >> endsWithContinueStatement [
	"I return true if I have my two next blocks and they both end with a break statement."

	^ self isFull and: [ self nextBlocks allSatisfy: #endsWithContinueStatement ]
]

{ #category : 'testing' }
FASTCFGAbstractConditionalBlock >> isConditional [

	^ true
]

{ #category : 'printing' }
FASTCFGAbstractConditionalBlock >> printOn: aStream [

	super printOn: aStream.
	
	"Printing the condition since it is the most important part of the block"
	self statements ifNotEmpty: [
			aStream nextPutAll: ' [ '.

			self statements size > 1 ifTrue: [ aStream nextPutAll: ' ... ' ].
			aStream
				nextPutAll: self statements last sourceCode;
				nextPutAll: ' ]' ]
]
