"
I represent a break statement used to break loops.

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
	#name : 'FASTPyBreakStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTTBreakStatement',
	#classTraits : 'FASTTBreakStatement classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyBreakStatement class >> annotation [

	<FMClass: #BreakStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]
