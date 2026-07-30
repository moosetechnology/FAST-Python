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
| `parentSplatParameter` | `FASTPyTSplatParameterTarget` | `target` | `FASTPySplatParameter` | |



"
Class {
	#name : 'FASTPyIdentifier',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTAsPatternTarget + FASTPyTReturnReferenceable + FASTPyTSplatParameterTarget',
	#classTraits : 'FASTPyTAsPatternTarget classTrait + FASTPyTReturnReferenceable classTrait + FASTPyTSplatParameterTarget classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyIdentifier class >> annotation [

	<FMClass: #Identifier super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'testing' }
FASTPyIdentifier >> isVariableWriteAccess [
	"Checking my parents to know if I'm a variable been assigned."

	"If I'm the left side of an assignment then I'm an assigned variable."
	self parentAssignmentLeft ifNotNil: [ ^ true ].
	
	"Variable declared in a foreach."
	self parentForStatementLeft ifNotNil: [ ^ true ].

	^ super isVariableWriteAccess
]
