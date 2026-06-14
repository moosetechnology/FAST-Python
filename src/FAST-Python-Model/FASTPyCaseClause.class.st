"
I represent a case clause in a match statement in Python.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `parentMatchStatement` | `FASTPyCaseClause` | `cases` | `FASTPyMatchStatement` | |
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|
| `pattern` | `FASTPyCaseClause` | `parentCaseClause` | `FASTPyTPattern` | |
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
	#name : 'FASTPyCaseClause',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTStatementBlock + FASTTWithCondition',
	#classTraits : 'FASTTStatementBlock classTrait + FASTTWithCondition classTrait',
	#instVars : [
		'#alias => FMProperty',
		'#parentMatchStatement => FMOne type: #FASTPyMatchStatement opposite: #cases',
		'#pattern => FMOne type: #FASTPyTPattern opposite: #parentCaseClause'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyCaseClause class >> annotation [

	<FMClass: #CaseClause super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyCaseClause >> alias [

	<FMProperty: #alias type: #String>
	<generated>
	<FMComment: 'Alias used if an as pattern is used in the clause.'>
	^ alias
]

{ #category : 'accessing' }
FASTPyCaseClause >> alias: anObject [
	<generated>
	alias := anObject
]

{ #category : 'accessing' }
FASTPyCaseClause >> parentMatchStatement [
	"Relation named: #parentMatchStatement type: #FASTPyMatchStatement opposite: #cases"

	<generated>
	<container>
	^ parentMatchStatement
]

{ #category : 'accessing' }
FASTPyCaseClause >> parentMatchStatement: anObject [

	<generated>
	parentMatchStatement := anObject
]

{ #category : 'accessing' }
FASTPyCaseClause >> pattern [
	"Relation named: #pattern type: #FASTPyTPattern opposite: #parentCaseClause"

	<generated>
	^ pattern
]

{ #category : 'accessing' }
FASTPyCaseClause >> pattern: anObject [

	<generated>
	pattern := anObject
]
