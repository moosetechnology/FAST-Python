"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parameterOwner` | `FASTTVariableEntity` | `parameters` | `FASTTWithParameters` | parameterOwner|
| `parentAssignmentExpression` | `FASTTVariableEntity` | `variable` | `FASTTAssignment` | Optional assignment to the variable|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `defaultValue` | `FASTPyParameter` | `parentDefaultParameterValue` | `FASTPyExpression` | |
| `type` | `FASTPyParameter` | `parentParameter` | `FASTPyType` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyParameter',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTTVariableEntity',
	#classTraits : 'FASTTVariableEntity classTrait',
	#instVars : [
		'#defaultValue => FMOne type: #FASTPyExpression opposite: #parentDefaultParameterValue',
		'#type => FMOne type: #FASTPyType opposite: #parentParameter'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyParameter class >> annotation [

	<FMClass: #Parameter super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyParameter >> defaultValue [
	"Relation named: #defaultValue type: #FASTPyExpression opposite: #parentDefaultParameterValue"

	<generated>
	^ defaultValue
]

{ #category : 'accessing' }
FASTPyParameter >> defaultValue: anObject [

	<generated>
	defaultValue := anObject
]

{ #category : 'testing' }
FASTPyParameter >> isSelf [

	<FMProperty>
	<derived>
	<comment: 'If true, I represent self in a method'>
	^ self parameterOwner
		  ifNil: [ false ]
		  ifNotNil: [ :parent | parent parameters first = self ]
]

{ #category : 'accessing' }
FASTPyParameter >> type [
	"Relation named: #type type: #FASTPyType opposite: #parentParameter"

	<generated>
	^ type
]

{ #category : 'accessing' }
FASTPyParameter >> type: anObject [

	<generated>
	type := anObject
]
