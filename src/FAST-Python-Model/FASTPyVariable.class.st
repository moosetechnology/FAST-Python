"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parameterOwner` | `FASTTVariableEntity` | `parameters` | `FASTTWithParameters` | parameterOwner|
| `parentAssignmentExpression` | `FASTTVariableEntity` | `variable` | `FASTTAssignment` | Optional assignment to the variable|
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |
| `parentGlobalStatement` | `FASTPyVariable` | `variables` | `FASTPyGlobalStatement` | The global statement defining my scope (if it's the case)|
| `parentNonlocalStatement` | `FASTPyVariable` | `variables` | `FASTPyNonlocalStatement` | The global statement defining my scope (if it's the case)|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyVariable',
	#superclass : 'FASTPyIdentifier',
	#traits : 'FASTPyTAssignable + FASTTVariableEntity',
	#classTraits : 'FASTPyTAssignable classTrait + FASTTVariableEntity classTrait',
	#instVars : [
		'#parentGlobalStatement => FMOne type: #FASTPyGlobalStatement opposite: #variables',
		'#parentNonlocalStatement => FMOne type: #FASTPyNonlocalStatement opposite: #variables'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyVariable class >> annotation [

	<FMClass: #Variable super: #FASTPyIdentifier>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyVariable >> parentGlobalStatement [
	"Relation named: #parentGlobalStatement type: #FASTPyGlobalStatement opposite: #variables"

	<generated>
	<FMComment: 'The global statement defining my scope (if it''s the case)'>
	<container>
	^ parentGlobalStatement
]

{ #category : 'accessing' }
FASTPyVariable >> parentGlobalStatement: anObject [

	<generated>
	parentGlobalStatement := anObject
]

{ #category : 'accessing' }
FASTPyVariable >> parentNonlocalStatement [
	"Relation named: #parentNonlocalStatement type: #FASTPyNonlocalStatement opposite: #variables"

	<generated>
	<FMComment: 'The global statement defining my scope (if it''s the case)'>
	<container>
	^ parentNonlocalStatement
]

{ #category : 'accessing' }
FASTPyVariable >> parentNonlocalStatement: anObject [

	<generated>
	parentNonlocalStatement := anObject
]
