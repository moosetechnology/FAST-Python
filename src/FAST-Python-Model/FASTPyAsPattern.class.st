"
I represent the aliasing of an expression in Python. When the expression can only be an identifier, I store it as a property named ""alias"" instead of instantiating an AsPattern node.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentWithStatementItem` | `FASTPyTWithStatementItem` | `items` | `FASTPyWithStatement` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `source` | `FASTPyAsPattern` | `parentAsPatternSource` | `FASTPyTAsPatternSource` | |
| `target` | `FASTPyAsPattern` | `parentAsPatternTarget` | `FASTPyTAsPatternTarget` | |



"
Class {
	#name : 'FASTPyAsPattern',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTWithStatementItem',
	#classTraits : 'FASTPyTWithStatementItem classTrait',
	#instVars : [
		'#source => FMOne type: #FASTPyTAsPatternSource opposite: #parentAsPatternSource',
		'#target => FMOne type: #FASTPyTAsPatternTarget opposite: #parentAsPatternTarget'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAsPattern class >> annotation [

	<FMClass: #AsPattern super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyAsPattern >> source [
	"Relation named: #source type: #FASTPyTAsPatternSource opposite: #parentAsPatternSource"

	<generated>
	^ source
]

{ #category : 'accessing' }
FASTPyAsPattern >> source: anObject [

	<generated>
	source := anObject
]

{ #category : 'accessing' }
FASTPyAsPattern >> target [
	"Relation named: #target type: #FASTPyTAsPatternTarget opposite: #parentAsPatternTarget"

	<generated>
	^ target
]

{ #category : 'accessing' }
FASTPyAsPattern >> target: anObject [

	<generated>
	target := anObject
]
