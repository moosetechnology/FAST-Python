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

	<ignoreForCoverage>
	<FMClass: #TypeAliasStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> left [
	"Relation named: #left type: #FASTPyType opposite: #parentyTypeAliasStatementAlias"

	<ignoreForCoverage>
	<generated>
	^ left
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> left: anObject [

	<ignoreForCoverage>
	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> right [
	"Relation named: #right type: #FASTPyType opposite: #parentyTypeAliasStatementType"

	<ignoreForCoverage>
	<generated>
	^ right
]

{ #category : 'accessing' }
FASTPyTypeAliasStatement >> right: anObject [

	<ignoreForCoverage>
	<generated>
	right := anObject
]
