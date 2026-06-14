"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `elseClause` | `FASTPyTWithElseClause` | `parentIfStatement` | `FASTPyElseClause` | |



"
Trait {
	#name : 'FASTPyTWithElseClause',
	#instVars : [
		'#elseClause => FMOne type: #FASTPyElseClause opposite: #parentIfStatement'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTWithElseClause classSide >> annotation [

	<FMClass: #TWithElseClause super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTWithElseClause >> elseClause [
	"Relation named: #elseClause type: #FASTPyElseClause opposite: #parentIfStatement"

	<generated>
	^ elseClause
]

{ #category : 'accessing' }
FASTPyTWithElseClause >> elseClause: anObject [

	<generated>
	elseClause := anObject
]
