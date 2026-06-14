"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|
| `elifClauses` | `FASTPyIfStatement` | `parentIfStatement` | `FASTPyElifClause` | |
| `elseClause` | `FASTPyTWithElseClause` | `parentIfStatement` | `FASTPyElseClause` | |
| `thenClause` | `FASTPyIfStatement` | `parentIfStatement` | `FASTPyThenClause` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyIfStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTWithElseClause + FASTTConditionalStatement',
	#classTraits : 'FASTPyTWithElseClause classTrait + FASTTConditionalStatement classTrait',
	#instVars : [
		'#elifClauses => FMMany type: #FASTPyElifClause opposite: #parentIfStatement',
		'#thenClause => FMOne type: #FASTPyThenClause opposite: #parentIfStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyIfStatement class >> annotation [

	<FMClass: #IfStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyIfStatement >> addElifClause: anObject [
	<generated>
	^ self elifClauses add: anObject
]

{ #category : 'accessing' }
FASTPyIfStatement >> elifClauses [
	"Relation named: #elifClauses type: #FASTPyElifClause opposite: #parentIfStatement"

	<generated>
	<derived>
	^ elifClauses
]

{ #category : 'accessing' }
FASTPyIfStatement >> elifClauses: anObject [

	<generated>
	elifClauses value: anObject
]

{ #category : 'accessing' }
FASTPyIfStatement >> thenClause [
	"Relation named: #thenClause type: #FASTPyThenClause opposite: #parentIfStatement"

	<generated>
	^ thenClause
]

{ #category : 'accessing' }
FASTPyIfStatement >> thenClause: anObject [

	<generated>
	thenClause := anObject
]
