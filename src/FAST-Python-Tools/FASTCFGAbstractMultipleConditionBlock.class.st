Class {
	#name : 'FASTCFGAbstractMultipleConditionBlock',
	#superclass : 'FASTCFGAbstractConditionalBlock',
	#instVars : [
		'blocksMap'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'testing' }
FASTCFGAbstractMultipleConditionBlock class >> isAbstract [

	^ self == FASTCFGAbstractMultipleConditionBlock
]

{ #category : 'adding' }
FASTCFGAbstractMultipleConditionBlock >> addNextBlock: aBlock [
	"The way I work, we should have created a new entry with the pattern of the switch in my dictionary earlier. 
	I'll add the node in this pattern that should be associated to nil."

	| lastAssociation |
	lastAssociation := blocksMap associations last.
	self assert: lastAssociation value isNil description: 'My last pattern should be associated to nil since it should not have a value yet.'.

	^ blocksMap at: lastAssociation key put: aBlock
]

{ #category : 'adding' }
FASTCFGAbstractMultipleConditionBlock >> addPattern: aFASTNode [
	"We add a pattern and then the value will be set in #addNextBlock."

	blocksMap at: aFASTNode put: nil
]

{ #category : 'initialization' }
FASTCFGAbstractMultipleConditionBlock >> initialize [

	super initialize.
	blocksMap := OrderedDictionary new
]

{ #category : 'accessing' }
FASTCFGAbstractMultipleConditionBlock >> nextBlockForValues [

	^ blocksMap associations
]

{ #category : 'accessing' }
FASTCFGAbstractMultipleConditionBlock >> nextBlocks [

	^ blocksMap values
]

{ #category : 'accessing' }
FASTCFGAbstractMultipleConditionBlock >> patterns [
	^ blocksMap keys
]

{ #category : 'accessing' }
FASTCFGAbstractMultipleConditionBlock >> patternsAndBlocks [

	^ self nextBlockForValues
]
