"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentType` | `FASTPyTTypeContent` | `content` | `FASTPyType` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `types` | `FASTPyUnionType` | `parentUnionType` | `FASTPyType` | |



"
Class {
	#name : 'FASTPyUnionType',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTTypeContent',
	#classTraits : 'FASTPyTTypeContent classTrait',
	#instVars : [
		'#types => FMMany type: #FASTPyType opposite: #parentUnionType'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyUnionType class >> annotation [

	<ignoreForCoverage>
	<FMClass: #UnionType super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyUnionType >> addType: anObject [

	<ignoreForCoverage>
	<generated>
	^ self types add: anObject
]

{ #category : 'accessing' }
FASTPyUnionType >> types [
	"Relation named: #types type: #FASTPyType opposite: #parentUnionType"

	<ignoreForCoverage>
	<generated>
	<derived>
	^ types
]

{ #category : 'accessing' }
FASTPyUnionType >> types: anObject [

	<ignoreForCoverage>
	<generated>
	types value: anObject
]
