Trait {
	#name : 'FASTTCFGUtility',
	#instVars : [
		'startBlock',
		'currentStatements',
		'context'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'instance creation' }
FASTTCFGUtility classSide >> buildCFGOf: aFASTEntity [

	^ self new buildCFGForModel: aFASTEntity
]

{ #category : 'running' }
FASTTCFGUtility >> addStatement: aStatement [

	^ self currentStatements add: aStatement
]

{ #category : 'accessing' }
FASTTCFGUtility >> allBlocks [

	startBlock ifNil: [ ^ Array empty ].

	^ startBlock withAllFollowingBlocks
]

{ #category : 'running' }
FASTTCFGUtility >> buildAndPushBlockOfType: aClass [
	"I create a new block provided in parameter. It should be a conditional node.
	
	Ideally I should only be used by FASTTCFGUtility>>#buildAndUse:during: so that the context get poped when needed. But in some cases it get useful for me to be used alone. For example, when implementing the CFG of an elif since the false branch of the elif is the next elif or else of the parent if, and not a child of the elif."

	| block |
	block := self buildBlockOfType: aClass.
	context push: (FASTCFGContextEntry conditional: block).
	^ block
]

{ #category : 'running' }
FASTTCFGUtility >> buildAndUse: aClass during: aBlock [

	| conditional |
	conditional := self buildAndPushBlockOfType: aClass.

	aBlock cull: conditional.
	
	"Sometimes it is possible that we will need to pop multiple conditionals. 
	For example, in the case of elif. Usually the elif contains the `then` block but not the `else`. The else will be either the next elif, or next else or next block after the if.
	In that case, #buildNewConditional allows to push conditional blocks that I will clause with the containing conditional here. "
	[ conditional == context top conditional ] whileFalse: [ context pop ].

	context pop.
	^ conditional
]

{ #category : 'running' }
FASTTCFGUtility >> buildAndUseConditionalDuring: aBlock [

	^ self buildAndUse: FASTCFGConditionalBlock during: aBlock
]

{ #category : 'running' }
FASTTCFGUtility >> buildAndUseLoopDuring: aBlock [
	"For loops, we do an extra step compared to conditionals in order to build the loops if needed."

	self buildAndUseConditionalDuring: [ :loop |
			"In order to be able to manage the breaks correctly, we need to know if the conditional is a loop or not."
			loop isLoop: true.
			aBlock cull: loop.
			"We finilize in the loop so that the context entry related to the loop is not yet poped."
			self finializeLoop: loop ]
]

{ #category : 'running' }
FASTTCFGUtility >> buildAndUseSwitchDuring: aBlock [

	^ self buildAndUse: FASTCFGSwitchBlock during: [ :switch |
			  aBlock cull: switch.
			  switch isFull: true ]
]

{ #category : 'running' }
FASTTCFGUtility >> buildBlockIfNeeded [
	"If we have statements stocked, we create a new block with them. Else we do nothing.
	
	If I should be call at the closing of a statement block in the AST visit, then you should call #endBlock instead."

	self currentStatements ifEmpty: [ ^ self ].
	^ self buildBlockOfType: FASTCFGBlock
]

{ #category : 'running' }
FASTTCFGUtility >> buildBlockOfType: aBlockClass [

	| newBlock |
	newBlock := aBlockClass new.
	newBlock statements: self currentStatements.
	currentStatements := OrderedCollection new.

	self managePreviousBlocksOf: newBlock.

	context top addBlock: newBlock.

	^ newBlock
]

{ #category : 'running' }
FASTTCFGUtility >> buildCFGForModel: aFASTModel [

	aFASTModel accept: self.
	self shouldBuildNullBlock ifTrue: [ self buildBlockOfType: FASTCFGNullBlock ].

	^ startBlock
]

{ #category : 'accessing' }
FASTTCFGUtility >> currentStatements [
	^ currentStatements
]

{ #category : 'running' }
FASTTCFGUtility >> endBlock [
	"I declare that we are ending the visit of a statement block. I'll build a new block with the current statements and then I'll flush the current blocks of the top context entry. In case we where visiting the true side of a conditional, this will mark the shift to the false side of the conditional."

	self buildBlockIfNeeded.
	context top flushCurrentBlocks
]

{ #category : 'running' }
FASTTCFGUtility >> finializeLoop: loop [
	"When we close a loop, we check all blocks that are not full and that do not end with a break to create the loop."

	loop allFollowingBlocks
		reject: [ :block | block isFull or: [ block shouldBreakLoop: loop inContext: context ] ]
		thenDo: [ :block | block addNextBlock: loop ]
]

{ #category : 'initialization' }
FASTTCFGUtility >> initializeCFG [

	context := Stack new.
	context push: FASTCFGContextEntry new.
	currentStatements := OrderedCollection new
]

{ #category : 'running' }
FASTTCFGUtility >> managePreviousBlocksOf: newBlock [
	"If we are in a conditional, we add ourself there. Else we add ourself in all non finished conditionals and to their ."

	startBlock ifNil: [
			startBlock := newBlock.
			newBlock isStart: true.
			^ self ].

	context top currentBlocks ifEmpty: [ context top conditional addNextBlock: newBlock ] ifNotEmpty: [ :blocksAtScope |
			(blocksAtScope flatCollectAsSet: #withAllFollowingBlocks)
				reject: [ :block | block isFull or: [ block shouldBreakInContext: context ] ]
				thenDo: [ :block | block addNextBlock: newBlock ] ]
]

{ #category : 'asserting' }
FASTTCFGUtility >> shouldBuildNullBlock [
	"We build a null block if we have an unfinished conditional or more than one final block."

	(self allBlocks select: [ :block | block isConditional and: [ block isFull not ] ]) ifNotEmpty: [ ^ true ].

	^ (self allBlocks select: #isFinal) size > 1
]
