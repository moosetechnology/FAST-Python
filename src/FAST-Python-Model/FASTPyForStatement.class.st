"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `elseClause` | `FASTPyTWithElseClause` | `parentIfStatement` | `FASTPyElseClause` | |
| `left` | `FASTPyForStatement` | `parentForStatementRight` | `FASTPyExpression` | The identifier of the created local variable or tuple|
| `right` | `FASTPyForStatement` | `parentForStatementLeft` | `FASTPyExpression` | The list that the for statement iterates over|
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyForStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTWithElseClause + FASTTStatementBlock',
	#classTraits : 'FASTPyTWithElseClause classTrait + FASTTStatementBlock classTrait',
	#instVars : [
		'#left => FMOne type: #FASTPyExpression opposite: #parentForStatementRight',
		'#right => FMOne type: #FASTPyExpression opposite: #parentForStatementLeft'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyForStatement class >> annotation [

	<FMClass: #ForStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyForStatement >> left [
	"Relation named: #left type: #FASTPyExpression opposite: #parentForStatementRight"

	<generated>
	<FMComment: 'The identifier of the created local variable or tuple'>
	^ left
]

{ #category : 'accessing' }
FASTPyForStatement >> left: anObject [

	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyForStatement >> right [
	"Relation named: #right type: #FASTPyExpression opposite: #parentForStatementLeft"

	<generated>
	<FMComment: 'The list that the for statement iterates over'>
	^ right
]

{ #category : 'accessing' }
FASTPyForStatement >> right: anObject [

	<generated>
	right := anObject
]
