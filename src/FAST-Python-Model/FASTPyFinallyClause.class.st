"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `parentTryStatement` | `FASTPyFinallyClause` | `finally` | `FASTPyTryStatement` | |
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyFinallyClause',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTStatementBlock',
	#classTraits : 'FASTTStatementBlock classTrait',
	#instVars : [
		'#parentTryStatement => FMOne type: #FASTPyTryStatement opposite: #finally'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyFinallyClause class >> annotation [

	<FMClass: #FinallyClause super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyFinallyClause >> parentTryStatement [
	"Relation named: #parentTryStatement type: #FASTPyTryStatement opposite: #finally"

	<generated>
	<container>
	<derived>
	^ parentTryStatement
]

{ #category : 'accessing' }
FASTPyFinallyClause >> parentTryStatement: anObject [

	<generated>
	parentTryStatement := anObject
]
