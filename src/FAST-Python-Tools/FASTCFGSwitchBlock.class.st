Class {
	#name : 'FASTCFGSwitchBlock',
	#superclass : 'FASTCFGAbstractMultipleConditionBlock',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'accessing' }
FASTCFGSwitchBlock >> defaultCase [

	^ blocksMap at: nil
]

{ #category : 'testing' }
FASTCFGSwitchBlock >> includesPattern: aPattern [

	^ self patterns anySatisfy: [ :pattern | pattern isSameAsCFGCasePattern: aPattern ]
]

{ #category : 'testing' }
FASTCFGSwitchBlock >> isSwitch [

	^ true
]
