"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `comments` | `FASTTWithComments` | `container` | `FASTTComment` | list of comments defined in the entity|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyEntity',
	#superclass : 'MooseEntity',
	#traits : 'FASTTEntity + FASTTWithComments',
	#classTraits : 'FASTTEntity classTrait + FASTTWithComments classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyEntity class >> annotation [

	<FMClass: #Entity super: #MooseEntity>
	<package: #'FAST-Python-Model'>
	<generated>
	<abstract>
]

{ #category : 'testing' }
FASTPyEntity class >> isAbstract [

	<generated>
	^ self == FASTPyEntity
]

{ #category : 'meta' }
FASTPyEntity class >> metamodel [

	<generated>
	^ FASTPyModel metamodel
]

{ #category : 'testing' }
FASTPyEntity >> hasImmediateSource [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isBinaryExpression [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isBooleanLiteral [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isClassDefinition [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isExpression [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isInvocation [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isLiteral [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isNumericalLiteral [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isReturnStatement [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isStatement [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isStatementBlock [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isStringLiteral [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isVariableEntity [

	<generated>
	^ false
]
