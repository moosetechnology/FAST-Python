"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `key` | `FASTPyPair` | `parentPairKey` | `FASTPyExpression` | |
| `value` | `FASTPyPair` | `parentPairValuer` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyPair',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#key => FMOne type: #FASTPyExpression opposite: #parentPairKey',
		'#value => FMOne type: #FASTPyExpression opposite: #parentPairValuer'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyPair class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Pair super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyPair >> key [
	"Relation named: #key type: #FASTPyExpression opposite: #parentPairKey"

	<ignoreForCoverage>
	<generated>
	^ key
]

{ #category : 'accessing' }
FASTPyPair >> key: anObject [

	<ignoreForCoverage>
	<generated>
	key := anObject
]

{ #category : 'accessing' }
FASTPyPair >> value [
	"Relation named: #value type: #FASTPyExpression opposite: #parentPairValuer"

	<ignoreForCoverage>
	<generated>
	^ value
]

{ #category : 'accessing' }
FASTPyPair >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
