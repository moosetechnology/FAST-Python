"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parentCaseClause` | `FASTPyTPattern` | `pattern` | `FASTPyCaseClause` | |
| `parentClassPattern` | `FASTPyTClassPatternElement` | `elements` | `FASTPyClassPattern` | |
| `parentKeywordPatternValue` | `FASTPyTPattern` | `value` | `FASTPyKeywordPattern` | |
| `parentUnionPattern` | `FASTPyTPattern` | `members` | `FASTPyUnionPattern` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `FASTPyKeywordPattern` | `parentKeywordPatternValue` | `FASTPyTPattern` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyKeywordPattern',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTClassPatternElement + FASTPyTPattern + FASTTNamedEntity',
	#classTraits : 'FASTPyTClassPatternElement classTrait + FASTPyTPattern classTrait + FASTTNamedEntity classTrait',
	#instVars : [
		'#value => FMOne type: #FASTPyTPattern opposite: #parentKeywordPatternValue'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyKeywordPattern class >> annotation [

	<FMClass: #KeywordPattern super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyKeywordPattern >> value [
	"Relation named: #value type: #FASTPyTPattern opposite: #parentKeywordPatternValue"

	<generated>
	^ value
]

{ #category : 'accessing' }
FASTPyKeywordPattern >> value: anObject [

	<generated>
	value := anObject
]
