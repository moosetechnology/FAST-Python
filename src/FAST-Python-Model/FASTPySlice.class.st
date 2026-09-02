"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentSubscriptIndex` | `FASTPyTSliceIndex` | `indices` | `FASTPySubscript` | My parent if I am defining an index to select of a subscript (if it's the case)|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `components` | `FASTPySlice` | `parentSlice` | `FASTPyExpression` | The components are the expressions between the `:` of a slice.|



"
Class {
	#name : 'FASTPySlice',
	#superclass : 'FASTPyEntity',
	#traits : 'FASTPyTSliceIndex',
	#classTraits : 'FASTPyTSliceIndex classTrait',
	#instVars : [
		'#components => FMMany type: #FASTPyExpression opposite: #parentSlice'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPySlice class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Slice super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPySlice >> addComponent: anObject [

	<ignoreForCoverage>
	<generated>
	^ self components add: anObject
]

{ #category : 'accessing' }
FASTPySlice >> components [
	"Relation named: #components type: #FASTPyExpression opposite: #parentSlice"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The components are the expressions between the `:` of a slice.'>
	<derived>
	^ components
]

{ #category : 'accessing' }
FASTPySlice >> components: anObject [

	<ignoreForCoverage>
	<generated>
	components value: anObject
]
