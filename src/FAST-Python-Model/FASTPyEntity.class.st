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

{ #category : 'accessing' }
FASTPyEntity >> assignedExpressions [

	^ Array empty
]

{ #category : 'accessing' }
FASTPyEntity >> callOnMe [
	"Return, if it exists, a call done on me.
	
	I am used for #callsOnVariable. 
	
	I'll return the call in those cases (I am x)
	
	x.y()
	x()
	x[0]()
	
	I know this is not 'really' the receiver in all 3 cases, but this is what is wanted for the project using #callsOnVariable. Maybe I should be renamed to show that I am private?"

	^ nil
]

{ #category : 'testing' }
FASTPyEntity >> hasImmediateSource [

	<generated>
	^ false
]

{ #category : 'accessing' }
FASTPyEntity >> internalAccess [
	"If I am a variable, return a potential internal access done on me.
	It can be of two kinds:
		- subscript `x[3]`
		- attribute `x.y`
		
	I am mostly used after a local resolution to find all internal accesses to a variable. Check #internalAccesses"

	^ nil
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
FASTPyEntity >> isBreakStatement [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isClassDefinition [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isContinueStatement [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isExpression [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isIdentifier [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isInstanceVariableAccess [

	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isInvocation [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isList [

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
FASTPyEntity >> isTuple [

	<generated>
	^ false
]

{ #category : 'testing' }
FASTPyEntity >> isVariableEntity [

	<generated>
	^ false
]

{ #category : 'accessing' }
FASTPyEntity >> shadowedBy [

	<FMProperty: #shadowedBy type: #FASTPyEntity opposite: #shadowing>
	<FMComment:
	'Return the entity shadowing me, if it exists. Else, return nil. An entity is shadowed went a named entity of a different kind is defined after me with the same name. Be careful, this works only if the local resolution was done and it works only on the local declaration.'>
	^ self attributeAt: #shadowedBy ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FASTPyEntity >> shadowedBy: aFASTEntity [

	| otherSide |
	otherSide := self shadowedBy.

	otherSide == aFASTEntity ifTrue: [ ^ aFASTEntity ].

	aFASTEntity
		ifNil: [
				self attributeAt: #shadowedBy put: aFASTEntity.
				otherSide shadowing: nil ]
		ifNotNil: [
				self attributeAt: #shadowedBy put: aFASTEntity.
				aFASTEntity shadowing: self ]
]

{ #category : 'accessing' }
FASTPyEntity >> shadowing [

	<FMProperty: #shadowing type: #FASTPyEntity opposite: #shadowedBy>
	<FMComment:
	'Return the entity I possibly shadow. Else, return nil. An entity is shadowed went a named entity of a different kind is defined after me with the same name. Be careful, this works only if the local resolution was done and it works only on the local declaration.'>
	^ self attributeAt: #shadowing ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FASTPyEntity >> shadowing: aFASTEntity [

	| otherSide |
	otherSide := self shadowing.

	otherSide == aFASTEntity ifTrue: [ ^ aFASTEntity ].

	aFASTEntity
		ifNil: [
				self attributeAt: #shadowing put: aFASTEntity.
				otherSide shadowedBy: nil ]
		ifNotNil: [
				self attributeAt: #shadowing put: aFASTEntity.
				aFASTEntity shadowedBy: self ]
]

{ #category : 'accessing' }
FASTPyEntity >> variableDeclarator [
	"In case I am a write access to a variable, I return the node categorized as my declaration. Else I return nil.
	Nodes representing potential variable write access should override me.
	
	I am used by the LocalResolver and potentially SSA"

	^ nil
]
