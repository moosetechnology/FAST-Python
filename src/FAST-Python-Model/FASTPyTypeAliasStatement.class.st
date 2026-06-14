"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `left` | `FASTPyTypeAliasStatement` | `parentyTypeAliasStatementAlias` | `FASTPyType` | |
| `right` | `FASTPyTypeAliasStatement` | `parentyTypeAliasStatementType` | `FASTPyType` | |



"
Class {
	#name : 'FASTPyTypeAliasStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#left => FMOne type: #FASTPyType opposite: #parentyTypeAliasStatementAlias',
		'#right => FMOne type: #FASTPyType opposite: #parentyTypeAliasStatementType'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyTypeAliasStatement class >> annotation [

	<FMClass: #TypeAliasStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> left [
	"Relation named: #left type: #FASTPyType opposite: #parentyTypeAliasStatementAlias"

	<generated>
	^ left
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> left: anObject [

	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> right [
	"Relation named: #right type: #FASTPyType opposite: #parentyTypeAliasStatementType"

	<generated>
	^ right
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> right: anObject [

	<generated>
	right := anObject
]
