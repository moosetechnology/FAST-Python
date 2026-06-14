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
| `excepts` | `FASTPyTryStatement` | `parentTryStatement` | `FASTPyExceptClause` | |
| `finally` | `FASTPyTryStatement` | `parentTryStatement` | `FASTPyFinallyClause` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyTryStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTWithElseClause + FASTTStatementBlock',
	#classTraits : 'FASTPyTWithElseClause classTrait + FASTTStatementBlock classTrait',
	#instVars : [
		'#excepts => FMMany type: #FASTPyExceptClause opposite: #parentTryStatement',
		'#finally => FMOne type: #FASTPyFinallyClause opposite: #parentTryStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyTryStatement class >> annotation [

	<FMClass: #TryStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyTryStatement >> addExcept: anObject [
	<generated>
	^ self excepts add: anObject
]

{ #category : 'accessing' }
FASTPyTryStatement >> excepts [
	"Relation named: #excepts type: #FASTPyExceptClause opposite: #parentTryStatement"

	<generated>
	<derived>
	^ excepts
]

{ #category : 'accessing' }
FASTPyTryStatement >> excepts: anObject [

	<generated>
	excepts value: anObject
]

{ #category : 'accessing' }
FASTPyTryStatement >> finally [
	"Relation named: #finally type: #FASTPyFinallyClause opposite: #parentTryStatement"

	<generated>
	^ finally
]

{ #category : 'accessing' }
FASTPyTryStatement >> finally: anObject [

	<generated>
	finally := anObject
]
