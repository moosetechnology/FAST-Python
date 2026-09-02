"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variables` | `FASTPyNonlocalStatement` | `parentNonlocalStatement` | `FASTPyVariable` | The variables scoped|



"
Class {
	#name : 'FASTPyNonlocalStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#variables => FMMany type: #FASTPyVariable opposite: #parentNonlocalStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyNonlocalStatement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #NonlocalStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyNonlocalStatement >> addVariable: anObject [

	<ignoreForCoverage>
	<generated>
	^ self variables add: anObject
]

{ #category : 'accessing' }
FASTPyNonlocalStatement >> variables [
	"Relation named: #variables type: #FASTPyVariable opposite: #parentNonlocalStatement"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The variables scoped'>
	<derived>
	^ variables
]

{ #category : 'accessing' }
FASTPyNonlocalStatement >> variables: anObject [

	<ignoreForCoverage>
	<generated>
	variables value: anObject
]
