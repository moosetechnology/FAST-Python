"
I am an abstract class for comprehensions. Comprehensions are a structure in python to generate some collections or a generator.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `body` | `FASTPyComprehension` | `parentComprehensionBody` | `FASTPyExpression` | |
| `conditions` | `FASTPyComprehension` | `parentComprehensionCondition` | `FASTPyExpression` | |
| `forClauses` | `FASTPyComprehension` | `parentComprehensionForClause` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyComprehension',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTSplatExpression',
	#classTraits : 'FASTPyTSplatExpression classTrait',
	#instVars : [
		'#body => FMOne type: #FASTPyExpression opposite: #parentComprehensionBody',
		'#conditions => FMMany type: #FASTPyExpression opposite: #parentComprehensionCondition',
		'#forClauses => FMMany type: #FASTPyExpression opposite: #parentComprehensionForClause'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyComprehension class >> annotation [

	<FMClass: #Comprehension super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
	<abstract>
]

{ #category : 'testing' }
FASTPyComprehension class >> isAbstract [

	<generated>
	^ self == FASTPyComprehension
]

{ #category : 'adding' }
FASTPyComprehension >> addCondition: anObject [
	<generated>
	^ self conditions add: anObject
]

{ #category : 'adding' }
FASTPyComprehension >> addForClause: anObject [
	<generated>
	^ self forClauses add: anObject
]

{ #category : 'accessing' }
FASTPyComprehension >> body [
	"Relation named: #body type: #FASTPyExpression opposite: #parentComprehensionBody"

	<generated>
	^ body
]

{ #category : 'accessing' }
FASTPyComprehension >> body: anObject [

	<generated>
	body := anObject
]

{ #category : 'accessing' }
FASTPyComprehension >> conditions [
	"Relation named: #conditions type: #FASTPyExpression opposite: #parentComprehensionCondition"

	<generated>
	<derived>
	^ conditions
]

{ #category : 'accessing' }
FASTPyComprehension >> conditions: anObject [

	<generated>
	conditions value: anObject
]

{ #category : 'accessing' }
FASTPyComprehension >> forClauses [
	"Relation named: #forClauses type: #FASTPyExpression opposite: #parentComprehensionForClause"

	<generated>
	<derived>
	^ forClauses
]

{ #category : 'accessing' }
FASTPyComprehension >> forClauses: anObject [

	<generated>
	forClauses value: anObject
]
