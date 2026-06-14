"
I represent the elements of a class pattern in python pattern matcher. The first element is the class name, the others the arguments.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentClassPattern` | `FASTPyTClassPatternElement` | `elements` | `FASTPyClassPattern` | |



"
Trait {
	#name : 'FASTPyTClassPatternElement',
	#instVars : [
		'#parentClassPattern => FMOne type: #FASTPyClassPattern opposite: #elements'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTClassPatternElement classSide >> annotation [

	<FMClass: #TClassPatternElement super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTClassPatternElement >> parentClassPattern [
	"Relation named: #parentClassPattern type: #FASTPyClassPattern opposite: #elements"

	<generated>
	<container>
	^ parentClassPattern
]

{ #category : 'accessing' }
FASTPyTClassPatternElement >> parentClassPattern: anObject [

	<generated>
	parentClassPattern := anObject
]
