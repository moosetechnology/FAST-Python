"
A class pattern is used in a case clause to match classes.

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
| `elements` | `FASTPyClassPattern` | `parentClassPattern` | `FASTPyTClassPatternElement` | |



"
Class {
	#name : 'FASTPyClassPattern',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTPattern',
	#classTraits : 'FASTPyTPattern classTrait',
	#instVars : [
		'#elements => FMMany type: #FASTPyTClassPatternElement opposite: #parentClassPattern'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyClassPattern class >> annotation [

	<FMClass: #ClassPattern super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyClassPattern >> addElement: anObject [
	<generated>
	^ self elements add: anObject
]

{ #category : 'accessing' }
FASTPyClassPattern >> elements [
	"Relation named: #elements type: #FASTPyTClassPatternElement opposite: #parentClassPattern"

	<generated>
	<derived>
	^ elements
]

{ #category : 'accessing' }
FASTPyClassPattern >> elements: anObject [

	<generated>
	elements value: anObject
]
