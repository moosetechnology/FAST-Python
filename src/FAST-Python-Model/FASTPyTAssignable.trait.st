"
I represent something that can be assigned in an assignment

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |



"
Trait {
	#name : 'FASTPyTAssignable',
	#instVars : [
		'#parentAssignmentLeft => FMOne type: #FASTPyAssignment opposite: #left'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTAssignable classSide >> annotation [

	<FMClass: #TAssignable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTAssignable >> parentAssignmentLeft [
	"Relation named: #parentAssignmentLeft type: #FASTPyAssignment opposite: #left"

	<generated>
	<container>
	<derived>
	^ parentAssignmentLeft
]

{ #category : 'accessing' }
FASTPyTAssignable >> parentAssignmentLeft: anObject [

	<generated>
	parentAssignmentLeft := anObject
]
