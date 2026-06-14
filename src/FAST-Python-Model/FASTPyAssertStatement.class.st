"
I represent an assert statement node in python. It hold a collection of expressions to assert.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expressions` | `FASTPyAssertStatement` | `parentAssertStatement` | `FASTPyExpression` | The expressions asserted|



"
Class {
	#name : 'FASTPyAssertStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#expressions => FMMany type: #FASTPyExpression opposite: #parentAssertStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAssertStatement class >> annotation [

	<FMClass: #AssertStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyAssertStatement >> addExpression: anObject [
	<generated>
	^ self expressions add: anObject
]

{ #category : 'accessing' }
FASTPyAssertStatement >> expressions [
	"Relation named: #expressions type: #FASTPyExpression opposite: #parentAssertStatement"

	<generated>
	<FMComment: 'The expressions asserted'>
	<derived>
	^ expressions
]

{ #category : 'accessing' }
FASTPyAssertStatement >> expressions: anObject [

	<generated>
	expressions value: anObject
]
