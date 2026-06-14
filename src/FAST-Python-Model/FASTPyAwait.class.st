"
I represent the usage of an await keyword in an asynchronous function definition

## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyAwait` | `parentAwait` | `FASTPyTAwaitable` | |



"
Class {
	#name : 'FASTPyAwait',
	#superclass : 'FASTPyExpression',
	#instVars : [
		'#expression => FMOne type: #FASTPyTAwaitable opposite: #parentAwait'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAwait class >> annotation [

	<FMClass: #Await super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyAwait >> expression [
	"Relation named: #expression type: #FASTPyTAwaitable opposite: #parentAwait"

	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyAwait >> expression: anObject [

	<generated>
	expression := anObject
]
