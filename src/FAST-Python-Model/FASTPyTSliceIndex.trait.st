"
I represent an entity that can be in the brackets of a subscript.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentSubscriptIndex` | `FASTPyTSliceIndex` | `indices` | `FASTPySubscript` | My parent if I am defining an index to select of a subscript (if it's the case)|



"
Trait {
	#name : 'FASTPyTSliceIndex',
	#instVars : [
		'#parentSubscriptIndex => FMOne type: #FASTPySubscript opposite: #indices'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTSliceIndex classSide >> annotation [

	<FMClass: #TSliceIndex super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTSliceIndex >> parentSubscriptIndex [
	"Relation named: #parentSubscriptIndex type: #FASTPySubscript opposite: #indices"

	<generated>
	<FMComment: 'My parent if I am defining an index to select of a subscript (if it''s the case)'>
	<container>
	^ parentSubscriptIndex
]

{ #category : 'accessing' }
FASTPyTSliceIndex >> parentSubscriptIndex: anObject [

	<generated>
	parentSubscriptIndex := anObject
]
