"
I represent a class definition. I have a name, a list of expressions to declare my superclasses, a list of keywords to customize the metaclass and a block of code.

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
| `keywords` | `FASTPyClassDefinition` | `parentClassDefinition` | `FASTPyKeywordArgument` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|
| `superclasses` | `FASTPyClassDefinition` | `parentClassDefinition` | `FASTPyTSuperclass` | |
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
	#name : 'FASTPyClassDefinition',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTDefinition + FASTPyTWithTypeParameters',
	#classTraits : 'FASTPyTDefinition classTrait + FASTPyTWithTypeParameters classTrait',
	#instVars : [
		'#keywords => FMMany type: #FASTPyKeywordArgument opposite: #parentClassDefinition',
		'#superclasses => FMMany type: #FASTPyTSuperclass opposite: #parentClassDefinition'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyClassDefinition class >> annotation [

	<FMClass: #ClassDefinition super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyClassDefinition >> addKeyword: anObject [
	<generated>
	^ self keywords add: anObject
]

{ #category : 'adding' }
FASTPyClassDefinition >> addSuperclass: anObject [
	<generated>
	^ self superclasses add: anObject
]

{ #category : 'testing' }
FASTPyClassDefinition >> isClassDefinition [

	<generated>
	^ true
]

{ #category : 'accessing' }
FASTPyClassDefinition >> keywords [
	"Relation named: #keywords type: #FASTPyKeywordArgument opposite: #parentClassDefinition"

	<generated>
	<derived>
	^ keywords
]

{ #category : 'accessing' }
FASTPyClassDefinition >> keywords: anObject [

	<generated>
	keywords value: anObject
]

{ #category : 'accessing' }
FASTPyClassDefinition >> superclasses [
	"Relation named: #superclasses type: #FASTPyTSuperclass opposite: #parentClassDefinition"

	<generated>
	<derived>
	^ superclasses
]

{ #category : 'accessing' }
FASTPyClassDefinition >> superclasses: anObject [

	<generated>
	superclasses value: anObject
]
