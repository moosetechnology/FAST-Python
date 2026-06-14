"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentIfStatement` | `FASTPyElifClause` | `elifClauses` | `FASTPyIfStatement` | |
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyElifClause',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTConditionalStatement + FASTTStatementBlock',
	#classTraits : 'FASTTConditionalStatement classTrait + FASTTStatementBlock classTrait',
	#instVars : [
		'#parentIfStatement => FMOne type: #FASTPyIfStatement opposite: #elifClauses'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyElifClause class >> annotation [

	<FMClass: #ElifClause super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyElifClause >> parentIfStatement [
	"Relation named: #parentIfStatement type: #FASTPyIfStatement opposite: #elifClauses"

	<generated>
	<container>
	^ parentIfStatement
]

{ #category : 'accessing' }
FASTPyElifClause >> parentIfStatement: anObject [

	<generated>
	parentIfStatement := anObject
]
