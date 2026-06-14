"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `argument` | `FASTPyTUnaryOperator` | `parentUnaryOperator` | `FASTPyExpression` | Expression influanced by the unary operator..|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `operator` | `String` | nil | |

"
Class {
	#name : 'FASTPyUnaryOperator',
	#superclass : 'FASTPyOperator',
	#traits : 'FASTPyTUnaryOperator',
	#classTraits : 'FASTPyTUnaryOperator classTrait',
	#instVars : [
		'#operator => FMProperty'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyUnaryOperator class >> annotation [

	<FMClass: #UnaryOperator super: #FASTPyOperator>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyUnaryOperator >> operator [

	<FMProperty: #operator type: #String>
	<generated>
	^ operator
]

{ #category : 'accessing' }
FASTPyUnaryOperator >> operator: anObject [
	<generated>
	operator := anObject
]
