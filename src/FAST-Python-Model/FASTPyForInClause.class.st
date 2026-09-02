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

	<ignoreForCoverage>
	<FMClass: #ForInClause super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyForInClause >> assignedExpressions [

	^ { self right }
]

{ #category : 'accessing' }
FASTPyForInClause >> left [
	"Relation named: #left type: #FASTPyExpression opposite: #parentForInClauseLeft"

	<ignoreForCoverage>
	<generated>
	^ left
]

{ #category : 'accessing' }
FASTPyForInClause >> left: anObject [

	<ignoreForCoverage>
	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyForInClause >> right [
	"Relation named: #right type: #FASTPyExpression opposite: #parentForInClauseRight"

	<ignoreForCoverage>
	<generated>
	^ right
]

{ #category : 'accessing' }
FASTPyForInClause >> right: anObject [

	<ignoreForCoverage>
	<generated>
	right := anObject
]
