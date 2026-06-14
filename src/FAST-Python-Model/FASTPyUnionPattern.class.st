"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentCaseClause` | `FASTPyTPattern` | `pattern` | `FASTPyCaseClause` | |
| `parentKeywordPatternValue` | `FASTPyTPattern` | `value` | `FASTPyKeywordPattern` | |
| `parentUnionPattern` | `FASTPyTPattern` | `members` | `FASTPyUnionPattern` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `members` | `FASTPyUnionPattern` | `parentUnionPattern` | `FASTPyTPattern` | |



"
Class {
	#name : 'FASTPyUnionPattern',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTPattern',
	#classTraits : 'FASTPyTPattern classTrait',
	#instVars : [
		'#members => FMMany type: #FASTPyTPattern opposite: #parentUnionPattern'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyUnionPattern class >> annotation [

	<FMClass: #UnionPattern super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyUnionPattern >> addMember: anObject [
	<generated>
	^ self members add: anObject
]

{ #category : 'accessing' }
FASTPyUnionPattern >> members [
	"Relation named: #members type: #FASTPyTPattern opposite: #parentUnionPattern"

	<generated>
	<derived>
	^ members
]

{ #category : 'accessing' }
FASTPyUnionPattern >> members: anObject [

	<generated>
	members value: anObject
]
