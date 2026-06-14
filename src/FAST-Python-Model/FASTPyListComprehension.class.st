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
	#name : 'FASTPyListComprehension',
	#superclass : 'FASTPyComprehension',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyListComprehension class >> annotation [

	<FMClass: #ListComprehension super: #FASTPyComprehension>
	<package: #'FAST-Python-Model'>
	<generated>
]
