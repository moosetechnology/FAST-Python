"
My users are expressions that can define a superclass in a class declaration.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |



"
Trait {
	#name : 'FASTPyTSuperclass',
	#instVars : [
		'#parentClassDefinition => FMOne type: #FASTPyClassDefinition opposite: #superclasses'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTSuperclass classSide >> annotation [

	<FMClass: #TSuperclass super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTSuperclass >> parentClassDefinition [
	"Relation named: #parentClassDefinition type: #FASTPyClassDefinition opposite: #superclasses"

	<generated>
	<container>
	^ parentClassDefinition
]

{ #category : 'accessing' }
FASTPyTSuperclass >> parentClassDefinition: anObject [

	<generated>
	parentClassDefinition := anObject
]
