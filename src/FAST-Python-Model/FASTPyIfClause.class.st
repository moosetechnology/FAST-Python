"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyIfClause` | `parentIfClause` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyIfClause',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#expression => FMOne type: #FASTPyExpression opposite: #parentIfClause'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyIfClause class >> annotation [

	<ignoreForCoverage>
	<FMClass: #IfClause super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyIfClause >> expression [
	"Relation named: #expression type: #FASTPyExpression opposite: #parentIfClause"

	<ignoreForCoverage>
	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyIfClause >> expression: anObject [

	<ignoreForCoverage>
	<generated>
	expression := anObject
]
