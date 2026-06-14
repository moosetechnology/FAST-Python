"
I represent an entity that *can* be the expression of a decorator.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentDeclarator` | `FASTPyTDecoratorExpression` | `expression` | `FASTPyDecorator` | |



"
Trait {
	#name : 'FASTPyTDecoratorExpression',
	#instVars : [
		'#parentDeclarator => FMOne type: #FASTPyDecorator opposite: #expression'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTDecoratorExpression classSide >> annotation [

	<FMClass: #TDecoratorExpression super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTDecoratorExpression >> parentDeclarator [
	"Relation named: #parentDeclarator type: #FASTPyDecorator opposite: #expression"

	<generated>
	<container>
	<derived>
	^ parentDeclarator
]

{ #category : 'accessing' }
FASTPyTDecoratorExpression >> parentDeclarator: anObject [

	<generated>
	parentDeclarator := anObject
]
