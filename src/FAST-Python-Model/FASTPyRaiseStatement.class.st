"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `exception` | `FASTPyRaiseStatement` | `parentRaiseStatement` | `FASTPyTRaised` | |



"
Class {
	#name : 'FASTPyRaiseStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#exception => FMOne type: #FASTPyTRaised opposite: #parentRaiseStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyRaiseStatement class >> annotation [

	<FMClass: #RaiseStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyRaiseStatement >> exception [
	"Relation named: #exception type: #FASTPyTRaised opposite: #parentRaiseStatement"

	<generated>
	^ exception
]

{ #category : 'accessing' }
FASTPyRaiseStatement >> exception: anObject [

	<generated>
	exception := anObject
]
