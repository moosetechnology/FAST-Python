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
| `returnType` | `FASTPyFunctionDefinition` | `parentFunctionDefinition` | `FASTPyType` | |
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
	#name : 'FASTPyFunctionDefinition',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTDefinition + FASTPyTWithTypeParameters + FASTTWithParameters',
	#classTraits : 'FASTPyTDefinition classTrait + FASTPyTWithTypeParameters classTrait + FASTTWithParameters classTrait',
	#instVars : [
		'#returnType => FMOne type: #FASTPyType opposite: #parentFunctionDefinition'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyFunctionDefinition class >> annotation [

	<FMClass: #FunctionDefinition super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'testing' }
FASTPyFunctionDefinition >> isAsync [

	<FMProperty>
	<comment: 'If true, I am an async function definition'>
	<derived>
	^ self cacheAt: #isAsync ifAbsentPut: [ self sourceCode beginsWith: 'async' ]
]

{ #category : 'accessing' }
FASTPyFunctionDefinition >> returnType [
	"Relation named: #returnType type: #FASTPyType opposite: #parentFunctionDefinition"

	<generated>
	^ returnType
]

{ #category : 'accessing' }
FASTPyFunctionDefinition >> returnType: anObject [

	<generated>
	returnType := anObject
]
