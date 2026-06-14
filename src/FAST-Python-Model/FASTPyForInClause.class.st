"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `left` | `FASTPyForInClause` | `parentForInClauseLeft` | `FASTPyExpression` | |
| `right` | `FASTPyForInClause` | `parentForInClauseRight` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyForInClause',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#left => FMOne type: #FASTPyExpression opposite: #parentForInClauseLeft',
		'#right => FMOne type: #FASTPyExpression opposite: #parentForInClauseRight'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyForInClause class >> annotation [

	<FMClass: #ForInClause super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyForInClause >> left [
	"Relation named: #left type: #FASTPyExpression opposite: #parentForInClauseLeft"

	<generated>
	^ left
]

{ #category : 'accessing' }
FASTPyForInClause >> left: anObject [

	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyForInClause >> right [
	"Relation named: #right type: #FASTPyExpression opposite: #parentForInClauseRight"

	<generated>
	^ right
]

{ #category : 'accessing' }
FASTPyForInClause >> right: anObject [

	<generated>
	right := anObject
]
