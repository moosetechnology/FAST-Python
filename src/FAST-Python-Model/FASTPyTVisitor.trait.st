"
I am a visitor for FASTPyEntities. 
I am generated with the metamodel.


"
Trait {
	#name : 'FASTPyTVisitor',
	#category : 'FAST-Python-Model-Visitor',
	#package : 'FAST-Python-Model',
	#tag : 'Visitor'
}

{ #category : 'meta' }
FASTPyTVisitor classSide >> annotation [

	<FMClass: #TVisitor super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitCollection: aCollection [

	<generated>
	^ aCollection collect: [ :each | each accept: self ]
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitEntity: aFamixEntity [

	<generated>
	^ aFamixEntity ifNotNil: [ aFamixEntity accept: self ]
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAsPattern: anAsPattern [

	<generated>
	self visitFASTPyTWithStatementItem: anAsPattern.

	self visitEntity: anAsPattern target.
	self visitEntity: anAsPattern source
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAssertStatement: anAssertStatement [

	<generated>
	self visitFASTPyStatement: anAssertStatement.

	self visitCollection: anAssertStatement expressions
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAssignment: anAssignment [

	<generated>
	self visitFASTPyTAssignable: anAssignment.
	self visitFASTPyExpression: anAssignment.

	self visitEntity: anAssignment left.
	self visitEntity: anAssignment right.
	self visitEntity: anAssignment type
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAttributeAccess: anAttributeAccess [

	<generated>
	self visitFASTPyTAsPatternTarget: anAttributeAccess.
	self visitFASTPyTReturnReferenceable: anAttributeAccess.
	self visitFASTPyTSplatParameterTarget: anAttributeAccess.
	self visitFASTTNamedEntity: anAttributeAccess.
	self visitFASTPyExpression: anAttributeAccess.

	self visitEntity: anAttributeAccess value
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAugmentedAssignment: anAugmentedAssignment [

	<generated>
	self visitFASTPyAssignment: anAugmentedAssignment
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyAwait: anAwait [

	<generated>
	self visitFASTPyExpression: anAwait.

	self visitEntity: anAwait expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyBinaryOperator: aBinaryOperator [

	<generated>
	self visitFASTPyTPattern: aBinaryOperator.
	self visitFASTPyTSplatExpression: aBinaryOperator.
	self visitFASTTBinaryExpression: aBinaryOperator.
	self visitFASTPyOperator: aBinaryOperator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyBoolean: aBoolean [

	<generated>
	self visitFASTTBooleanLiteral: aBoolean.
	self visitFASTPyLiteral: aBoolean
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyBooleanOperator: aBooleanOperator [

	<generated>
	self visitFASTPyTRaised: aBooleanOperator.
	self visitFASTPyTSplatExpression: aBooleanOperator.
	self visitFASTTBinaryExpression: aBooleanOperator.
	self visitFASTPyOperator: aBooleanOperator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyBreakStatement: aBreakStatement [

	<generated>
	self visitFASTTBreakStatement: aBreakStatement.
	self visitFASTPyStatement: aBreakStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyCall: aCall [

	<generated>
	self visitFASTPyTReturnReferenceable: aCall.
	self visitFASTPyTWithStatementItem: aCall.
	self visitFASTTInvocation: aCall.
	self visitFASTPyExpression: aCall.

	self visitEntity: aCall callee
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyCaseClause: aCaseClause [

	<generated>
	self visitFASTTStatementBlock: aCaseClause.
	self visitFASTTWithCondition: aCaseClause.

	self visitEntity: aCaseClause pattern
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyChevron: aChevron [

	<generated>
	self visitEntity: aChevron expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyClassDefinition: aClassDefinition [

	<generated>
	self visitFASTPyTDefinition: aClassDefinition.
	self visitFASTPyTWithTypeParameters: aClassDefinition.
	self visitFASTPyStatement: aClassDefinition.

	self visitCollection: aClassDefinition superclasses.
	self visitCollection: aClassDefinition keywords
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyClassPattern: aClassPattern [

	<generated>
	self visitFASTPyTPattern: aClassPattern.

	self visitCollection: aClassPattern elements
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyCollectionInitializer: aCollectionInitializer [

	<generated>
	self visitFASTPyTPattern: aCollectionInitializer.
	self visitFASTPyTSplatExpression: aCollectionInitializer.
	self visitFASTPyExpression: aCollectionInitializer.

	self visitCollection: aCollectionInitializer initializers
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyComment: aComment [

	<generated>
	self visitFASTTComment: aComment
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyComparisonOperator: aComparisonOperator [

	<generated>
	self visitFASTPyOperator: aComparisonOperator.

	self visitCollection: aComparisonOperator operands
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyComplex: aComplex [

	<generated>
	self visitFASTTNumericalLiteral: aComplex.
	self visitFASTPyLiteral: aComplex
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyComprehension: aComprehension [

	<generated>
	self visitFASTPyTSplatExpression: aComprehension.
	self visitFASTPyExpression: aComprehension.

	self visitEntity: aComprehension body.
	self visitCollection: aComprehension forClauses.
	self visitCollection: aComprehension conditions
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyConcatenatedString: aConcatenatedString [

	<generated>
	self visitFASTPyExpression: aConcatenatedString.

	self visitCollection: aConcatenatedString strings
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyConditionalExpression: aConditionalExpression [

	<generated>
	self visitFASTPyTCallable: aConditionalExpression.
	self visitFASTPyTExecutable: aConditionalExpression.
	self visitFASTPyTSuperclass: aConditionalExpression.
	self visitFASTTWithCondition: aConditionalExpression.
	self visitFASTPyExpression: aConditionalExpression.

	self visitEntity: aConditionalExpression thenExpression.
	self visitEntity: aConditionalExpression elseExpression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyConstrainedType: aConstrainedType [

	<generated>
	self visitFASTPyTTypeContent: aConstrainedType.

	self visitEntity: aConstrainedType type.
	self visitEntity: aConstrainedType bound
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyContinueStatement: aContinueStatement [

	<generated>
	self visitFASTTContinueStatement: aContinueStatement.
	self visitFASTPyStatement: aContinueStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyDecorator: aDecorator [

	<generated>
	self visitEntity: aDecorator expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyDeleteStatement: aDeleteStatement [

	<generated>
	self visitFASTPyStatement: aDeleteStatement.

	self visitEntity: aDeleteStatement expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyDictionary: aDictionary [

	<generated>
	self visitFASTPyCollectionInitializer: aDictionary
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyDictionaryComprehension: aDictionaryComprehension [

	<generated>
	self visitFASTPyComprehension: aDictionaryComprehension
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyDottedName: aDottedName [

	<generated>
	self visitFASTPyTClassPatternElement: aDottedName.
	self visitFASTPyTPattern: aDottedName.
	self visitFASTPyExpression: aDottedName
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyERROR: anERROR [

	<generated>
	self visitFASTPyExpression: anERROR
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyElifClause: anElifClause [

	<generated>
	self visitFASTTConditionalStatement: anElifClause.
	self visitFASTTStatementBlock: anElifClause.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyEllipsis: anEllipsis [

	<generated>
	self visitFASTPyLiteral: anEllipsis
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyElseClause: anElseClause [

	<generated>
	self visitFASTTStatementBlock: anElseClause.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyEntity: anEntity [

	<generated>
	self visitFASTTEntity: anEntity.
	self visitFASTTWithComments: anEntity
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyEscapeInterpolation: anEscapeInterpolation [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyEscapeSequence: anEscapeSequence [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyExceptClause: anExceptClause [

	<generated>
	self visitFASTTStatementBlock: anExceptClause.

	self visitEntity: anExceptClause expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyExecStatement: anExecStatement [

	<generated>
	self visitFASTPyStatement: anExecStatement.

	self visitEntity: anExecStatement code.
	self visitCollection: anExecStatement scopes
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyExpression: anExpression [

	<generated>
	self visitFASTPyTSliceIndex: anExpression.
	self visitFASTPyTTypeContent: anExpression.
	self visitFASTTExpression: anExpression.
	self visitFASTPyStatement: anExpression.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyFinallyClause: aFinallyClause [

	<generated>
	self visitFASTTStatementBlock: aFinallyClause.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyFloat: aFloat [

	<generated>
	self visitFASTTNumericalLiteral: aFloat.
	self visitFASTPyLiteral: aFloat
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyForInClause: aForInClause [

	<generated>
	self visitFASTPyExpression: aForInClause.

	self visitEntity: aForInClause left.
	self visitEntity: aForInClause right
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyForStatement: aForStatement [

	<generated>
	self visitFASTPyTWithElseClause: aForStatement.
	self visitFASTTStatementBlock: aForStatement.
	self visitFASTPyStatement: aForStatement.

	self visitEntity: aForStatement right.
	self visitEntity: aForStatement left
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyFormatExpression: aFormatExpression [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyFromModule: aFromModule [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyFunctionDefinition: aFunctionDefinition [

	<generated>
	self visitFASTPyTDefinition: aFunctionDefinition.
	self visitFASTPyTWithTypeParameters: aFunctionDefinition.
	self visitFASTTWithParameters: aFunctionDefinition.
	self visitFASTPyStatement: aFunctionDefinition.

	self visitEntity: aFunctionDefinition returnType
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyGeneratorExpression: aGeneratorExpression [

	<generated>
	self visitFASTPyComprehension: aGeneratorExpression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyGenericType: aGenericType [

	<generated>
	self visitFASTPyTTypeContent: aGenericType.
	self visitFASTPyTWithTypeParameters: aGenericType.
	self visitFASTTNamedEntity: aGenericType.

	self visitCollection: aGenericType arguments
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyGlobalStatement: aGlobalStatement [

	<generated>
	self visitFASTPyStatement: aGlobalStatement.

	self visitCollection: aGlobalStatement variables
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyIdentifier: anIdentifier [

	<generated>
	self visitFASTPyTAsPatternTarget: anIdentifier.
	self visitFASTPyTReturnReferenceable: anIdentifier.
	self visitFASTPyTSplatParameterTarget: anIdentifier.
	self visitFASTTNamedEntity: anIdentifier.
	self visitFASTPyExpression: anIdentifier
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyIfClause: anIfClause [

	<generated>
	self visitFASTPyExpression: anIfClause.

	self visitEntity: anIfClause expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyIfStatement: anIfStatement [

	<generated>
	self visitFASTPyTWithElseClause: anIfStatement.
	self visitFASTTConditionalStatement: anIfStatement.
	self visitFASTPyStatement: anIfStatement.

	self visitEntity: anIfStatement thenClause.
	self visitCollection: anIfStatement elifClauses
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyImport: anImport [

	<generated>
	self visitFASTPyStatement: anImport.

	self visitCollection: anImport importedEntities
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyImportFromStatement: anImportFromStatement [

	<generated>
	self visitFASTPyImport: anImportFromStatement.

	self visitEntity: anImportFromStatement fromModule
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyImportStatement: anImportStatement [

	<generated>
	self visitFASTPyImport: anImportStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyImportedEntity: anImportedEntity [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyInteger: anInteger [

	<generated>
	self visitFASTTNumericalLiteral: anInteger.
	self visitFASTPyLiteral: anInteger
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyInterpolation: anInterpolation [

	<generated>
	self visitEntity: anInterpolation expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyKeywordArgument: aKeywordArgument [

	<generated>
	self visitFASTTNamedEntity: aKeywordArgument.
	self visitFASTPyExpression: aKeywordArgument.

	self visitEntity: aKeywordArgument value
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyKeywordPattern: aKeywordPattern [

	<generated>
	self visitFASTPyTClassPatternElement: aKeywordPattern.
	self visitFASTPyTPattern: aKeywordPattern.
	self visitFASTTNamedEntity: aKeywordPattern.

	self visitEntity: aKeywordPattern value
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyKeywordSeparator: aKeywordSeparator [

	<generated>
	self visitFASTTVariableEntity: aKeywordSeparator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyLambda: aLambda [

	<generated>
	self visitFASTPyTCallable: aLambda.
	self visitFASTPyTDecoratorExpression: aLambda.
	self visitFASTTWithParameters: aLambda.
	self visitFASTPyExpression: aLambda.

	self visitEntity: aLambda expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyLambdaParameters: aLambdaParameters [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyList: aList [

	<generated>
	self visitFASTPyTAsPatternTarget: aList.
	self visitFASTPyTAssignable: aList.
	self visitFASTPyCollectionInitializer: aList
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyListComprehension: aListComprehension [

	<generated>
	self visitFASTPyComprehension: aListComprehension
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyLiteral: aLiteral [

	<generated>
	self visitFASTPyTPattern: aLiteral.
	self visitFASTTLiteral: aLiteral.
	self visitFASTPyExpression: aLiteral
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyMatchStatement: aMatchStatement [

	<generated>
	self visitFASTPyStatement: aMatchStatement.

	self visitEntity: aMatchStatement subject.
	self visitCollection: aMatchStatement cases
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyMemberType: aMemberType [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyMethodDefinition: aMethodDefinition [

	<generated>
	self visitFASTPyTDefinition: aMethodDefinition.
	self visitFASTPyTWithTypeParameters: aMethodDefinition.
	self visitFASTTWithParameters: aMethodDefinition.
	self visitFASTPyStatement: aMethodDefinition.

	self visitEntity: aMethodDefinition returnType
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyModule: aModule [

	<generated>
	self visitFASTTStatementBlock: aModule.
	self visitFamixTHasImmediateSource: aModule
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyNone: aNone [

	<generated>
	self visitFASTPyLiteral: aNone
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyNonlocalStatement: aNonlocalStatement [

	<generated>
	self visitFASTPyStatement: aNonlocalStatement.

	self visitCollection: aNonlocalStatement variables
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyNotOperator: aNotOperator [

	<generated>
	self visitFASTPyTUnaryOperator: aNotOperator.
	self visitFASTPyOperator: aNotOperator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyOperator: anOperator [

	<generated>
	self visitFASTPyExpression: anOperator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyPair: aPair [

	<generated>
	self visitFASTPyExpression: aPair.

	self visitEntity: aPair key.
	self visitEntity: aPair value
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyParameter: aParameter [

	<generated>
	self visitFASTTVariableEntity: aParameter.

	self visitEntity: aParameter type.
	self visitEntity: aParameter defaultValue
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyParenthesizedListSplat: aParenthesizedListSplat [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyPassStatement: aPassStatement [

	<generated>
	self visitFASTPyStatement: aPassStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyPositionalSeparator: aPositionalSeparator [

	<generated>
	self visitFASTTVariableEntity: aPositionalSeparator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyPrintStatement: aPrintStatement [

	<generated>
	self visitFASTPyStatement: aPrintStatement.

	self visitCollection: aPrintStatement expressions.
	self visitEntity: aPrintStatement redirection
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyRaiseStatement: aRaiseStatement [

	<generated>
	self visitFASTPyStatement: aRaiseStatement.

	self visitEntity: aRaiseStatement exception
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyReturnStatement: aReturnStatement [

	<generated>
	self visitFASTTReturnStatement: aReturnStatement.
	self visitFASTPyStatement: aReturnStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySet: aSet [

	<generated>
	self visitFASTPyCollectionInitializer: aSet
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySetComprehension: aSetComprehension [

	<generated>
	self visitFASTPyComprehension: aSetComprehension
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySlice: aSlice [

	<generated>
	self visitFASTPyTSliceIndex: aSlice.

	self visitCollection: aSlice components
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySplat: aSplat [

	<generated>
	self visitFASTPyTPattern: aSplat.
	self visitFASTPyTSuperclass: aSplat.
	self visitFASTPyExpression: aSplat.

	self visitEntity: aSplat expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySplatParameter: aSplatParameter [

	<generated>
	self visitFASTPyParameter: aSplatParameter.

	self visitEntity: aSplatParameter target
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySplatType: aSplatType [

	<generated>
	self visitFASTPyTTypeContent: aSplatType.
	self visitFASTTNamedEntity: aSplatType
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyStatement: aStatement [

	<generated>
	self visitFASTTStatement: aStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyString: aString [

	<generated>
	self visitFASTPyTExecutable: aString.
	self visitFASTPyTSplatExpression: aString.
	self visitFASTTStringLiteral: aString.
	self visitFASTPyLiteral: aString.

	self visitCollection: aString interpolations
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPySubscript: aSubscript [

	<generated>
	self visitFASTPyTAsPatternTarget: aSubscript.
	self visitFASTPyTReturnReferenceable: aSubscript.
	self visitFASTPyExpression: aSubscript.

	self visitEntity: aSubscript value.
	self visitCollection: aSubscript indices
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTAsPatternSource: aTAsPatternSource [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTAsPatternTarget: aTAsPatternTarget [

	<generated>
	self visitFASTPyTAsPatternSource: aTAsPatternTarget.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTAssignable: aTAssignable [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTAwaitable: aTAwaitable [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTCallable: aTCallable [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTClassPatternElement: aTClassPatternElement [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTDecoratorExpression: aTDecoratorExpression [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTDefinition: aTDefinition [

	<generated>
	self visitFASTTNamedEntity: aTDefinition.
	self visitFASTTStatementBlock: aTDefinition.

	self visitCollection: aTDefinition decorators
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTDeletable: aTDeletable [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTExecutable: aTExecutable [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTPattern: aTPattern [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTRaised: aTRaised [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTReturnReferenceable: aTReturnReferenceable [

	<generated>
	self visitFASTPyTAsPatternSource: aTReturnReferenceable.
	self visitFASTPyTAssignable: aTReturnReferenceable.
	self visitFASTPyTAwaitable: aTReturnReferenceable.
	self visitFASTPyTCallable: aTReturnReferenceable.
	self visitFASTPyTDecoratorExpression: aTReturnReferenceable.
	self visitFASTPyTDeletable: aTReturnReferenceable.
	self visitFASTPyTExecutable: aTReturnReferenceable.
	self visitFASTPyTRaised: aTReturnReferenceable.
	self visitFASTPyTSplatExpression: aTReturnReferenceable.
	self visitFASTPyTSuperclass: aTReturnReferenceable
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTSliceIndex: aTSliceIndex [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTSplatExpression: aTSplatExpression [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTSplatParameterTarget: aTSplatParameterTarget [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTSuperclass: aTSuperclass [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTTypeContent: aTTypeContent [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTUnaryOperator: aTUnaryOperator [

	<generated>
	self visitEntity: aTUnaryOperator argument
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTWithElseClause: aTWithElseClause [

	<generated>
	self visitEntity: aTWithElseClause elseClause
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTWithStatementItem: aTWithStatementItem [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTWithTypeParameters: aTWithTypeParameters [

	<generated>
	self visitCollection: aTWithTypeParameters typeParameters
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyThenClause: aThenClause [

	<generated>
	self visitFASTTStatementBlock: aThenClause.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTryStatement: aTryStatement [

	<generated>
	self visitFASTPyTWithElseClause: aTryStatement.
	self visitFASTTStatementBlock: aTryStatement.
	self visitFASTPyStatement: aTryStatement.

	self visitCollection: aTryStatement excepts.
	self visitEntity: aTryStatement finally
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTuple: aTuple [

	<generated>
	self visitFASTPyTAsPatternTarget: aTuple.
	self visitFASTPyTAssignable: aTuple.
	self visitFASTPyTDeletable: aTuple.
	self visitFASTPyCollectionInitializer: aTuple
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyType: aType [

	<generated>
	self visitEntity: aType content
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTypeAliasStatement: aTypeAliasStatement [

	<generated>
	self visitFASTPyStatement: aTypeAliasStatement.

	self visitEntity: aTypeAliasStatement left.
	self visitEntity: aTypeAliasStatement right
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTypeConversion: aTypeConversion [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyTypeParameter: aTypeParameter [

	<generated>
	self visitFASTPyTTypeContent: aTypeParameter
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyUnaryOperator: anUnaryOperator [

	<generated>
	self visitFASTPyTUnaryOperator: anUnaryOperator.
	self visitFASTPyOperator: anUnaryOperator
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyUnionPattern: anUnionPattern [

	<generated>
	self visitFASTPyTPattern: anUnionPattern.

	self visitCollection: anUnionPattern members
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyUnionType: anUnionType [

	<generated>
	self visitFASTPyTTypeContent: anUnionType.

	self visitCollection: anUnionType types
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyVariable: aVariable [

	<generated>
	self visitFASTPyTAssignable: aVariable.
	self visitFASTTVariableEntity: aVariable.
	self visitFASTPyIdentifier: aVariable.


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyWalrus: aWalrus [

	<generated>
	self visitFASTTNamedEntity: aWalrus.
	self visitFASTPyExpression: aWalrus.

	self visitEntity: aWalrus value
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyWhileStatement: aWhileStatement [

	<generated>
	self visitFASTPyTWithElseClause: aWhileStatement.
	self visitFASTTConditionalStatement: aWhileStatement.
	self visitFASTTStatementBlock: aWhileStatement.
	self visitFASTPyStatement: aWhileStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyWithStatement: aWithStatement [

	<generated>
	self visitFASTTStatementBlock: aWithStatement.
	self visitFASTPyStatement: aWithStatement.

	self visitCollection: aWithStatement items
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTPyYield: aYield [

	<generated>
	self visitFASTPyExpression: aYield.

	self visitEntity: aYield expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTBinaryExpression: aTBinaryExpression [

	<generated>
	"We should visit FASTTExpression but all its users in this language already visit it in their superclasses so we skip the call here.".

	self visitEntity: aTBinaryExpression leftOperand.
	self visitEntity: aTBinaryExpression rightOperand
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTBooleanLiteral: aTBooleanLiteral [

	<generated>
	"We should visit FASTTLiteral but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTBreakStatement: aTBreakStatement [

	<generated>
	"We should visit FASTTStatement but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTComment: aTComment [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTConditionalStatement: aTConditionalStatement [

	<generated>
	"We do not visit all behaviorals because some classes already visit it in their superclasses in this language implementation. Visiting them here also would cause a double visit of this trait."
	({ FASTPyIfStatement . FASTPyWhileStatement } includes: aTConditionalStatement class)
		ifFalse: [ self visitFASTTStatement: aTConditionalStatement ].
	self visitFASTTWithCondition: aTConditionalStatement
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTContinueStatement: aTContinueStatement [

	<generated>

]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTEntity: aTEntity [

	<generated>
	"We should visit TEntityMetaLevelDependency but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTExpression: aTExpression [

	<generated>
	"We should visit FASTTEntity but all its users in this language already visit it in their superclasses so we skip the call here.".


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTInvocation: aTInvocation [

	<generated>
	"We should visit FASTTExpression but all its users in this language already visit it in their superclasses so we skip the call here.".
	self visitFASTTWithArguments: aTInvocation.

	self visitEntity: aTInvocation invoked
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTLiteral: aTLiteral [

	<generated>
	"We should visit FASTTExpression but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTNamedEntity: aTNamedEntity [

	<generated>
	"We should visit FASTTEntity but all its users in this language already visit it in their superclasses so we skip the call here.".


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTNumericalLiteral: aTNumericalLiteral [

	<generated>
	"We should visit FASTTLiteral but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTReturnStatement: aTReturnStatement [

	<generated>
	"We should visit FASTTStatement but all its users in this language already visit it in their superclasses so we skip the call here.".

	self visitEntity: aTReturnStatement expression
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTStatement: aTStatement [

	<generated>
	"We should visit FASTTEntity but all its users in this language already visit it in their superclasses so we skip the call here.".


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTStatementBlock: aTStatementBlock [

	<generated>
	"We do not visit all behaviorals because some classes already visit it in their superclasses in this language implementation. Visiting them here also would cause a double visit of this trait."
	({ FASTPyClassDefinition . FASTPyForStatement . FASTPyFunctionDefinition . FASTPyMethodDefinition . FASTPyTryStatement . FASTPyWhileStatement . FASTPyWithStatement } includes: aTStatementBlock class)
		ifFalse: [ self visitFASTTStatement: aTStatementBlock ].

	self visitCollection: aTStatementBlock statements
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTStringLiteral: aTStringLiteral [

	<generated>
	"We should visit FASTTLiteral but all its users in this language already visit it in their superclasses so we skip the call here."
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTVariableEntity: aTVariableEntity [

	<generated>
	"We do not visit all behaviorals because some classes already visit it in their superclasses in this language implementation. Visiting them here also would cause a double visit of this trait."
	({ FASTPyVariable } includes: aTVariableEntity class)
		ifFalse: [ self visitFASTTNamedEntity: aTVariableEntity ].


]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTWithArguments: aTWithArguments [

	<generated>
	self visitCollection: aTWithArguments arguments
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTWithComments: aTWithComments [

	<generated>
	self visitCollection: aTWithComments comments
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTWithCondition: aTWithCondition [

	<generated>
	self visitEntity: aTWithCondition condition
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFASTTWithParameters: aTWithParameters [

	<generated>
	self visitCollection: aTWithParameters parameters
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFamixTHasImmediateSource: aTHasImmediateSource [

	<generated>
	self visitFamixTSourceAnchor: aTHasImmediateSource
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitFamixTSourceAnchor: aTSourceAnchor [

	<generated>
	self visitEntity: aTSourceAnchor element
]

{ #category : 'visiting' }
FASTPyTVisitor >> visitTEntityMetaLevelDependency: aTEntityMetaLevelDependency [

	<generated>

]
