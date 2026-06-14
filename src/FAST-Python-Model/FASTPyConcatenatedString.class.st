"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `strings` | `FASTPyConcatenatedString` | `parentConcatenatedString` | `FASTPyString` | |



"
Class {
	#name : 'FASTPyConcatenatedString',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#strings => FMMany type: #FASTPyString opposite: #parentConcatenatedString'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyConcatenatedString class >> annotation [

	<FMClass: #ConcatenatedString super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyConcatenatedString >> addString: anObject [
	<generated>
	^ self strings add: anObject
]

{ #category : 'accessing' }
FASTPyConcatenatedString >> strings [
	"Relation named: #strings type: #FASTPyString opposite: #parentConcatenatedString"

	<generated>
	<derived>
	^ strings
]

{ #category : 'accessing' }
FASTPyConcatenatedString >> strings: anObject [

	<generated>
	strings value: anObject
]
