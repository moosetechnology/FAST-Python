"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `argumentOwner` | `FASTTExpression` | `arguments` | `FASTTWithArguments` | my owner|
| `assignedIn` | `FASTTExpression` | `expression` | `FASTTAssignment` | Optional assignment where this expression is used|
| `collectionInitializer` | `FASTPyExpression` | `initializers` | `FASTPyCollectionInitializer` | The owner of the expression|
| `expressionStatementOwner` | `FASTTExpression` | `expression` | `FASTTExpressionStatement` | The expression statement that own me (if it's the case|
| `parentAssertStatement` | `FASTPyExpression` | `expressions` | `FASTPyAssertStatement` | The assert statement that own the expression (if it's the case)|
| `parentAssignmentRight` | `FASTPyExpression` | `right` | `FASTPyAssignment` | |
| `parentAttributeObject` | `FASTPyExpression` | `value` | `FASTPyAttributeAccess` | My parent if I define the object of an attribute access (if it's the case).|
| `parentChevron` | `FASTPyExpression` | `expression` | `FASTPyChevron` | |
| `parentComparisonOperator` | `FASTPyExpression` | `operands` | `FASTPyComparisonOperator` | Parent comparison expression of which I am.|
| `parentComprehensionBody` | `FASTPyExpression` | `body` | `FASTPyComprehension` | |
| `parentComprehensionCondition` | `FASTPyExpression` | `conditions` | `FASTPyComprehension` | |
| `parentComprehensionForClause` | `FASTPyExpression` | `forClauses` | `FASTPyComprehension` | |
| `parentConditional` | `FASTTExpression` | `condition` | `FASTTWithCondition` | Optional condition statement/expression where this expression is used|
| `parentConditionalExpressionElse` | `FASTPyExpression` | `elseExpression` | `FASTPyConditionalExpression` | |
| `parentConditionalExpressionThen` | `FASTPyExpression` | `thenExpression` | `FASTPyConditionalExpression` | |
| `parentDefaultParameterValue` | `FASTPyExpression` | `defaultValue` | `FASTPyParameter` | |
| `parentExceptClause` | `FASTPyExpression` | `expression` | `FASTPyExceptClause` | |
| `parentExecStatementScopes` | `FASTPyExpression` | `scopes` | `FASTPyExecStatement` | |
| `parentExpression` | `FASTTExpression` | `expression` | `FASTTUnaryExpression` | Parent (unary) expression|
| `parentExpressionLeft` | `FASTTExpression` | `leftOperand` | `FASTTBinaryExpression` | Parent (binary) expression of which I am left side|
| `parentExpressionRight` | `FASTTExpression` | `rightOperand` | `FASTTBinaryExpression` | Parent (binary) expression of which I am right side|
| `parentForInClauseLeft` | `FASTPyExpression` | `left` | `FASTPyForInClause` | |
| `parentForInClauseRight` | `FASTPyExpression` | `right` | `FASTPyForInClause` | |
| `parentForStatementLeft` | `FASTPyExpression` | `left` | `FASTPyForStatement` | The for statement left owner (if possible)|
| `parentForStatementRight` | `FASTPyExpression` | `right` | `FASTPyForStatement` | The for statement right owner (if possible)|
| `parentIfClause` | `FASTPyExpression` | `expression` | `FASTPyIfClause` | |
| `parentInterpolation` | `FASTPyExpression` | `expression` | `FASTPyInterpolation` | |
| `parentKeywordArgument` | `FASTPyExpression` | `value` | `FASTPyKeywordArgument` | Keyword argument from which I am the value (if it's the case)|
| `parentLambda` | `FASTPyExpression` | `expression` | `FASTPyLambda` | |
| `parentMatchStatement` | `FASTPyExpression` | `subject` | `FASTPyMatchStatement` | |
| `parentPairKey` | `FASTPyExpression` | `key` | `FASTPyPair` | |
| `parentPairValuer` | `FASTPyExpression` | `value` | `FASTPyPair` | |
| `parentSlice` | `FASTPyExpression` | `components` | `FASTPySlice` | Slice in which I am a component (start, end or step) (If it's the case)'|
| `parentSubscriptIndex` | `FASTPyTSliceIndex` | `indices` | `FASTPySubscript` | My parent if I am defining an index to select of a subscript (if it's the case)|
| `parentSubscriptValue` | `FASTPyExpression` | `value` | `FASTPySubscript` | My parent if I define the receiver of a subscript (if it's the case).|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |
| `parentUnaryOperator` | `FASTPyExpression` | `argument` | `FASTPyTUnaryOperator` | Parent unary operator in which I am.|
| `parentWalrus` | `FASTPyExpression` | `value` | `FASTPyWalrus` | |
| `parentYield` | `FASTPyExpression` | `expression` | `FASTPyYield` | |
| `prarentPrintStatement` | `FASTPyExpression` | `expressions` | `FASTPyPrintStatement` | |
| `returnOwner` | `FASTTExpression` | `expression` | `FASTTReturnStatement` | The return statement that own the expression (if it's the case)|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyExpression',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTSliceIndex + FASTPyTTypeContent + FASTTExpression',
	#classTraits : 'FASTPyTSliceIndex classTrait + FASTPyTTypeContent classTrait + FASTTExpression classTrait',
	#instVars : [
		'#collectionInitializer => FMOne type: #FASTPyCollectionInitializer opposite: #initializers',
		'#parentAssertStatement => FMOne type: #FASTPyAssertStatement opposite: #expressions',
		'#parentAssignmentRight => FMOne type: #FASTPyAssignment opposite: #right',
		'#parentAttributeObject => FMOne type: #FASTPyAttributeAccess opposite: #value',
		'#parentChevron => FMOne type: #FASTPyChevron opposite: #expression',
		'#parentComparisonOperator => FMOne type: #FASTPyComparisonOperator opposite: #operands',
		'#parentComprehensionBody => FMOne type: #FASTPyComprehension opposite: #body',
		'#parentComprehensionCondition => FMOne type: #FASTPyComprehension opposite: #conditions',
		'#parentComprehensionForClause => FMOne type: #FASTPyComprehension opposite: #forClauses',
		'#parentConditionalExpressionElse => FMOne type: #FASTPyConditionalExpression opposite: #elseExpression',
		'#parentConditionalExpressionThen => FMOne type: #FASTPyConditionalExpression opposite: #thenExpression',
		'#parentDefaultParameterValue => FMOne type: #FASTPyParameter opposite: #defaultValue',
		'#parentExceptClause => FMOne type: #FASTPyExceptClause opposite: #expression',
		'#parentExecStatementScopes => FMOne type: #FASTPyExecStatement opposite: #scopes',
		'#parentForInClauseLeft => FMOne type: #FASTPyForInClause opposite: #left',
		'#parentForInClauseRight => FMOne type: #FASTPyForInClause opposite: #right',
		'#parentForStatementLeft => FMOne type: #FASTPyForStatement opposite: #left',
		'#parentForStatementRight => FMOne type: #FASTPyForStatement opposite: #right',
		'#parentIfClause => FMOne type: #FASTPyIfClause opposite: #expression',
		'#parentInterpolation => FMOne type: #FASTPyInterpolation opposite: #expression',
		'#parentKeywordArgument => FMOne type: #FASTPyKeywordArgument opposite: #value',
		'#parentLambda => FMOne type: #FASTPyLambda opposite: #expression',
		'#parentMatchStatement => FMOne type: #FASTPyMatchStatement opposite: #subject',
		'#parentPairKey => FMOne type: #FASTPyPair opposite: #key',
		'#parentPairValuer => FMOne type: #FASTPyPair opposite: #value',
		'#parentSlice => FMOne type: #FASTPySlice opposite: #components',
		'#parentSubscriptValue => FMOne type: #FASTPySubscript opposite: #value',
		'#parentUnaryOperator => FMOne type: #FASTPyTUnaryOperator opposite: #argument',
		'#parentWalrus => FMOne type: #FASTPyWalrus opposite: #value',
		'#parentYield => FMOne type: #FASTPyYield opposite: #expression',
		'#prarentPrintStatement => FMOne type: #FASTPyPrintStatement opposite: #expressions'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyExpression class >> annotation [

	<FMClass: #Expression super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
	<abstract>
]

{ #category : 'testing' }
FASTPyExpression class >> isAbstract [

	<generated>
	^ self == FASTPyExpression
]

{ #category : 'accessing' }
FASTPyExpression >> callOnMe [
	"See implementation in my superclass for an explanation of what I do."

	self parentAttributeObject ifNotNil: [ :attribute | ^ attribute caller ].

	self parentSubscriptValue ifNotNil: [ :subscript | ^ subscript caller ].

	^ super callOnMe
]

{ #category : 'accessing' }
FASTPyExpression >> collectionInitializer [
	"Relation named: #collectionInitializer type: #FASTPyCollectionInitializer opposite: #initializers"

	<generated>
	<FMComment: 'The owner of the expression'>
	<container>
	^ collectionInitializer
]

{ #category : 'accessing' }
FASTPyExpression >> collectionInitializer: anObject [

	<generated>
	collectionInitializer := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> internalAccess [

	self parentAttributeObject ifNotNil: [ :attribute | ^ attribute ].

	self parentSubscriptValue ifNotNil: [ :subscriptValue | ^ subscriptValue ].

	^ super internalAccess
]

{ #category : 'testing' }
FASTPyExpression >> isExpressionStatement [

	self containersDo: [ :container | (container isOfType: FASTTStatementBlock) ifTrue: [ ^ true ] ].

	^ false
]

{ #category : 'accessing' }
FASTPyExpression >> parentAssertStatement [
	"Relation named: #parentAssertStatement type: #FASTPyAssertStatement opposite: #expressions"

	<generated>
	<FMComment: 'The assert statement that own the expression (if it''s the case)'>
	<container>
	^ parentAssertStatement
]

{ #category : 'accessing' }
FASTPyExpression >> parentAssertStatement: anObject [

	<generated>
	parentAssertStatement := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentAssignmentRight [
	"Relation named: #parentAssignmentRight type: #FASTPyAssignment opposite: #right"

	<generated>
	<container>
	<derived>
	^ parentAssignmentRight
]

{ #category : 'accessing' }
FASTPyExpression >> parentAssignmentRight: anObject [

	<generated>
	parentAssignmentRight := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentAttributeObject [
	"Relation named: #parentAttributeObject type: #FASTPyAttributeAccess opposite: #value"

	<generated>
	<FMComment: 'My parent if I define the object of an attribute access (if it''s the case).'>
	<container>
	<derived>
	^ parentAttributeObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentAttributeObject: anObject [

	<generated>
	parentAttributeObject := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentChevron [
	"Relation named: #parentChevron type: #FASTPyChevron opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentChevron
]

{ #category : 'accessing' }
FASTPyExpression >> parentChevron: anObject [

	<generated>
	parentChevron := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentComparisonOperator [
	"Relation named: #parentComparisonOperator type: #FASTPyComparisonOperator opposite: #operands"

	<generated>
	<FMComment: 'Parent comparison expression of which I am.'>
	<container>
	^ parentComparisonOperator
]

{ #category : 'accessing' }
FASTPyExpression >> parentComparisonOperator: anObject [

	<generated>
	parentComparisonOperator := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionBody [
	"Relation named: #parentComprehensionBody type: #FASTPyComprehension opposite: #body"

	<generated>
	<container>
	<derived>
	^ parentComprehensionBody
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionBody: anObject [

	<generated>
	parentComprehensionBody := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionCondition [
	"Relation named: #parentComprehensionCondition type: #FASTPyComprehension opposite: #conditions"

	<generated>
	<container>
	^ parentComprehensionCondition
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionCondition: anObject [

	<generated>
	parentComprehensionCondition := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionForClause [
	"Relation named: #parentComprehensionForClause type: #FASTPyComprehension opposite: #forClauses"

	<generated>
	<container>
	^ parentComprehensionForClause
]

{ #category : 'accessing' }
FASTPyExpression >> parentComprehensionForClause: anObject [

	<generated>
	parentComprehensionForClause := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentConditionalExpressionElse [
	"Relation named: #parentConditionalExpressionElse type: #FASTPyConditionalExpression opposite: #elseExpression"

	<generated>
	<container>
	<derived>
	^ parentConditionalExpressionElse
]

{ #category : 'accessing' }
FASTPyExpression >> parentConditionalExpressionElse: anObject [

	<generated>
	parentConditionalExpressionElse := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentConditionalExpressionThen [
	"Relation named: #parentConditionalExpressionThen type: #FASTPyConditionalExpression opposite: #thenExpression"

	<generated>
	<container>
	<derived>
	^ parentConditionalExpressionThen
]

{ #category : 'accessing' }
FASTPyExpression >> parentConditionalExpressionThen: anObject [

	<generated>
	parentConditionalExpressionThen := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentDefaultParameterValue [
	"Relation named: #parentDefaultParameterValue type: #FASTPyParameter opposite: #defaultValue"

	<generated>
	<container>
	<derived>
	^ parentDefaultParameterValue
]

{ #category : 'accessing' }
FASTPyExpression >> parentDefaultParameterValue: anObject [

	<generated>
	parentDefaultParameterValue := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentExceptClause [
	"Relation named: #parentExceptClause type: #FASTPyExceptClause opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentExceptClause
]

{ #category : 'accessing' }
FASTPyExpression >> parentExceptClause: anObject [

	<generated>
	parentExceptClause := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentExecStatementScopes [
	"Relation named: #parentExecStatementScopes type: #FASTPyExecStatement opposite: #scopes"

	<generated>
	<container>
	^ parentExecStatementScopes
]

{ #category : 'accessing' }
FASTPyExpression >> parentExecStatementScopes: anObject [

	<generated>
	parentExecStatementScopes := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentForInClauseLeft [
	"Relation named: #parentForInClauseLeft type: #FASTPyForInClause opposite: #left"

	<generated>
	<container>
	<derived>
	^ parentForInClauseLeft
]

{ #category : 'accessing' }
FASTPyExpression >> parentForInClauseLeft: anObject [

	<generated>
	parentForInClauseLeft := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentForInClauseRight [
	"Relation named: #parentForInClauseRight type: #FASTPyForInClause opposite: #right"

	<generated>
	<container>
	<derived>
	^ parentForInClauseRight
]

{ #category : 'accessing' }
FASTPyExpression >> parentForInClauseRight: anObject [

	<generated>
	parentForInClauseRight := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentForStatementLeft [
	"Relation named: #parentForStatementLeft type: #FASTPyForStatement opposite: #left"

	<generated>
	<FMComment: 'The for statement left owner (if possible)'>
	<container>
	<derived>
	^ parentForStatementLeft
]

{ #category : 'accessing' }
FASTPyExpression >> parentForStatementLeft: anObject [

	<generated>
	parentForStatementLeft := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentForStatementRight [
	"Relation named: #parentForStatementRight type: #FASTPyForStatement opposite: #right"

	<generated>
	<FMComment: 'The for statement right owner (if possible)'>
	<container>
	<derived>
	^ parentForStatementRight
]

{ #category : 'accessing' }
FASTPyExpression >> parentForStatementRight: anObject [

	<generated>
	parentForStatementRight := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentIfClause [
	"Relation named: #parentIfClause type: #FASTPyIfClause opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentIfClause
]

{ #category : 'accessing' }
FASTPyExpression >> parentIfClause: anObject [

	<generated>
	parentIfClause := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentInterpolation [
	"Relation named: #parentInterpolation type: #FASTPyInterpolation opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentInterpolation
]

{ #category : 'accessing' }
FASTPyExpression >> parentInterpolation: anObject [

	<generated>
	parentInterpolation := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentKeywordArgument [
	"Relation named: #parentKeywordArgument type: #FASTPyKeywordArgument opposite: #value"

	<generated>
	<FMComment: 'Keyword argument from which I am the value (if it''s the case)'>
	<container>
	<derived>
	^ parentKeywordArgument
]

{ #category : 'accessing' }
FASTPyExpression >> parentKeywordArgument: anObject [

	<generated>
	parentKeywordArgument := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentLambda [
	"Relation named: #parentLambda type: #FASTPyLambda opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentLambda
]

{ #category : 'accessing' }
FASTPyExpression >> parentLambda: anObject [

	<generated>
	parentLambda := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentMatchStatement [
	"Relation named: #parentMatchStatement type: #FASTPyMatchStatement opposite: #subject"

	<generated>
	<container>
	<derived>
	^ parentMatchStatement
]

{ #category : 'accessing' }
FASTPyExpression >> parentMatchStatement: anObject [

	<generated>
	parentMatchStatement := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentPairKey [
	"Relation named: #parentPairKey type: #FASTPyPair opposite: #key"

	<generated>
	<container>
	<derived>
	^ parentPairKey
]

{ #category : 'accessing' }
FASTPyExpression >> parentPairKey: anObject [

	<generated>
	parentPairKey := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentPairValuer [
	"Relation named: #parentPairValuer type: #FASTPyPair opposite: #value"

	<generated>
	<container>
	<derived>
	^ parentPairValuer
]

{ #category : 'accessing' }
FASTPyExpression >> parentPairValuer: anObject [

	<generated>
	parentPairValuer := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentSlice [
	"Relation named: #parentSlice type: #FASTPySlice opposite: #components"

	<generated>
	<FMComment: 'Slice in which I am a component (start, end or step) (If it''s the case)'''>
	<container>
	^ parentSlice
]

{ #category : 'accessing' }
FASTPyExpression >> parentSlice: anObject [

	<generated>
	parentSlice := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentSubscriptValue [
	"Relation named: #parentSubscriptValue type: #FASTPySubscript opposite: #value"

	<generated>
	<FMComment: 'My parent if I define the receiver of a subscript (if it''s the case).'>
	<container>
	<derived>
	^ parentSubscriptValue
]

{ #category : 'accessing' }
FASTPyExpression >> parentSubscriptValue: anObject [

	<generated>
	parentSubscriptValue := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentUnaryOperator [
	"Relation named: #parentUnaryOperator type: #FASTPyTUnaryOperator opposite: #argument"

	<generated>
	<FMComment: 'Parent unary operator in which I am.'>
	<container>
	<derived>
	^ parentUnaryOperator
]

{ #category : 'accessing' }
FASTPyExpression >> parentUnaryOperator: anObject [

	<generated>
	parentUnaryOperator := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentWalrus [
	"Relation named: #parentWalrus type: #FASTPyWalrus opposite: #value"

	<generated>
	<container>
	<derived>
	^ parentWalrus
]

{ #category : 'accessing' }
FASTPyExpression >> parentWalrus: anObject [

	<generated>
	parentWalrus := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> parentYield [
	"Relation named: #parentYield type: #FASTPyYield opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentYield
]

{ #category : 'accessing' }
FASTPyExpression >> parentYield: anObject [

	<generated>
	parentYield := anObject
]

{ #category : 'accessing' }
FASTPyExpression >> prarentPrintStatement [
	"Relation named: #prarentPrintStatement type: #FASTPyPrintStatement opposite: #expressions"

	<generated>
	<container>
	^ prarentPrintStatement
]

{ #category : 'accessing' }
FASTPyExpression >> prarentPrintStatement: anObject [

	<generated>
	prarentPrintStatement := anObject
]
