"
My users are parameter target in a splat. For example in `def f(*list): pass`, we have a list splat parameter named list.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentSplatParameter` | `FASTPyTSplatParameterTarget` | `target` | `FASTPySplatParameter` | |



"
Trait {
	#name : 'FASTPyTSplatParameterTarget',
	#instVars : [
		'#parentSplatParameter => FMOne type: #FASTPySplatParameter opposite: #target'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTSplatParameterTarget classSide >> annotation [

	<FMClass: #TSplatParameterTarget super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTSplatParameterTarget >> parentSplatParameter [
	"Relation named: #parentSplatParameter type: #FASTPySplatParameter opposite: #target"

	<generated>
	<container>
	<derived>
	^ parentSplatParameter
]

{ #category : 'accessing' }
FASTPyTSplatParameterTarget >> parentSplatParameter: anObject [

	<generated>
	parentSplatParameter := anObject
]
