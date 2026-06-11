"
I am a visitor used to build a CFG for FASTPython.

I can be used like this:

```smalltalk
	FASTPythonCFGVisitor buildCFGOf: aModel allFunctionDefinitions first
```

I can take one of five different entities to build a CFG:
- a `FASTPyModule`
- a `FASTPyFunctionDefinition`
- a `FASTPyMethodDefinition`
- a `FASTPyLambda`
- a `FASTPyClassDefinition`


"
Class {
	#name : 'FASTPythonCFGVisitor',
	#superclass : 'FASTPythonVisitor',
	#traits : 'FASTTCFGUtility',
	#classTraits : 'FASTTCFGUtility classTrait',
	#instVars : [
		'started'
	],
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}

{ #category : 'initialization' }
FASTPythonCFGVisitor >> initialize [

	super initialize.
	self initializeCFG.
	started := false
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyBreakStatement: aBreakStatement [
	"We need to visit the statement before the TBreakStatement to add the break statement in the list of statements. Else the visit of #FASTPyStatement will be skipped by the exception raised FASTTBreakStatement"

	self visitFASTPyStatement: aBreakStatement.
	self visitFASTTBreakStatement: aBreakStatement
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyCaseClause: aCaseClause [

	| pattern |
	self assert: self currentConditional isSwitch.
	
	"In Python a pattern can come with a condition. If that is the case, I ship the pattern with this condition."
	pattern := aCaseClause pattern ifNotNil: [
			           aCaseClause condition
				           ifNil: [ aCaseClause pattern ]
				           ifNotNil: [ :condition | { aCaseClause pattern . condition } ] ].
					
	"If we have multiple times the same pattern in a match, we keep only the first one because the others will be ignored."
	(self currentConditional includesPattern: pattern) ifTrue: [ ^ self ].

	self currentConditional addPattern: pattern.

	self visitFASTTStatementBlock: aCaseClause
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitFASTPyClassDefinition: aClass [

	self visitPossibleEntryPoints: aClass
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
FASTPythonCFGVisitor >> visitFASTPyContinueStatement: aContinueStatement [
	"We need to visit the statement before the TContinueStatement to add the break statement in the list of statements. Else the visit of #FASTPyStatement will be skipped by the exception raised TContinueStatement"

	self visitFASTPyStatement: aContinueStatement.
	self visitFASTTContinueStatement: aContinueStatement
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyElifClause: anElifClause [

	self visitFASTTConditionalStatement: anElifClause.
	
	"In the case of the elif, the else clause is in the parent and not here. So we create a conditional that will be automatically popped when we will finalize the containing if."
	self buildAndPushBlockOfType: FASTCFGConditionalBlock.
	self visitFASTTStatementBlock: anElifClause
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyExceptClause: anExceptClause [

	| try |
	try := context top conditional.
	self assert: try isTry.

	try addPattern: anExceptClause expression.

	self visitFASTTStatementBlock: anExceptClause
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyExpression: aFASTPyExpression [
	"We ignore expressions that are not in a statement block"

	aFASTPyExpression isExpressionStatement ifTrue: [ ^ super visitFASTPyExpression: aFASTPyExpression ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyFinallyClause: aFinallyClause [
	"We do not want to create the block immediatly because this content will be added with the following instructions after the try since they should be executed together."

	aFinallyClause statements do: [ :statement | self addStatement: statement ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyForStatement: aForStatement [

	self buildBlockIfNeeded.

	self addStatement: aForStatement left.
	self addStatement: aForStatement right.

	self buildAndUseLoopDuring: [
			self visitFASTTStatementBlock: aForStatement.

			"We add the loops after finishing the first statement block, so the else can be managed in this block to be in the right context."
			self visitFASTPyTWithElseClause: aForStatement  ]
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitFASTPyFunctionDefinition: aFunction [

	self visitPossibleEntryPoints: aFunction
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyIfStatement: anIfStatement [

	self visitFASTTConditionalStatement: anIfStatement.

	self buildAndUseConditionalDuring: [
			self visitEntity: anIfStatement thenClause.
			self visitCollection: anIfStatement elifClauses.
			self visitFASTPyTWithElseClause: anIfStatement ]
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitFASTPyLambda: aLambda [

	self visitPossibleEntryPoints: aLambda
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyMatchStatement: aMatchStatement [
	"We skip the visit of the statement. We add the subject as last thing to execute of the previous block then we declare a switch."

	self addStatement: aMatchStatement subject.

	self buildAndUseSwitchDuring: [ self visitCollection: aMatchStatement cases ]
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitFASTPyMethodDefinition: aMethod [

	self visitPossibleEntryPoints: aMethod
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitFASTPyModule: aModule [

	self visitPossibleEntryPoints: aModule
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyTryStatement: aTryStatement [

	self buildBlockIfNeeded.
	self visitCollection: aTryStatement statements.

	self buildAndUseTryDuring: [
			self visitCollection: aTryStatement excepts.

			aTryStatement elseClause ifNotNil: [ :clause |
					context top conditional addPattern: nil.
					self visitEntity: clause ].

			self visitEntity: aTryStatement finally ]
]

{ #category : 'visiting' }
FASTPythonCFGVisitor >> visitFASTPyWhileStatement: aWhileStatement [

	self buildBlockIfNeeded.
	self visitFASTTConditionalStatement: aWhileStatement.

	self buildAndUseLoopDuring: [
			self visitFASTTStatementBlock: aWhileStatement.
			
			"We add the loops after finishing the first statement block, so the else can be managed in this block to be in the right context."
			self visitFASTPyTWithElseClause: aWhileStatement ]
]

{ #category : 'visiting - entry points' }
FASTPythonCFGVisitor >> visitPossibleEntryPoints: aFASTEntity [
	"I am the definition of a function, method, class, module or lambda. I can be the entry point of a CFG but I can also be a statement encountered in another definition. 
	
	In the first case I visit the definition's statement block. Else I consider the definition as a statement only."

	started
		ifTrue: [ self visitFASTTStatement: aFASTEntity ]
		ifFalse: [
				started := true.
				self visitFASTTStatementBlock: aFASTEntity ]
]
