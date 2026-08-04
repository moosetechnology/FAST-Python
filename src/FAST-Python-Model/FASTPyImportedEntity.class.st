"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `import` | `FASTPyImportedEntity` | `importedEntities` | `FASTPyImport` | Import declaring me as imported entity.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `alias` | `String` | nil | If the imported entity has an alias, I contain it.|
| `segments` | `String` | nil | The segments of the imported entity. For example if you import `xml.etree.ElementTree`, the segments will be { 'xml' . 'etree' . 'ElementTree'}.|

"
Class {
	#name : 'FASTPyImportedEntity',
	#superclass : 'FASTPyEntity',
	#instVars : [
		'#segments => FMProperty',
		'#alias => FMProperty',
		'#import => FMOne type: #FASTPyImport opposite: #importedEntities'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyImportedEntity class >> annotation [

	<FMClass: #ImportedEntity super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyImportedEntity >> alias [

	<FMProperty: #alias type: #String>
	<generated>
	<FMComment: 'If the imported entity has an alias, I contain it.'>
	^ alias
]

{ #category : 'accessing' }
FASTPyImportedEntity >> alias: anObject [
	<generated>
	alias := anObject
]

{ #category : 'accessing' }
FASTPyImportedEntity >> import [
	"Relation named: #import type: #FASTPyImport opposite: #importedEntities"

	<generated>
	<FMComment: 'Import declaring me as imported entity.'>
	<container>
	^ import
]

{ #category : 'accessing' }
FASTPyImportedEntity >> import: anObject [

	<generated>
	import := anObject
]

{ #category : 'accessing' }
FASTPyImportedEntity >> segments [

	<FMProperty: #segments type: #String>
	<generated>
	<multivalued>
	<FMComment: 'The segments of the imported entity. For example if you import `xml.etree.ElementTree`, the segments will be { ''xml'' . ''etree'' . ''ElementTree''}.'>
	^ segments
]

{ #category : 'accessing' }
FASTPyImportedEntity >> segments: anObject [
	<generated>
	segments := anObject
]
