"
An augmented assignment is an assignment done using operands such as `+=` or `-=`. It is a specialization of normal assignments.

## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `operator` | `String` | nil | |

"
Class {
	#name : 'FASTPyAugmentedAssignment',
	#superclass : 'FASTPyAssignment',
	#instVars : [
		'#operator => FMProperty'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAugmentedAssignment class >> annotation [

	<FMClass: #AugmentedAssignment super: #FASTPyAssignment>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyAugmentedAssignment >> operator [

	<FMProperty: #operator type: #String>
	<generated>
	^ operator
]

{ #category : 'accessing' }
FASTPyAugmentedAssignment >> operator: anObject [
	<generated>
	operator := anObject
]
