"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAssignment` | `FASTPyType` | `type` | `FASTPyAssignment` | |
| `parentContrainedType` | `FASTPyType` | `type` | `FASTPyConstrainedType` | |
| `parentContrainedTypeBound` | `FASTPyType` | `bound` | `FASTPyConstrainedType` | |
| `parentFunctionDefinition` | `FASTPyType` | `returnType` | `FASTPyFunctionDefinition` | |
| `parentGenericTypeArgument` | `FASTPyType` | `arguments` | `FASTPyGenericType` | |
| `parentParameter` | `FASTPyType` | `type` | `FASTPyParameter` | |
| `parentUnionType` | `FASTPyType` | `types` | `FASTPyUnionType` | |
| `parentWithTypeParameters` | `FASTPyType` | `typeParameters` | `FASTPyTWithTypeParameters` | |
| `parentyTypeAliasStatementAlias` | `FASTPyType` | `left` | `FASTPyTypeAliasStatement` | |
| `parentyTypeAliasStatementType` | `FASTPyType` | `right` | `FASTPyTypeAliasStatement` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `content` | `FASTPyType` | `parentType` | `FASTPyTTypeContent` | |



"
Class {
	#name : 'FASTPyType',
	#superclass : 'FASTPyEntity',
	#instVars : [
		'#content => FMOne type: #FASTPyTTypeContent opposite: #parentType',
		'#parentAssignment => FMOne type: #FASTPyAssignment opposite: #type',
		'#parentContrainedType => FMOne type: #FASTPyConstrainedType opposite: #type',
		'#parentContrainedTypeBound => FMOne type: #FASTPyConstrainedType opposite: #bound',
		'#parentFunctionDefinition => FMOne type: #FASTPyFunctionDefinition opposite: #returnType',
		'#parentGenericTypeArgument => FMOne type: #FASTPyGenericType opposite: #arguments',
		'#parentParameter => FMOne type: #FASTPyParameter opposite: #type',
		'#parentUnionType => FMOne type: #FASTPyUnionType opposite: #types',
		'#parentWithTypeParameters => FMOne type: #FASTPyTWithTypeParameters opposite: #typeParameters',
		'#parentyTypeAliasStatementAlias => FMOne type: #FASTPyTypeAliasStatement opposite: #left',
		'#parentyTypeAliasStatementType => FMOne type: #FASTPyTypeAliasStatement opposite: #right'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyType class >> annotation [

	<FMClass: #Type super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyType >> content [
	"Relation named: #content type: #FASTPyTTypeContent opposite: #parentType"

	<generated>
	^ content
]

{ #category : 'accessing' }
FASTPyType >> content: anObject [

	<generated>
	content := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentAssignment [
	"Relation named: #parentAssignment type: #FASTPyAssignment opposite: #type"

	<generated>
	<container>
	<derived>
	^ parentAssignment
]

{ #category : 'accessing' }
FASTPyType >> parentAssignment: anObject [

	<generated>
	parentAssignment := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedType [
	"Relation named: #parentContrainedType type: #FASTPyConstrainedType opposite: #type"

	<generated>
	<container>
	<derived>
	^ parentContrainedType
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedType: anObject [

	<generated>
	parentContrainedType := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedTypeBound [
	"Relation named: #parentContrainedTypeBound type: #FASTPyConstrainedType opposite: #bound"

	<generated>
	<container>
	<derived>
	^ parentContrainedTypeBound
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedTypeBound: anObject [

	<generated>
	parentContrainedTypeBound := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentFunctionDefinition [
	"Relation named: #parentFunctionDefinition type: #FASTPyFunctionDefinition opposite: #returnType"

	<generated>
	<container>
	<derived>
	^ parentFunctionDefinition
]

{ #category : 'accessing' }
FASTPyType >> parentFunctionDefinition: anObject [

	<generated>
	parentFunctionDefinition := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentGenericTypeArgument [
	"Relation named: #parentGenericTypeArgument type: #FASTPyGenericType opposite: #arguments"

	<generated>
	<container>
	^ parentGenericTypeArgument
]

{ #category : 'accessing' }
FASTPyType >> parentGenericTypeArgument: anObject [

	<generated>
	parentGenericTypeArgument := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentParameter [
	"Relation named: #parentParameter type: #FASTPyParameter opposite: #type"

	<generated>
	<container>
	<derived>
	^ parentParameter
]

{ #category : 'accessing' }
FASTPyType >> parentParameter: anObject [

	<generated>
	parentParameter := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentUnionType [
	"Relation named: #parentUnionType type: #FASTPyUnionType opposite: #types"

	<generated>
	<container>
	^ parentUnionType
]

{ #category : 'accessing' }
FASTPyType >> parentUnionType: anObject [

	<generated>
	parentUnionType := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentWithTypeParameters [
	"Relation named: #parentWithTypeParameters type: #FASTPyTWithTypeParameters opposite: #typeParameters"

	<generated>
	<container>
	^ parentWithTypeParameters
]

{ #category : 'accessing' }
FASTPyType >> parentWithTypeParameters: anObject [

	<generated>
	parentWithTypeParameters := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementAlias [
	"Relation named: #parentyTypeAliasStatementAlias type: #FASTPyTypeAliasStatement opposite: #left"

	<generated>
	<container>
	<derived>
	^ parentyTypeAliasStatementAlias
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementAlias: anObject [

	<generated>
	parentyTypeAliasStatementAlias := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementType [
	"Relation named: #parentyTypeAliasStatementType type: #FASTPyTypeAliasStatement opposite: #right"

	<generated>
	<container>
	<derived>
	^ parentyTypeAliasStatementType
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementType: anObject [

	<generated>
	parentyTypeAliasStatementType := anObject
]
