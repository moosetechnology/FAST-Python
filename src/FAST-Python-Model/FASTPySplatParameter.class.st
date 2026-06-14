"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `target` | `FASTPySplatParameter` | `parentSplatParameter` | `FASTPyTSplatParameterTarget` | |



"
Class {
	#name : 'FASTPySplatParameter',
	#superclass : 'FASTPyParameter',
	#instVars : [
		'#target => FMOne type: #FASTPyTSplatParameterTarget opposite: #parentSplatParameter'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPySplatParameter class >> annotation [

	<FMClass: #SplatParameter super: #FASTPyParameter>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPySplatParameter >> target [
	"Relation named: #target type: #FASTPyTSplatParameterTarget opposite: #parentSplatParameter"

	<generated>
	^ target
]

{ #category : 'accessing' }
FASTPySplatParameter >> target: anObject [

	<generated>
	target := anObject
]
