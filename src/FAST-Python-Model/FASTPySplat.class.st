"
In Python a collection (list or dictionary) splat is the unpacking of a collection in a call or in the definition of another definition like `[ *list , 4 ]` or `func(*list)`

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentCaseClause` | `FASTPyTPattern` | `pattern` | `FASTPyCaseClause` | |
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |
| `parentKeywordPatternValue` | `FASTPyTPattern` | `value` | `FASTPyKeywordPattern` | |
| `parentUnionPattern` | `FASTPyTPattern` | `members` | `FASTPyUnionPattern` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPySplat` | `parentSplat` | `FASTPyTSplatExpression` | |



"
Class {
	#name : 'FASTPySplat',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTPattern + FASTPyTSuperclass',
	#classTraits : 'FASTPyTPattern classTrait + FASTPyTSuperclass classTrait',
	#instVars : [
		'#expression => FMOne type: #FASTPyTSplatExpression opposite: #parentSplat'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPySplat class >> annotation [

	<FMClass: #Splat super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPySplat >> expression [
	"Relation named: #expression type: #FASTPyTSplatExpression opposite: #parentSplat"

	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPySplat >> expression: anObject [

	<generated>
	expression := anObject
]

{ #category : 'testing' }
FASTPySplat >> isDictionarySplat [

	<FMProperty>
	<derived>
	<comment: 'If I return true, I correspond to a dictionary splat such as **kwargs. Else I am a list or set splat like *args.'>
	^ self sourceCode beginsWith: '**'
]
