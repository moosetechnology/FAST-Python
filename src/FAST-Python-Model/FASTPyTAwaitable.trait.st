"
I represent an entity that is awaitable and can be in an await statement

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAwait` | `FASTPyTAwaitable` | `expression` | `FASTPyAwait` | |



"
Trait {
	#name : 'FASTPyTAwaitable',
	#instVars : [
		'#parentAwait => FMOne type: #FASTPyAwait opposite: #expression'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTAwaitable classSide >> annotation [

	<FMClass: #TAwaitable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTAwaitable >> parentAwait [
	"Relation named: #parentAwait type: #FASTPyAwait opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentAwait
]

{ #category : 'accessing' }
FASTPyTAwaitable >> parentAwait: anObject [

	<generated>
	parentAwait := anObject
]
