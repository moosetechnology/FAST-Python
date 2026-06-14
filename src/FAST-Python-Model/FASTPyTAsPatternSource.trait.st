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

	<FMClass: #TAsPatternSource super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTAsPatternSource >> parentAsPatternSource [
	"Relation named: #parentAsPatternSource type: #FASTPyAsPattern opposite: #source"

	<generated>
	<container>
	<derived>
	^ parentAsPatternSource
]

{ #category : 'accessing' }
FASTPyTAsPatternSource >> parentAsPatternSource: anObject [

	<generated>
	parentAsPatternSource := anObject
]
