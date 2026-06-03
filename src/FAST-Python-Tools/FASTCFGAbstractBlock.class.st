Class {
	#name : 'FASTCFGAbstractBlock',
	#superclass : 'Object',
	#instVars : [
		'isStart',
		'statements',
		'previousBlocks'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'adding' }
FASTCFGAbstractBlock >> addNextBlock: aBlock [

	^ self subclassResponsibility
]

{ #category : 'adding' }
FASTCFGAbstractBlock >> addPreviousBlock: aBlock [

	(self previousBlocks includes: aBlock) ifFalse: [ self previousBlocks add: aBlock ]
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> allFollowingBlocks [

	^ self deep: #nextBlocks collect: #yourself
]

{ #category : 'testing' }
FASTCFGAbstractBlock >> endsWithBreakStatement [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> firstParentLoop [
	"I return the first loop containing myself.
	This is useful to know which loop a node ending with a break statement will break."

	self deep: #previousBlocks do: [ :parent | parent isLoop ifTrue: [ ^ parent ] ].

	^ nil
]

{ #category : 'initialization' }
FASTCFGAbstractBlock >> initialize [

	super initialize.
	previousBlocks := OrderedCollection new.
	isStart := false
]

{ #category : 'inspector' }
FASTCFGAbstractBlock >> inspectionVisualization: aBuilder [

	<inspectorPresentationOrder: 3 title: 'Visu'>
	^ (aBuilder instantiate: SpRoassalInspectorPresenter)
		  canvas: (FASTCFGVisualizationBuilder on: self);
		  yourself
]

{ #category : 'inspector' }
FASTCFGAbstractBlock >> inspectionVisualizationContext: aContext [

	aContext active: self isStart
]

{ #category : 'testing' }
FASTCFGAbstractBlock >> isConditional [

	^ false
]

{ #category : 'testing' }
FASTCFGAbstractBlock >> isFinal [

	^ self nextBlocks isEmpty
]

{ #category : 'testing' }
FASTCFGAbstractBlock >> isLoop [

	^ false
]

{ #category : 'testing' }
FASTCFGAbstractBlock >> isNullBlock [

	^ false
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> isStart [
	^ isStart
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> isStart: anObject [
	isStart := anObject
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> nextBlocks [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> previousBlocks [
	^ previousBlocks
]

{ #category : 'asserting' }
FASTCFGAbstractBlock >> shouldBreakInContext: context [
	"I should break this node if it's a break and that we are currently visiting the first loop containing the break."

	^ self firstParentLoop
		  ifNil: [ false ]
		  ifNotNil: [ :loop | self shouldBreakLoop: loop inContext: context ]
]

{ #category : 'asserting' }
FASTCFGAbstractBlock >> shouldBreakLoop: aLoop inContext: context [
	"I should break this node if it's a break and that we are currently visiting the loop as parameter."

	self endsWithBreakStatement ifFalse: [ ^ false ].

	^ context
		  detect: #isLoop
		  ifFound: [ :loop | loop conditional = aLoop ]
		  ifNone: [ false ]
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> sourceCode [

	self statements isEmptyOrNil ifTrue: [ ^ '' ].

	^ self statements first sourceText copyFrom: self statements first startPos to: self statements last endPos
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> statements [
	^ statements
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> statements: anObject [
	statements := anObject
]

{ #category : 'accessing' }
FASTCFGAbstractBlock >> withAllFollowingBlocks [

	^ self withDeep: #nextBlocks collect: #yourself
]
