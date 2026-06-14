"
I represent something that can be the receiver of a call

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|



"
Trait {
	#name : 'FASTPyTCallable',
	#instVars : [
		'#caller => FMOne type: #FASTPyCall opposite: #callee'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTCallable classSide >> annotation [

	<FMClass: #TCallable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTCallable >> caller [
	"Relation named: #caller type: #FASTPyCall opposite: #callee"

	<generated>
	<FMComment: 'The call entity calling me (if it''s the case)'>
	<container>
	<derived>
	^ caller
]

{ #category : 'accessing' }
FASTPyTCallable >> caller: anObject [

	<generated>
	caller := anObject
]
