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
| `parentMethodDefinition` | `FASTPyType` | `returnType` | `FASTPyMethodDefinition` | |
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
		'#parentMethodDefinition => FMOne type: #FASTPyMethodDefinition opposite: #returnType',
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

	<ignoreForCoverage>
	<FMClass: #Type super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyType >> content [
	"Relation named: #content type: #FASTPyTTypeContent opposite: #parentType"

	<ignoreForCoverage>
	<generated>
	^ content
]

{ #category : 'accessing' }
FASTPyType >> content: anObject [

	<ignoreForCoverage>
	<generated>
	content := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentAssignment [
	"Relation named: #parentAssignment type: #FASTPyAssignment opposite: #type"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentAssignment
]

{ #category : 'accessing' }
FASTPyType >> parentAssignment: anObject [

	<ignoreForCoverage>
	<generated>
	parentAssignment := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedType [
	"Relation named: #parentContrainedType type: #FASTPyConstrainedType opposite: #type"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentContrainedType
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedType: anObject [

	<ignoreForCoverage>
	<generated>
	parentContrainedType := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedTypeBound [
	"Relation named: #parentContrainedTypeBound type: #FASTPyConstrainedType opposite: #bound"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentContrainedTypeBound
]

{ #category : 'accessing' }
FASTPyType >> parentContrainedTypeBound: anObject [

	<ignoreForCoverage>
	<generated>
	parentContrainedTypeBound := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentFunctionDefinition [
	"Relation named: #parentFunctionDefinition type: #FASTPyFunctionDefinition opposite: #returnType"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentFunctionDefinition
]

{ #category : 'accessing' }
FASTPyType >> parentFunctionDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	parentFunctionDefinition := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentGenericTypeArgument [
	"Relation named: #parentGenericTypeArgument type: #FASTPyGenericType opposite: #arguments"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentGenericTypeArgument
]

{ #category : 'accessing' }
FASTPyType >> parentGenericTypeArgument: anObject [

	<ignoreForCoverage>
	<generated>
	parentGenericTypeArgument := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentMethodDefinition [
	"Relation named: #parentMethodDefinition type: #FASTPyMethodDefinition opposite: #returnType"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentMethodDefinition
]

{ #category : 'accessing' }
FASTPyType >> parentMethodDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	parentMethodDefinition := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentParameter [
	"Relation named: #parentParameter type: #FASTPyParameter opposite: #type"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentParameter
]

{ #category : 'accessing' }
FASTPyType >> parentParameter: anObject [

	<ignoreForCoverage>
	<generated>
	parentParameter := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentUnionType [
	"Relation named: #parentUnionType type: #FASTPyUnionType opposite: #types"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentUnionType
]

{ #category : 'accessing' }
FASTPyType >> parentUnionType: anObject [

	<ignoreForCoverage>
	<generated>
	parentUnionType := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentWithTypeParameters [
	"Relation named: #parentWithTypeParameters type: #FASTPyTWithTypeParameters opposite: #typeParameters"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentWithTypeParameters
]

{ #category : 'accessing' }
FASTPyType >> parentWithTypeParameters: anObject [

	<ignoreForCoverage>
	<generated>
	parentWithTypeParameters := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementAlias [
	"Relation named: #parentyTypeAliasStatementAlias type: #FASTPyTypeAliasStatement opposite: #left"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentyTypeAliasStatementAlias
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementAlias: anObject [

	<ignoreForCoverage>
	<generated>
	parentyTypeAliasStatementAlias := anObject
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementType [
	"Relation named: #parentyTypeAliasStatementType type: #FASTPyTypeAliasStatement opposite: #right"

	<ignoreForCoverage>
	<generated>
	<container>
	<derived>
	^ parentyTypeAliasStatementType
]

{ #category : 'accessing' }
FASTPyType >> parentyTypeAliasStatementType: anObject [

	<ignoreForCoverage>
	<generated>
	parentyTypeAliasStatementType := anObject
]
