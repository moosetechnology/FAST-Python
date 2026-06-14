"
I represent an entity that could be the alias/target of an as pattern.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |
| `parentAsPatternTarget` | `FASTPyTAsPatternTarget` | `target` | `FASTPyAsPattern` | |



"
Trait {
	#name : 'FASTPyTAsPatternTarget',
	#instVars : [
		'#parentAsPatternTarget => FMOne type: #FASTPyAsPattern opposite: #target'
	],
	#traits : 'FASTPyTAsPatternSource',
	#classTraits : 'FASTPyTAsPatternSource classTrait',
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTAsPatternTarget classSide >> annotation [

	<FMClass: #TAsPatternTarget super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTAsPatternTarget >> parentAsPatternTarget [
	"Relation named: #parentAsPatternTarget type: #FASTPyAsPattern opposite: #target"

	<generated>
	<container>
	<derived>
	^ parentAsPatternTarget
]

{ #category : 'accessing' }
FASTPyTAsPatternTarget >> parentAsPatternTarget: anObject [

	<generated>
	parentAsPatternTarget := anObject
]
