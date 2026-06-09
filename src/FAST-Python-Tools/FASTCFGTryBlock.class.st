Class {
	#name : 'FASTCFGTryBlock',
	#superclass : 'FASTCFGAbstractMultipleConditionBlock',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'testing' }
FASTCFGTryBlock >> isFull [
	"I am full when I have a branch pointing what happens if there is no exception caught and this branch has a nil pattern."

	^ blocksMap
		  at: nil
		  ifPresent: [ :value | value isNotNil ]
		  ifAbsent: [ false ]
]

{ #category : 'testing' }
FASTCFGTryBlock >> isTry [

	^ true
]
