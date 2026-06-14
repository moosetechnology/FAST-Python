"
My user can be used as a type declaration

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |



"
Trait {
	#name : 'FASTPyTTypeContent',
	#instVars : [
		'#parentType => FMOne type: #FASTPyType opposite: #content'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTTypeContent classSide >> annotation [

	<FMClass: #TTypeContent super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTTypeContent >> parentType [
	"Relation named: #parentType type: #FASTPyType opposite: #content"

	<generated>
	<container>
	<derived>
	^ parentType
]

{ #category : 'accessing' }
FASTPyTTypeContent >> parentType: anObject [

	<generated>
	parentType := anObject
]
