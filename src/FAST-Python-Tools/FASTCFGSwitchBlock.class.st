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

	self halt
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

{ #category : 'testing' }
FASTCFGSwitchBlock >> isSwitch [

	^ true
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> nextBlockForValues [

	^ blocksMap associations
]

{ #category : 'accessing' }
FASTCFGSwitchBlock >> nextBlocks [

	^ blocksMap values
]
