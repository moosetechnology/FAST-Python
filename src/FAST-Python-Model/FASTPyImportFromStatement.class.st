"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fromModule` | `FASTPyImportFromStatement` | `import` | `FASTPyFromModule` | Module in which the imported entities should be looked for. `from datetime import date` has `datetime` as fromModule..|



"
Class {
	#name : 'FASTPyImportFromStatement',
	#superclass : 'FASTPyImport',
	#instVars : [
		'#fromModule => FMOne type: #FASTPyFromModule opposite: #import'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyImportFromStatement class >> annotation [

	<FMClass: #ImportFromStatement super: #FASTPyImport>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyImportFromStatement >> fromModule [
	"Relation named: #fromModule type: #FASTPyFromModule opposite: #import"

	<generated>
	<FMComment: 'Module in which the imported entities should be looked for. `from datetime import date` has `datetime` as fromModule..'>
	^ fromModule
]

{ #category : 'accessing' }
FASTPyImportFromStatement >> fromModule: anObject [

	<generated>
	fromModule := anObject
]
