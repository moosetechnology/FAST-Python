"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `FASTPyWalrus` | `parentWalrus` | `FASTPyExpression` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyWalrus',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTTNamedEntity',
	#classTraits : 'FASTTNamedEntity classTrait',
	#instVars : [
		'#value => FMOne type: #FASTPyExpression opposite: #parentWalrus'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyWalrus class >> annotation [

	<FMClass: #Walrus super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyWalrus >> value [
	"Relation named: #value type: #FASTPyExpression opposite: #parentWalrus"

	<generated>
	^ value
]

{ #category : 'accessing' }
FASTPyWalrus >> value: anObject [

	<generated>
	value := anObject
]
