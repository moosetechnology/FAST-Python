"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `argument` | `FASTPyTUnaryOperator` | `parentUnaryOperator` | `FASTPyExpression` | Expression influanced by the unary operator..|



"
Trait {
	#name : 'FASTPyTUnaryOperator',
	#instVars : [
		'#argument => FMOne type: #FASTPyExpression opposite: #parentUnaryOperator'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTUnaryOperator classSide >> annotation [

	<FMClass: #TUnaryOperator super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTUnaryOperator >> argument [
	"Relation named: #argument type: #FASTPyExpression opposite: #parentUnaryOperator"

	<generated>
	<FMComment: 'Expression influanced by the unary operator..'>
	^ argument
]

{ #category : 'accessing' }
FASTPyTUnaryOperator >> argument: anObject [

	<generated>
	argument := anObject
]
