"
I represent an assignment in Python (not to confuse with an augmented assignment or a wlrus assignment). My left value is the expression used to get the variable to assign. It can be typed optionally. My right side if the expression to store. It can be optional because I also represent a typed variable declaration.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `left` | `FASTPyAssignment` | `parentAssignmentLeft` | `FASTPyTAssignable` | |
| `right` | `FASTPyAssignment` | `parentAssignmentRight` | `FASTPyExpression` | |
| `type` | `FASTPyAssignment` | `parentAssignment` | `FASTPyType` | |



"
Class {
	#name : 'FASTPyAssignment',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTAssignable',
	#classTraits : 'FASTPyTAssignable classTrait',
	#instVars : [
		'#left => FMOne type: #FASTPyTAssignable opposite: #parentAssignmentLeft',
		'#right => FMOne type: #FASTPyExpression opposite: #parentAssignmentRight',
		'#type => FMOne type: #FASTPyType opposite: #parentAssignment'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAssignment class >> annotation [

	<FMClass: #Assignment super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'testing' }
FASTPyAssignment >> isDeclaration [

	<FMProperty>
	<derived>
	<comment: 'An assignment is a simple declaration if it has no right expression.'>
	^ self right isNil
]

{ #category : 'accessing' }
FASTPyAssignment >> left [
	"Relation named: #left type: #FASTPyTAssignable opposite: #parentAssignmentLeft"

	<generated>
	^ left
]

{ #category : 'accessing' }
FASTPyAssignment >> left: anObject [

	<generated>
	left := anObject
]

{ #category : 'accessing' }
FASTPyAssignment >> right [
	"Relation named: #right type: #FASTPyExpression opposite: #parentAssignmentRight"

	<generated>
	^ right
]

{ #category : 'accessing' }
FASTPyAssignment >> right: anObject [

	<generated>
	right := anObject
]

{ #category : 'accessing' }
FASTPyAssignment >> type [
	"Relation named: #type type: #FASTPyType opposite: #parentAssignment"

	<generated>
	^ type
]

{ #category : 'accessing' }
FASTPyAssignment >> type: anObject [

	<generated>
	type := anObject
]
