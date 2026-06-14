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

	<FMClass: #TEntityCreator super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAsPattern [

	<generated>
	^ self add: FASTPyAsPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAssertStatement [

	<generated>
	^ self add: FASTPyAssertStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAssignment [

	<generated>
	^ self add: FASTPyAssignment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAttributeAccess [

	<generated>
	^ self add: FASTPyAttributeAccess new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAugmentedAssignment [

	<generated>
	^ self add: FASTPyAugmentedAssignment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newAwait [

	<generated>
	^ self add: FASTPyAwait new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBinaryOperator [

	<generated>
	^ self add: FASTPyBinaryOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBoolean [

	<generated>
	^ self add: FASTPyBoolean new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBooleanOperator [

	<generated>
	^ self add: FASTPyBooleanOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newBreakStatement [

	<generated>
	^ self add: FASTPyBreakStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCall [

	<generated>
	^ self add: FASTPyCall new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCaseClause [

	<generated>
	^ self add: FASTPyCaseClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newChevron [

	<generated>
	^ self add: FASTPyChevron new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newClassDefinition [

	<generated>
	^ self add: FASTPyClassDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newClassPattern [

	<generated>
	^ self add: FASTPyClassPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newCollectionInitializer [

	<generated>
	^ self add: FASTPyCollectionInitializer new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComment [

	<generated>
	^ self add: FASTPyComment new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComparisonOperator [

	<generated>
	^ self add: FASTPyComparisonOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newComplex [

	<generated>
	^ self add: FASTPyComplex new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConcatenatedString [

	<generated>
	^ self add: FASTPyConcatenatedString new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConditionalExpression [

	<generated>
	^ self add: FASTPyConditionalExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newConstrainedType [

	<generated>
	^ self add: FASTPyConstrainedType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newContinueStatement [

	<generated>
	^ self add: FASTPyContinueStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDecorator [

	<generated>
	^ self add: FASTPyDecorator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDeleteStatement [

	<generated>
	^ self add: FASTPyDeleteStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDictionary [

	<generated>
	^ self add: FASTPyDictionary new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDictionaryComprehension [

	<generated>
	^ self add: FASTPyDictionaryComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newDottedName [

	<generated>
	^ self add: FASTPyDottedName new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newERROR [

	<generated>
	^ self add: FASTPyERROR new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newElifClause [

	<generated>
	^ self add: FASTPyElifClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEllipsis [

	<generated>
	^ self add: FASTPyEllipsis new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newElseClause [

	<generated>
	^ self add: FASTPyElseClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEscapeInterpolation [

	<generated>
	^ self add: FASTPyEscapeInterpolation new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newEscapeSequence [

	<generated>
	^ self add: FASTPyEscapeSequence new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newExceptClause [

	<generated>
	^ self add: FASTPyExceptClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newExecStatement [

	<generated>
	^ self add: FASTPyExecStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFinallyClause [

	<generated>
	^ self add: FASTPyFinallyClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFloat [

	<generated>
	^ self add: FASTPyFloat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newForInClause [

	<generated>
	^ self add: FASTPyForInClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newForStatement [

	<generated>
	^ self add: FASTPyForStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFormatExpression [

	<generated>
	^ self add: FASTPyFormatExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFromModule [

	<generated>
	^ self add: FASTPyFromModule new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newFunctionDefinition [

	<generated>
	^ self add: FASTPyFunctionDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGeneratorExpression [

	<generated>
	^ self add: FASTPyGeneratorExpression new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGenericType [

	<generated>
	^ self add: FASTPyGenericType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newGlobalStatement [

	<generated>
	^ self add: FASTPyGlobalStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIdentifier [

	<generated>
	^ self add: FASTPyIdentifier new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIfClause [

	<generated>
	^ self add: FASTPyIfClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newIfStatement [

	<generated>
	^ self add: FASTPyIfStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImport [

	<generated>
	^ self add: FASTPyImport new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportFromStatement [

	<generated>
	^ self add: FASTPyImportFromStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportStatement [

	<generated>
	^ self add: FASTPyImportStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newImportedEntity [

	<generated>
	^ self add: FASTPyImportedEntity new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newInteger [

	<generated>
	^ self add: FASTPyInteger new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newInterpolation [

	<generated>
	^ self add: FASTPyInterpolation new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordArgument [

	<generated>
	^ self add: FASTPyKeywordArgument new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordPattern [

	<generated>
	^ self add: FASTPyKeywordPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newKeywordSeparator [

	<generated>
	^ self add: FASTPyKeywordSeparator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newLambda [

	<generated>
	^ self add: FASTPyLambda new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newLambdaParameters [

	<generated>
	^ self add: FASTPyLambdaParameters new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newList [

	<generated>
	^ self add: FASTPyList new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newListComprehension [

	<generated>
	^ self add: FASTPyListComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMatchStatement [

	<generated>
	^ self add: FASTPyMatchStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMemberType [

	<generated>
	^ self add: FASTPyMemberType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newMethodDefinition [

	<generated>
	^ self add: FASTPyMethodDefinition new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newModule [

	<generated>
	^ self add: FASTPyModule new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNone [

	<generated>
	^ self add: FASTPyNone new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNonlocalStatement [

	<generated>
	^ self add: FASTPyNonlocalStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newNotOperator [

	<generated>
	^ self add: FASTPyNotOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newOperator [

	<generated>
	^ self add: FASTPyOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPair [

	<generated>
	^ self add: FASTPyPair new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newParameter [

	<generated>
	^ self add: FASTPyParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newParenthesizedListSplat [

	<generated>
	^ self add: FASTPyParenthesizedListSplat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPassStatement [

	<generated>
	^ self add: FASTPyPassStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPositionalSeparator [

	<generated>
	^ self add: FASTPyPositionalSeparator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newPrintStatement [

	<generated>
	^ self add: FASTPyPrintStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newRaiseStatement [

	<generated>
	^ self add: FASTPyRaiseStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newReturnStatement [

	<generated>
	^ self add: FASTPyReturnStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSet [

	<generated>
	^ self add: FASTPySet new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSetComprehension [

	<generated>
	^ self add: FASTPySetComprehension new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSlice [

	<generated>
	^ self add: FASTPySlice new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplat [

	<generated>
	^ self add: FASTPySplat new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplatParameter [

	<generated>
	^ self add: FASTPySplatParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSplatType [

	<generated>
	^ self add: FASTPySplatType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newString [

	<generated>
	^ self add: FASTPyString new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newSubscript [

	<generated>
	^ self add: FASTPySubscript new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newThenClause [

	<generated>
	^ self add: FASTPyThenClause new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTryStatement [

	<generated>
	^ self add: FASTPyTryStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTuple [

	<generated>
	^ self add: FASTPyTuple new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newType [

	<generated>
	^ self add: FASTPyType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeAliasStatement [

	<generated>
	^ self add: FASTPyTypeAliasStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeConversion [

	<generated>
	^ self add: FASTPyTypeConversion new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newTypeParameter [

	<generated>
	^ self add: FASTPyTypeParameter new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnaryOperator [

	<generated>
	^ self add: FASTPyUnaryOperator new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnionPattern [

	<generated>
	^ self add: FASTPyUnionPattern new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newUnionType [

	<generated>
	^ self add: FASTPyUnionType new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newVariable [

	<generated>
	^ self add: FASTPyVariable new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWalrus [

	<generated>
	^ self add: FASTPyWalrus new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWhileStatement [

	<generated>
	^ self add: FASTPyWhileStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newWithStatement [

	<generated>
	^ self add: FASTPyWithStatement new
]

{ #category : 'entity creation' }
FASTPyTEntityCreator >> newYield [

	<generated>
	^ self add: FASTPyYield new
]
