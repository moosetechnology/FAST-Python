"
I represent an expression that can be in a delete statement.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentDeleteStatement` | `FASTPyTDeletable` | `expression` | `FASTPyDeleteStatement` | The delete statement that own the expression (if it's the case)|



"
Trait {
	#name : 'FASTPyTDeletable',
	#instVars : [
		'#parentDeleteStatement => FMOne type: #FASTPyDeleteStatement opposite: #expression'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTDeletable classSide >> annotation [

	<FMClass: #TDeletable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTDeletable >> parentDeleteStatement [
	"Relation named: #parentDeleteStatement type: #FASTPyDeleteStatement opposite: #expression"

	<generated>
	<FMComment: 'The delete statement that own the expression (if it''s the case)'>
	<container>
	<derived>
	^ parentDeleteStatement
]

{ #category : 'accessing' }
FASTPyTDeletable >> parentDeleteStatement: anObject [

	<generated>
	parentDeleteStatement := anObject
]
