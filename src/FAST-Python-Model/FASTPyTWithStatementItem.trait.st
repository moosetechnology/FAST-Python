"
I represent an entity that can be the item of a with_statement.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentWithStatementItem` | `FASTPyTWithStatementItem` | `items` | `FASTPyWithStatement` | |



"
Trait {
	#name : 'FASTPyTWithStatementItem',
	#instVars : [
		'#parentWithStatementItem => FMOne type: #FASTPyWithStatement opposite: #items'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTWithStatementItem classSide >> annotation [

	<ignoreForCoverage>
	<FMClass: #TWithStatementItem super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTWithStatementItem >> parentWithStatementItem [
	"Relation named: #parentWithStatementItem type: #FASTPyWithStatement opposite: #items"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentWithStatementItem
]

{ #category : 'accessing' }
FASTPyTWithStatementItem >> parentWithStatementItem: anObject [

	<ignoreForCoverage>
	<generated>
	parentWithStatementItem := anObject
]
