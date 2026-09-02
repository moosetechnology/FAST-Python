"
I represent an entity that could be aliased in an as pattern.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |



"
Trait {
	#name : 'FASTPyTAsPatternSource',
	#instVars : [
		'#parentAsPatternSource => FMOne type: #FASTPyAsPattern opposite: #source'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTAsPatternSource classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #TAsPatternSource super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTAsPatternSource >> parentAsPatternSource [
	"Relation named: #parentAsPatternSource type: #FASTPyAsPattern opposite: #source"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentAsPatternSource
]

{ #category : 'accessing' }
FASTPyTAsPatternSource >> parentAsPatternSource: anObject [

	<ignoreForCoverage>
	<generated>
	parentAsPatternSource := anObject
]
