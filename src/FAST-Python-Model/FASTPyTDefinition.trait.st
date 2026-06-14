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
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `name` | `String` | nil | |
| `startPos` | `Number` | nil | |

"
Trait {
	#name : 'FASTPyTDefinition',
	#instVars : [
		'#decorators => FMMany type: #FASTPyDecorator opposite: #parentDefinition'
	],
	#traits : 'FASTTNamedEntity + FASTTStatementBlock',
	#classTraits : 'FASTTNamedEntity classTrait + FASTTStatementBlock classTrait',
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTDefinition classSide >> annotation [

	<FMClass: #TDefinition super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyTDefinition >> addDecorator: anObject [
	<generated>
	^ self decorators add: anObject
]

{ #category : 'accessing' }
FASTPyTDefinition >> decorators [
	"Relation named: #decorators type: #FASTPyDecorator opposite: #parentDefinition"

	<generated>
	<derived>
	^ decorators
]

{ #category : 'accessing' }
FASTPyTDefinition >> decorators: anObject [

	<generated>
	decorators value: anObject
]
