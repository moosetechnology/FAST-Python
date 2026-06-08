Class {
	#name : 'FASTCFGSwitchBlock',
	#superclass : 'FASTCFGAbstractConditionalBlock',
	#instVars : [
		'blocksMap',
		'isFull'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGSwitchBlock >> addNextBlock: aBlock [
	"The way I work, we should have created a new entry with the pattern of the switch in my dictionary earlier. 
	I'll add the node in this pattern that should be associated to nil."

	| lastAssociation |
	lastAssociation := blocksMap associations last.
	self assert: lastAssociation value isNil description: 'My last pattern should be associated to nil since it should not have a value yet.'.

	^ blocksMap at: lastAssociation key put: aBlock
]

{ #category : 'adding' }
FASTCFGSwitchBlock >> addPattern: aFASTNode [
	"We add a pattern and then the value will be set in #addNextBlock."

	blocksMap at: aFASTNode put: nil
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> defaultCase [

	^ blocksMap at: nil
]

{ #category : 'testing' }
FASTCFGSwitchBlock >> includesPattern: aPattern [

	^ self patterns anySatisfy: [ :pattern | pattern isSameAsCFGCasePattern: aPattern ]
]

{ #category : 'initialization' }
FASTCFGSwitchBlock >> initialize [

	super initialize.
	blocksMap := OrderedDictionary new.
	isFull := false
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> isFull [
	"In the case of a switch, we cannot know with just the node so the algo will tell us when it is full at the closing of the switch.."

	^ isFull
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> isFull: anObject [
	isFull := anObject
]

{ #category : 'testing' }
FASTCFGSwitchBlock >> isSwitch [

	^ true
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> nextBlockForValues [

	^ self patternsAndBlocks
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> nextBlocks [

	^ blocksMap values
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> patterns [
	^ blocksMap keys
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> patternsAndBlocks [

	^ blocksMap associations
]
