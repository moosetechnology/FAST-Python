"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `operands` | `FASTPyComparisonOperator` | `parentComparisonOperator` | `FASTPyExpression` | List of the operands of the comparison operands. For example if we have `a == b != c`, it will be a, b and c.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `operators` | `String` | nil | The comparators applied in order. Possible operators:  <, <=, ==, !=, >=, >, <>, in, not in, is, is not|

"
Class {
	#name : 'FASTPyComparisonOperator',
	#superclass : 'FASTPyOperator',
	#instVars : [
		'#operands => FMMany type: #FASTPyExpression opposite: #parentComparisonOperator',
		'#operators => FMProperty'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyComparisonOperator class >> annotation [

	<FMClass: #ComparisonOperator super: #FASTPyOperator>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyComparisonOperator >> addOperand: anObject [
	<generated>
	^ self operands add: anObject
]

{ #category : 'accessing' }
FASTPyComparisonOperator >> operands [
	"Relation named: #operands type: #FASTPyExpression opposite: #parentComparisonOperator"

	<generated>
	<FMComment: 'List of the operands of the comparison operands. For example if we have `a == b != c`, it will be a, b and c.'>
	<derived>
	^ operands
]

{ #category : 'accessing' }
FASTPyComparisonOperator >> operands: anObject [

	<generated>
	operands value: anObject
]

{ #category : 'accessing' }
FASTPyComparisonOperator >> operators [

	<FMProperty: #operators type: #String>
	<generated>
	<multivalued>
	<FMComment: 'The comparators applied in order. Possible operators:  <, <=, ==, !=, >=, >, <>, in, not in, is, is not'>
	^ operators
]

{ #category : 'accessing' }
FASTPyComparisonOperator >> operators: anObject [
	<generated>
	operators := anObject
]
