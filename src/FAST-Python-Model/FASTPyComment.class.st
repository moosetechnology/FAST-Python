"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `container` | `FASTTComment` | `comments` | `FASTTWithComments` | Source code entity containing the comment|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `content` | `String` | nil | Content of the comment as a String|

"
Class {
	#name : 'FASTPyComment',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTComment',
	#classTraits : 'FASTTComment classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyComment class >> annotation [

	<FMClass: #Comment super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]
