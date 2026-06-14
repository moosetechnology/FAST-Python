"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `arguments` | `FASTPyGenericType` | `parentGenericTypeArgument` | `FASTPyType` | |
| `typeParameters` | `FASTPyTWithTypeParameters` | `parentWithTypeParameters` | `FASTPyType` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyGenericType',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTTypeContent + FASTPyTWithTypeParameters + FASTTNamedEntity',
	#classTraits : 'FASTPyTTypeContent classTrait + FASTPyTWithTypeParameters classTrait + FASTTNamedEntity classTrait',
	#instVars : [
		'#arguments => FMMany type: #FASTPyType opposite: #parentGenericTypeArgument'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyGenericType class >> annotation [

	<FMClass: #GenericType super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyGenericType >> addArgument: anObject [
	<generated>
	^ self arguments add: anObject
]

{ #category : 'accessing' }
FASTPyGenericType >> arguments [
	"Relation named: #arguments type: #FASTPyType opposite: #parentGenericTypeArgument"

	<generated>
	<derived>
	^ arguments
]

{ #category : 'accessing' }
FASTPyGenericType >> arguments: anObject [

	<generated>
	arguments value: anObject
]
