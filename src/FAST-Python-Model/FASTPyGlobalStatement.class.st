"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `variables` | `FASTPyGlobalStatement` | `parentGlobalStatement` | `FASTPyVariable` | The variables scoped|



"
Class {
	#name : 'FASTPyGlobalStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#variables => FMMany type: #FASTPyVariable opposite: #parentGlobalStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyGlobalStatement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #GlobalStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyGlobalStatement >> addVariable: anObject [

	<ignoreForCoverage>
	<generated>
	^ self variables add: anObject
]

{ #category : 'accessing' }
FASTPyGlobalStatement >> variables [
	"Relation named: #variables type: #FASTPyVariable opposite: #parentGlobalStatement"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The variables scoped'>
	<derived>
	^ variables
]

{ #category : 'accessing' }
FASTPyGlobalStatement >> variables: anObject [

	<ignoreForCoverage>
	<generated>
	variables value: anObject
]
