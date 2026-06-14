"
I represent an entity with type parameters such as generic types, function/method definition or class definition

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `typeParameters` | `FASTPyTWithTypeParameters` | `parentWithTypeParameters` | `FASTPyType` | |



"
Trait {
	#name : 'FASTPyTWithTypeParameters',
	#instVars : [
		'#typeParameters => FMMany type: #FASTPyType opposite: #parentWithTypeParameters'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTWithTypeParameters classSide >> annotation [

	<FMClass: #TWithTypeParameters super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyTWithTypeParameters >> addTypeParameter: anObject [
	<generated>
	^ self typeParameters add: anObject
]

{ #category : 'accessing' }
FASTPyTWithTypeParameters >> typeParameters [
	"Relation named: #typeParameters type: #FASTPyType opposite: #parentWithTypeParameters"

	<generated>
	<derived>
	^ typeParameters
]

{ #category : 'accessing' }
FASTPyTWithTypeParameters >> typeParameters: anObject [

	<generated>
	typeParameters value: anObject
]
