"
I represent a delete statement in Python.

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyDeleteStatement` | `parentDeleteStatement` | `FASTPyTDeletable` | The expression to apply the delete on|



"
Class {
	#name : 'FASTPyDeleteStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#expression => FMOne type: #FASTPyTDeletable opposite: #parentDeleteStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyDeleteStatement class >> annotation [

	<FMClass: #DeleteStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyDeleteStatement >> expression [
	"Relation named: #expression type: #FASTPyTDeletable opposite: #parentDeleteStatement"

	<generated>
	<FMComment: 'The expression to apply the delete on'>
	^ expression
]

{ #category : 'accessing' }
FASTPyDeleteStatement >> expression: anObject [

	<generated>
	expression := anObject
]
