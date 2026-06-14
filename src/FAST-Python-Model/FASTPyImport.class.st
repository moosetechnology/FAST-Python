"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `importedEntities` | `FASTPyImport` | `import` | `FASTPyImportedEntity` | List of the imported entities.|



"
Class {
	#name : 'FASTPyImport',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#importedEntities => FMMany type: #FASTPyImportedEntity opposite: #import'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyImport class >> annotation [

	<FMClass: #Import super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyImport >> addImportedEntity: anObject [
	<generated>
	^ self importedEntities add: anObject
]

{ #category : 'accessing' }
FASTPyImport >> importedEntities [
	"Relation named: #importedEntities type: #FASTPyImportedEntity opposite: #import"

	<generated>
	<FMComment: 'List of the imported entities.'>
	<derived>
	^ importedEntities
]

{ #category : 'accessing' }
FASTPyImport >> importedEntities: anObject [

	<generated>
	importedEntities value: anObject
]
