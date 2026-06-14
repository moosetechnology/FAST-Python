"
I represent the concretization of a generic type in a given context. For example: `def f[T: int](): pass`, we are here constraining `T` to be an `int` or a subclass of `int`

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `bound` | `FASTPyConstrainedType` | `parentContrainedTypeBound` | `FASTPyType` | |
| `type` | `FASTPyConstrainedType` | `parentContrainedType` | `FASTPyType` | |



"
Class {
	#name : 'FASTPyConstrainedType',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTTypeContent',
	#classTraits : 'FASTPyTTypeContent classTrait',
	#instVars : [
		'#bound => FMOne type: #FASTPyType opposite: #parentContrainedTypeBound',
		'#type => FMOne type: #FASTPyType opposite: #parentContrainedType'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyConstrainedType class >> annotation [

	<FMClass: #ConstrainedType super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyConstrainedType >> bound [
	"Relation named: #bound type: #FASTPyType opposite: #parentContrainedTypeBound"

	<generated>
	^ bound
]

{ #category : 'accessing' }
FASTPyConstrainedType >> bound: anObject [

	<generated>
	bound := anObject
]

{ #category : 'accessing' }
FASTPyConstrainedType >> type [
	"Relation named: #type type: #FASTPyType opposite: #parentContrainedType"

	<generated>
	^ type
]

{ #category : 'accessing' }
FASTPyConstrainedType >> type: anObject [

	<generated>
	type := anObject
]
