"
Lot of relations in python points to references. And some nodes can return lot of those references such as call, subscript, tuple, attribute. I am here to group those dependences.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |
| `parentAwait` | `FASTPyTAwaitable` | `expression` | `FASTPyAwait` | |
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |
| `parentDeclarator` | `FASTPyTDecoratorExpression` | `expression` | `FASTPyDecorator` | |
| `parentDeleteStatement` | `FASTPyTDeletable` | `expression` | `FASTPyDeleteStatement` | The delete statement that own the expression (if it's the case)|
| `parentExecStatement` | `FASTPyTExecutable` | `code` | `FASTPyExecStatement` | |
| `parentRaiseStatement` | `FASTPyTRaised` | `exception` | `FASTPyRaiseStatement` | |
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |



"
Trait {
	#name : 'FASTPyTReturnReferenceable',
	#traits : 'FASTPyTAsPatternSource + FASTPyTAssignable + FASTPyTAwaitable + FASTPyTCallable + FASTPyTDecoratorExpression + FASTPyTDeletable + FASTPyTExecutable + FASTPyTRaised + FASTPyTSplatExpression + FASTPyTSuperclass',
	#classTraits : 'FASTPyTAsPatternSource classTrait + FASTPyTAssignable classTrait + FASTPyTAwaitable classTrait + FASTPyTCallable classTrait + FASTPyTDecoratorExpression classTrait + FASTPyTDeletable classTrait + FASTPyTExecutable classTrait + FASTPyTRaised classTrait + FASTPyTSplatExpression classTrait + FASTPyTSuperclass classTrait',
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTReturnReferenceable classSide >> annotation [

	<FMClass: #TReturnReferenceable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]
