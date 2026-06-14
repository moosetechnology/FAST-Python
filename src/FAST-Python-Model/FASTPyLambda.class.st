"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `parentDeclarator` | `FASTPyTDecoratorExpression` | `expression` | `FASTPyDecorator` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyLambda` | `parentLambda` | `FASTPyExpression` | |
| `parameters` | `FASTTWithParameters` | `parameterOwner` | `FASTTVariableEntity` | My parameters|



"
Class {
	#name : 'FASTPyLambda',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTCallable + FASTPyTDecoratorExpression + FASTTWithParameters',
	#classTraits : 'FASTPyTCallable classTrait + FASTPyTDecoratorExpression classTrait + FASTTWithParameters classTrait',
	#instVars : [
		'#expression => FMOne type: #FASTPyExpression opposite: #parentLambda'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyLambda class >> annotation [

	<FMClass: #Lambda super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyLambda >> expression [
	"Relation named: #expression type: #FASTPyExpression opposite: #parentLambda"

	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyLambda >> expression: anObject [

	<generated>
	expression := anObject
]
