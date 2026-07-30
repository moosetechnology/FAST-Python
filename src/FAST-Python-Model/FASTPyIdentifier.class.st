"
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


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyIdentifier',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTAsPatternTarget + FASTPyTReturnReferenceable + FASTPyTSplatParameterTarget + FASTTNamedEntity',
	#classTraits : 'FASTPyTAsPatternTarget classTrait + FASTPyTReturnReferenceable classTrait + FASTPyTSplatParameterTarget classTrait + FASTTNamedEntity classTrait',
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
FASTPyIdentifier >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment."

	| node |
	"In case I'm in a tuple, I should do the checks for the tuple instead of me."
	node := self.
	self collectionInitializer ifNotNil: [ :collection | collection isTuple ifTrue: [ node := collection ] ].

	node parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	node parentForStatementLeft ifNotNil: [ :for | ^ for ].

	node parentForInClauseLeft ifNotNil: [ :clause | ^ clause ].

	^ super variableDeclarator
]
