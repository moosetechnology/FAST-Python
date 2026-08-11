"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `decorators` | `FASTPyTDefinition` | `parentDefinition` | `FASTPyDecorator` | |
| `parameters` | `FASTTWithParameters` | `parameterOwner` | `FASTTVariableEntity` | My parameters|
| `returnType` | `FASTPyMethodDefinition` | `parentMethodDefinition` | `FASTPyType` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|
| `typeParameters` | `FASTPyTWithTypeParameters` | `parentWithTypeParameters` | `FASTPyType` | |


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyMethodDefinition',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTDefinition + FASTPyTWithTypeParameters + FASTTWithParameters',
	#classTraits : 'FASTPyTDefinition classTrait + FASTPyTWithTypeParameters classTrait + FASTTWithParameters classTrait',
	#instVars : [
		'#returnType => FMOne type: #FASTPyType opposite: #parentMethodDefinition'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyMethodDefinition class >> annotation [

	<FMClass: #MethodDefinition super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'testing' }
FASTPyMethodDefinition >> isAbstract [
	"A method is static in python if it has the `@staticmethod` decorator."

	^ self decorators anySatisfy: [ :decorator | decorator expression isIdentifier and: [ decorator expression name = 'abstractmethod' ] ]
]

{ #category : 'testing' }
FASTPyMethodDefinition >> isStatic [
	"A method is static in python if it has the `@staticmethod` decorator."

	^ self decorators anySatisfy: [ :decorator | decorator expression isIdentifier and: [ decorator expression name = 'staticmethod' ] ]
]

{ #category : 'accessing' }
FASTPyMethodDefinition >> returnType [
	"Relation named: #returnType type: #FASTPyType opposite: #parentMethodDefinition"

	<generated>
	^ returnType
]

{ #category : 'accessing' }
FASTPyMethodDefinition >> returnType: anObject [

	<generated>
	returnType := anObject
]

{ #category : 'accessing' }
FASTPyMethodDefinition >> selfName [
	"Return the name of the parameter corresponding to 'self'. In case of a static method, returns nil since there is none."

	self isStatic ifTrue: [ ^ nil ].

	^ self parameters first name
]
