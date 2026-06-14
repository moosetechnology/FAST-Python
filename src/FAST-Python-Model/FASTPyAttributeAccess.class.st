"
I represent an access to an attribute such as `module.globalVariable`.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
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
| `parentSplatParameter` | `FASTPyTSplatParameterTarget` | `target` | `FASTPySplatParameter` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `FASTPyAttributeAccess` | `parentAttributeObject` | `FASTPyExpression` | I am the receiver of the attribute. I can be multiple things such as a variable, a call, another attribute access, a primitive type, a subscript...|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyAttributeAccess',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTAsPatternTarget + FASTPyTReturnReferenceable + FASTPyTSplatParameterTarget + FASTTNamedEntity',
	#classTraits : 'FASTPyTAsPatternTarget classTrait + FASTPyTReturnReferenceable classTrait + FASTPyTSplatParameterTarget classTrait + FASTTNamedEntity classTrait',
	#instVars : [
		'#value => FMOne type: #FASTPyExpression opposite: #parentAttributeObject'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyAttributeAccess class >> annotation [

	<FMClass: #AttributeAccess super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyAttributeAccess >> value [
	"Relation named: #value type: #FASTPyExpression opposite: #parentAttributeObject"

	<generated>
	<FMComment: 'I am the receiver of the attribute. I can be multiple things such as a variable, a call, another attribute access, a primitive type, a subscript...'>
	^ value
]

{ #category : 'accessing' }
FASTPyAttributeAccess >> value: anObject [

	<generated>
	value := anObject
]
