"
I am an abstract class to represent collection initializers in Python. I should be transformed into a trait to put in FAST directly.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentCaseClause` | `FASTPyTPattern` | `pattern` | `FASTPyCaseClause` | |
| `parentKeywordPatternValue` | `FASTPyTPattern` | `value` | `FASTPyKeywordPattern` | |
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |
| `parentUnionPattern` | `FASTPyTPattern` | `members` | `FASTPyUnionPattern` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `initializers` | `FASTPyCollectionInitializer` | `collectionInitializer` | `FASTPyExpression` | Each initializer defines one element.|



"
Class {
	#name : 'FASTPyCollectionInitializer',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTPattern + FASTPyTSplatExpression',
	#classTraits : 'FASTPyTPattern classTrait + FASTPyTSplatExpression classTrait',
	#instVars : [
		'#initializers => FMMany type: #FASTPyExpression opposite: #collectionInitializer'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyCollectionInitializer class >> annotation [

	<FMClass: #CollectionInitializer super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyCollectionInitializer >> addInitializer: anObject [
	<generated>
	^ self initializers add: anObject
]

{ #category : 'accessing' }
FASTPyCollectionInitializer >> initializers [
	"Relation named: #initializers type: #FASTPyExpression opposite: #collectionInitializer"

	<generated>
	<FMComment: 'Each initializer defines one element.'>
	<derived>
	^ initializers
]

{ #category : 'accessing' }
FASTPyCollectionInitializer >> initializers: anObject [

	<generated>
	initializers value: anObject
]
