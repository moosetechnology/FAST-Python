"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPySplatType',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTTypeContent + FASTTNamedEntity',
	#classTraits : 'FASTPyTTypeContent classTrait + FASTTNamedEntity classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPySplatType class >> annotation [

	<FMClass: #SplatType super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]
