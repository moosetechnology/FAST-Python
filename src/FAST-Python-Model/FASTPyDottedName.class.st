"
I have a syntax close to attribute accesses but I am used only in match statements.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentCaseClause` | `FASTPyTPattern` | `pattern` | `FASTPyCaseClause` | |
| `parentClassPattern` | `FASTPyTClassPatternElement` | `elements` | `FASTPyClassPattern` | |
| `parentKeywordPatternValue` | `FASTPyTPattern` | `value` | `FASTPyKeywordPattern` | |
| `parentUnionPattern` | `FASTPyTPattern` | `members` | `FASTPyUnionPattern` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `identifiers` | `String` | nil | The elements separated by a .|

"
Class {
	#name : 'FASTPyDottedName',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTClassPatternElement + FASTPyTPattern',
	#classTraits : 'FASTPyTClassPatternElement classTrait + FASTPyTPattern classTrait',
	#instVars : [
		'#identifiers => FMProperty'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyDottedName class >> annotation [

	<FMClass: #DottedName super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyDottedName >> identifiers [

	<FMProperty: #identifiers type: #String>
	<generated>
	<multivalued>
	<FMComment: 'The elements separated by a .'>
	^ identifiers
]

{ #category : 'accessing' }
FASTPyDottedName >> identifiers: anObject [
	<generated>
	identifiers := anObject
]
