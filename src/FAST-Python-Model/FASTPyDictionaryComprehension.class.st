"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `body` | `FASTPyTComprehension` | `comprehensionBodyOwner` | `FASTPyExpression` | |
| `clauses` | `FASTPyTComprehension` | `comprehensionClauseOwner` | `FASTPyExpression` | |
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|



"
Class {
	#name : 'FASTPyDictionaryComprehension',
	#superclass : 'FASTPyComprehension',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyDictionaryComprehension class >> annotation [

	<FMClass: #DictionaryComprehension super: #FASTPyComprehension>
	<package: #'FAST-Python-Model'>
	<generated>
]
