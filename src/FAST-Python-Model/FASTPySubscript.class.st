"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |
| `parentAsPatternTarget` | `FASTPyTAsPatternTarget` | `target` | `FASTPyAsPattern` | |
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |
| `parentAwait` | `FASTPyTAwaitable` | `expression` | `FASTPyAwait` | |
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |
| `parentDeclarator` | `FASTPyTDecoratorExpression` | `expression` | `FASTPyDecorator` | |
| `parentDeleteStatement` | `FASTPyTDeletable` | `expression` | `FASTPyDeleteStatement` | The delete statement that own the expression (if it's the case)|
| `parentExecStatement` | `FASTPyTExecutable` | `code` | `FASTPyExecStatement` | |
| `parentRaiseStatement` | `FASTPyTRaised` | `exception` | `FASTPyRaiseStatement` | |
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `indices` | `FASTPySubscript` | `parentSubscriptIndex` | `FASTPyTSliceIndex` | The elements defining the indices to select in a subscript.|
| `value` | `FASTPySubscript` | `parentSubscriptValue` | `FASTPyExpression` | The receiver of the subscript|



"
Class {
	#name : 'FASTPySubscript',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTAsPatternTarget + FASTPyTReturnReferenceable',
	#classTraits : 'FASTPyTAsPatternTarget classTrait + FASTPyTReturnReferenceable classTrait',
	#instVars : [
		'#indices => FMMany type: #FASTPyTSliceIndex opposite: #parentSubscriptIndex',
		'#value => FMOne type: #FASTPyExpression opposite: #parentSubscriptValue'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPySubscript class >> annotation [

	<FMClass: #Subscript super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPySubscript >> addIndex: anObject [
	<generated>
	^ self indices add: anObject
]

{ #category : 'accessing' }
FASTPySubscript >> indices [
	"Relation named: #indices type: #FASTPyTSliceIndex opposite: #parentSubscriptIndex"

	<generated>
	<FMComment: 'The elements defining the indices to select in a subscript.'>
	<derived>
	^ indices
]

{ #category : 'accessing' }
FASTPySubscript >> indices: anObject [

	<generated>
	indices value: anObject
]

{ #category : 'accessing' }
FASTPySubscript >> value [
	"Relation named: #value type: #FASTPyExpression opposite: #parentSubscriptValue"

	<generated>
	<FMComment: 'The receiver of the subscript'>
	^ value
]

{ #category : 'accessing' }
FASTPySubscript >> value: anObject [

	<generated>
	value := anObject
]
