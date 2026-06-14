"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyStatement',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTStatement',
	#classTraits : 'FASTTStatement classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyStatement class >> annotation [

	<FMClass: #Statement super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
	<abstract>
]

{ #category : 'testing' }
FASTPyStatement class >> isAbstract [

	<generated>
	^ self == FASTPyStatement
]
