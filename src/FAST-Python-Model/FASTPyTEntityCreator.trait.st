"
This trait is used by Famix models.
It provides an API for creating entities and adding them to the model.


"
Trait {
	#name : 'FASTPyTEntityCreator',
	#category : 'FAST-Python-Model-Model',
	#package : 'FAST-Python-Model',
	#tag : 'Model'
}

{ #category : 'meta' }
FASTPyTEntityCreator classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #TEntityCreator super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAsPattern [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAsPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAssertStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAssertStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAssignment [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAssignment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAttributeAccess [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAttributeAccess new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAugmentedAssignment [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAugmentedAssignment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAwait [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyAwait new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBinaryOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyBinaryOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBoolean [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyBoolean new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBooleanOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyBooleanOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBreakStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyBreakStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCall [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyCall new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCaseClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyCaseClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newChevron [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyChevron new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newClassDefinition [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyClassDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newClassPattern [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyClassPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCollectionInitializer [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyCollectionInitializer new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComment [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyComment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComparisonOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyComparisonOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComplex [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyComplex new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConcatenatedString [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyConcatenatedString new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConditionalExpression [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyConditionalExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConstrainedType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyConstrainedType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newContinueStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyContinueStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDecorator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyDecorator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDeleteStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyDeleteStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDictionary [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyDictionary new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDictionaryComprehension [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyDictionaryComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDottedName [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyDottedName new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newERROR [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyERROR new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newElifClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyElifClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEllipsis [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyEllipsis new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newElseClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyElseClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEscapeInterpolation [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyEscapeInterpolation new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEscapeSequence [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyEscapeSequence new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newExceptClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyExceptClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newExecStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyExecStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFinallyClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyFinallyClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFloat [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyFloat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newForInClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyForInClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newForStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyForStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFormatExpression [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyFormatExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFromModule [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyFromModule new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFunctionDefinition [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyFunctionDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGeneratorExpression [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyGeneratorExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGenericType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyGenericType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGlobalStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyGlobalStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIdentifier [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyIdentifier new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIfClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyIfClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIfStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyIfStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImport [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyImport new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportFromStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyImportFromStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyImportStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportedEntity [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyImportedEntity new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newInteger [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyInteger new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newInterpolation [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyInterpolation new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordArgument [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyKeywordArgument new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordPattern [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyKeywordPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordSeparator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyKeywordSeparator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newLambda [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyLambda new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newLambdaParameters [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyLambdaParameters new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newList [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyList new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newListComprehension [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyListComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMatchStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyMatchStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMemberType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyMemberType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMethodDefinition [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyMethodDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newModule [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyModule new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNone [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyNone new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNonlocalStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyNonlocalStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNotOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyNotOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPair [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyPair new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newParameter [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newParenthesizedListSplat [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyParenthesizedListSplat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPassStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyPassStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPositionalSeparator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyPositionalSeparator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPrintStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyPrintStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newRaiseStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyRaiseStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newReturnStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyReturnStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSet [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySet new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSetComprehension [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySetComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSlice [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySlice new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplat [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySplat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplatParameter [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySplatParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplatType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySplatType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newString [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyString new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSubscript [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPySubscript new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newThenClause [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyThenClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTryStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyTryStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTuple [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyTuple new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeAliasStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyTypeAliasStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeConversion [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyTypeConversion new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeParameter [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyTypeParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnaryOperator [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyUnaryOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnionPattern [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyUnionPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnionType [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyUnionType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newVariable [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyVariable new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWalrus [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyWalrus new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWhileStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyWhileStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWithStatement [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyWithStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newYield [

	<ignoreForCoverage>
	<generated>
	^ self add: FASTPyYield new
]
