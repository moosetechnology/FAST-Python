Class {
	#name : 'FASTPythonCFGVisitor',
	#superclass : 'FASTPythonVisitor',
	#traits : 'FASTTCFGUtility',
	#classTraits : 'FASTTCFGUtility classTrait',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'initialization' }
FASTPythonCFGVisitor >> initialize [

	super initialize.
	self initializeCFG
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyBreakStatement: aBreakStatement [
	"We need to visit the statement before the TBreakStatement to add the break statement in the list of statements. Else the visit of #FASTPyStatement will be skipped by the exception raised FASTTBreakStatement"

	self visitFASTPyStatement: aBreakStatement.
	self visitFASTTBreakStatement: aBreakStatement
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyCaseClause: aCaseClause [

	| switch |
	switch := context top conditional.
	self assert: switch isSwitch.

	self flag: #todo. "Add tests on a match with multiple times the same pattern" "If we have multiple times the same pattern in a match, we keep only the first one because the others will be ignored."
	(switch patterns includes: aCaseClause pattern) ifTrue: [ ^ self ].

	switch addPattern: aCaseClause pattern.

	self visitFASTTStatementBlock: aCaseClause.
	self flag: #todo. "Add the condition"
	self visitFASTTWithCondition: aCaseClause
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyConditionalExpression: aConditionalExpression [

	self visitFASTTConditionalStatement: aConditionalExpression.

	self buildAndUseConditionalDuring: [
			self addStatement: aConditionalExpression thenExpression.
			self endBlock.
			self addStatement: aConditionalExpression elseExpression.
			self buildBlockIfNeeded ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyElifClause: anElifClause [

	self visitFASTTConditionalStatement: anElifClause.
	
	"In the case of the elif, the else clause is in the parent and not here. So we create a conditional that will be automatically popped when we will finalize the containing if."
	self buildAndPushBlockOfType: FASTCFGConditionalBlock.
	self visitFASTTStatementBlock: anElifClause
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyExpression: aFASTPyExpression [
	"We ignore expressions that are not in a statement block"

	aFASTPyExpression isExpressionStatement ifTrue: [ ^ super visitFASTPyExpression: aFASTPyExpression ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyForStatement: aForStatement [

	self buildBlockIfNeeded.

	self flag: #todo. "The condition could be a conditional expression. Add a test on this case"
	self addStatement: aForStatement left.
	self addStatement: aForStatement right.

	self buildAndUseLoopDuring: [
			self visitFASTTStatementBlock: aForStatement.

			self flag: #todo. "Manage and test else clause"
			self visitFASTPyTWithElseClause: aForStatement ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyFunctionDefinition: aFunction [
	"We do not manage the function in itself only its content"

	(aFunction containedEntities sorted: #endPos ascending) do: [ :child | child accept: self ].

	self buildBlockIfNeeded
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyIfStatement: anIfStatement [

	self visitFASTTConditionalStatement: anIfStatement.

	self buildAndUseConditionalDuring: [
			self visitEntity: anIfStatement thenClause.
			self visitCollection: anIfStatement elifClauses.
			self visitFASTPyTWithElseClause: anIfStatement ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyMatchStatement: aMatchStatement [
	"We skip the visit of the statement. We add the subject as last thing to execute of the previous block then we declare a switch."

	self addStatement: aMatchStatement subject.

	self buildAndUseSwitchDuring: [ self visitCollection: aMatchStatement cases ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyWhileStatement: aWhileStatement [

	self buildBlockIfNeeded.
	self visitFASTTConditionalStatement: aWhileStatement.

	self buildAndUseLoopDuring: [
			self visitFASTTStatementBlock: aWhileStatement.

			self flag: #todo. "Manage and test else clause"
			self visitFASTPyTWithElseClause: aWhileStatement ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTTBreakStatement: aBreakStatement [

	super visitFASTTBreakStatement: aBreakStatement.
	FASTCFGBreakEncountered signal
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTTConditionalStatement: aStatement [

	self addStatement: aStatement condition
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTTStatement: aStatement [
	"Register the statement in the list of statements to create the current block once we find a conditional or the end of a block"

	self addStatement: aStatement
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTTStatementBlock: aFASTTStatementBlock [
	"We do not consider the block as a statemert.
	Also, once we are done with a block, if we encountered statements we produce a new normal block with them."

	[ self visitCollection: aFASTTStatementBlock statements ]
		on: FASTCFGBreakEncountered
		do: [ "End visit of the block and resume the rest of the visit." ].
	self endBlock
]
