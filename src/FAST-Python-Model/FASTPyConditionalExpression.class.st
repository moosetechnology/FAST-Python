"
I represent a conditional expression such as `x if x > 2 else y`

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |
| `parentExecStatement` | `FASTPyTExecutable` | `code` | `FASTPyExecStatement` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|
| `elseExpression` | `FASTPyConditionalExpression` | `parentConditionalExpressionElse` | `FASTPyExpression` | |
| `thenExpression` | `FASTPyConditionalExpression` | `parentConditionalExpressionThen` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyConditionalExpression',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTCallable + FASTPyTExecutable + FASTPyTSuperclass + FASTTWithCondition',
	#classTraits : 'FASTPyTCallable classTrait + FASTPyTExecutable classTrait + FASTPyTSuperclass classTrait + FASTTWithCondition classTrait',
	#instVars : [
		'#elseExpression => FMOne type: #FASTPyExpression opposite: #parentConditionalExpressionElse',
		'#thenExpression => FMOne type: #FASTPyExpression opposite: #parentConditionalExpressionThen'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyConditionalExpression class >> annotation [

	<FMClass: #ConditionalExpression super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyConditionalExpression >> elseExpression [
	"Relation named: #elseExpression type: #FASTPyExpression opposite: #parentConditionalExpressionElse"

	<generated>
	^ elseExpression
]

{ #category : 'accessing' }
FASTPyConditionalExpression >> elseExpression: anObject [

	<generated>
	elseExpression := anObject
]

{ #category : 'accessing' }
FASTPyConditionalExpression >> thenExpression [
	"Relation named: #thenExpression type: #FASTPyExpression opposite: #parentConditionalExpressionThen"

	<generated>
	^ thenExpression
]

{ #category : 'accessing' }
FASTPyConditionalExpression >> thenExpression: anObject [

	<generated>
	thenExpression := anObject
]
