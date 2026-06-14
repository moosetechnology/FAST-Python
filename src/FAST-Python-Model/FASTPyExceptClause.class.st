"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `parentTryStatement` | `FASTPyExceptClause` | `excepts` | `FASTPyTryStatement` | |
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expressions` | `FASTPyExceptClause` | `parentExceptClause` | `FASTPyExpression` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `alias` | `String` | nil | Alias used if an as pattern is used in the clause.|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyExceptClause',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTStatementBlock',
	#classTraits : 'FASTTStatementBlock classTrait',
	#instVars : [
		'#alias => FMProperty',
		'#expressions => FMMany type: #FASTPyExpression opposite: #parentExceptClause',
		'#parentTryStatement => FMOne type: #FASTPyTryStatement opposite: #excepts'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyExceptClause class >> annotation [

	<FMClass: #ExceptClause super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyExceptClause >> addExpression: anObject [
	<generated>
	^ self expressions add: anObject
]

{ #category : 'accessing' }
FASTPyExceptClause >> alias [

	<FMProperty: #alias type: #String>
	<generated>
	<FMComment: 'Alias used if an as pattern is used in the clause.'>
	^ alias
]

{ #category : 'accessing' }
FASTPyExceptClause >> alias: anObject [
	<generated>
	alias := anObject
]

{ #category : 'accessing' }
FASTPyExceptClause >> expressions [
	"Relation named: #expressions type: #FASTPyExpression opposite: #parentExceptClause"

	<generated>
	<derived>
	^ expressions
]

{ #category : 'accessing' }
FASTPyExceptClause >> expressions: anObject [

	<generated>
	expressions value: anObject
]

{ #category : 'accessing' }
FASTPyExceptClause >> parentTryStatement [
	"Relation named: #parentTryStatement type: #FASTPyTryStatement opposite: #excepts"

	<generated>
	<container>
	^ parentTryStatement
]

{ #category : 'accessing' }
FASTPyExceptClause >> parentTryStatement: anObject [

	<generated>
	parentTryStatement := anObject
]
