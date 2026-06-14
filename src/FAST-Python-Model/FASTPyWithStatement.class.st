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
| `items` | `FASTPyWithStatement` | `parentWithStatementItem` | `FASTPyTWithStatementItem` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyWithStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTTStatementBlock',
	#classTraits : 'FASTTStatementBlock classTrait',
	#instVars : [
		'#items => FMMany type: #FASTPyTWithStatementItem opposite: #parentWithStatementItem'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyWithStatement class >> annotation [

	<FMClass: #WithStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyWithStatement >> addItem: anObject [
	<generated>
	^ self items add: anObject
]

{ #category : 'accessing' }
FASTPyWithStatement >> items [
	"Relation named: #items type: #FASTPyTWithStatementItem opposite: #parentWithStatementItem"

	<generated>
	<derived>
	^ items
]

{ #category : 'accessing' }
FASTPyWithStatement >> items: anObject [

	<generated>
	items value: anObject
]
