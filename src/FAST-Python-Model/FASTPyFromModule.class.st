"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `import` | `FASTPyFromModule` | `fromModule` | `FASTPyImportFromStatement` | Import declaring me as from import module.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `segments` | `String` | nil | The segments of the module path. For example if you declare `xml.etree.ElementTree` as module, the segments will be { 'xml' . 'etree' . 'ElementTree'}.|

"
Class {
	#name : 'FASTPyFromModule',
	#superclass : 'FASTPyEntity',
	#instVars : [
		'#segments => FMProperty',
		'#import => FMOne type: #FASTPyImportFromStatement opposite: #fromModule'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyFromModule class >> annotation [

	<FMClass: #FromModule super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyFromModule >> addSegments: aCollection [

	segments := segments , aCollection
]

{ #category : 'accessing' }
FASTPyFromModule >> import [
	"Relation named: #import type: #FASTPyImportFromStatement opposite: #fromModule"

	<generated>
	<FMComment: 'Import declaring me as from import module.'>
	<container>
	<derived>
	^ import
]

{ #category : 'accessing' }
FASTPyFromModule >> import: anObject [

	<generated>
	import := anObject
]

{ #category : 'accessing' }
FASTPyFromModule >> segments [

	<FMProperty: #segments type: #String>
	<generated>
	<multivalued>
	<FMComment: 'The segments of the module path. For example if you declare `xml.etree.ElementTree` as module, the segments will be { ''xml'' . ''etree'' . ''ElementTree''}.'>
	^ segments
]

{ #category : 'accessing' }
FASTPyFromModule >> segments: anObject [
	<generated>
	segments := anObject
]
