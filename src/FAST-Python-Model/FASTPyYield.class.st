"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyYield` | `parentYield` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyYield',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#expression => FMOne type: #FASTPyExpression opposite: #parentYield'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyYield class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Yield super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyYield >> expression [
	"Relation named: #expression type: #FASTPyExpression opposite: #parentYield"

	<ignoreForCoverage>
	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyYield >> expression: anObject [

	<ignoreForCoverage>
	<generated>
	expression := anObject
]
