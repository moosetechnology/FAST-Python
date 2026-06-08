Class {
	#name : 'FASTCFGNullBlock',
	#superclass : 'FASTCFGAbstractBlock',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGNullBlock >> addNextBlock: aBlock [

	self error: 'A null block cannot have a next block since it represent a virtual block merging all exit points if the exit point is not unique.'
]

{ #category : 'testing' }
FASTCFGNullBlock >> endsWithBreakStatement [
	"I cannot contain a breack"

	^ false
]

{ #category : 'testing' }
FASTCFGNullBlock >> endsWithContinueStatement [
	"I cannot contain a continue"

	^ false
]

{ #category : 'testing' }
FASTCFGNullBlock >> isFull [
	"I never have a next block"

	^ true
]

{ #category : 'testing' }
FASTCFGNullBlock >> isNullBlock [

	^ true
]

{ #category : 'accessing' }
FASTCFGNullBlock >> nextBlockForValues [

	^ {  }
]

{ #category : 'accessing' }
FASTCFGNullBlock >> nextBlocks [

	^ Array empty
]
