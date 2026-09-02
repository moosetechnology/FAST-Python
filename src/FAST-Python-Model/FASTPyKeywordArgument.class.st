"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `invokedIn` | `FASTTNamedEntity` | `invoked` | `FASTTInvocation` | Optional invocation where this name is used|
| `parentClassDefinition` | `FASTPyKeywordArgument` | `keywords` | `FASTPyClassDefinition` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `value` | `FASTPyKeywordArgument` | `parentKeywordArgument` | `FASTPyExpression` | The value of the keyword argument.|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyKeywordArgument',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTTNamedEntity',
	#classTraits : 'FASTTNamedEntity classTrait',
	#instVars : [
		'#parentClassDefinition => FMOne type: #FASTPyClassDefinition opposite: #keywords',
		'#value => FMOne type: #FASTPyExpression opposite: #parentKeywordArgument'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyKeywordArgument class >> annotation [

	<ignoreForCoverage>
	<FMClass: #KeywordArgument super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyKeywordArgument >> parentClassDefinition [
	"Relation named: #parentClassDefinition type: #FASTPyClassDefinition opposite: #keywords"

	<ignoreForCoverage>
	<generated>
	<container>
	^ parentClassDefinition
]

{ #category : 'accessing' }
FASTPyKeywordArgument >> parentClassDefinition: anObject [

	<ignoreForCoverage>
	<generated>
	parentClassDefinition := anObject
]

{ #category : 'accessing' }
FASTPyKeywordArgument >> value [
	"Relation named: #value type: #FASTPyExpression opposite: #parentKeywordArgument"

	<ignoreForCoverage>
	<generated>
	<FMComment: 'The value of the keyword argument.'>
	^ value
]

{ #category : 'accessing' }
FASTPyKeywordArgument >> value: anObject [

	<ignoreForCoverage>
	<generated>
	value := anObject
]
