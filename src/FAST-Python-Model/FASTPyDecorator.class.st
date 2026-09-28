"
I represent a decorator in Python. I can be applied to class, function or method definition using the `@` symbol.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentDefinition` | `FASTPyDecorator` | `decorators` | `FASTPyTDefinition` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyDecorator` | `parentDeclarator` | `FASTPyTDecoratorExpression` | |



"
Class {
	#name : 'FASTPyDecorator',
	#superclass : 'FASTPyEntity',
	#instVars : [
		'#expression => FMOne type: #FASTPyTDecoratorExpression opposite: #parentDeclarator',
		'#parentDefinition => FMOne type: #FASTPyTDefinition opposite: #decorators'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyDecorator class >> annotation [

	<ignoreForCoverage>
	<FMClass: #Decorator super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyDecorator >> expression [
	"Relation named: #expression type: #FASTPyTDecoratorExpression opposite: #parentDeclarator"

	<ignoreForCoverage>
	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyDecorator >> expression: anObject [

	<ignoreForCoverage>
	<generated>
	expression := anObject
]

{ #category : 'accessing' }
FASTPyDecorator >> parentDefinition [
	"Relation named: #parentDefinition type: #FASTPyTDefinition opposite: #decorators"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentDefinition
]

{ #category : 'accessing' }
FASTPyDecorator >> parentDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	parentDefinition := anObject
]
