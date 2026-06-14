"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `fastBehaviouralParent` | `FASTTStatementBlock` | `statementBlock` | `FASTTWithStatements` | Behavioural entity containing the statement block.|
| `parentLoopStatement` | `FASTTStatement` | `body` | `FASTTLoopStatement` | Optional loop of which this statement is the body|
| `statementContainer` | `FASTTStatement` | `statements` | `FASTTStatementBlock` | Block containing this statement.|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `condition` | `FASTTWithCondition` | `parentConditional` | `FASTTExpression` | The boolean condition tested|
| `elseClause` | `FASTPyTWithElseClause` | `parentIfStatement` | `FASTPyElseClause` | |
| `statements` | `FASTTStatementBlock` | `statementContainer` | `FASTTStatement` | Statements enclosed in this block|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyWhileStatement',
	#superclass : 'FASTPyStatement',
	#traits : 'FASTPyTWithElseClause + FASTTConditionalStatement + FASTTStatementBlock',
	#classTraits : 'FASTPyTWithElseClause classTrait + FASTTConditionalStatement classTrait + FASTTStatementBlock classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyWhileStatement class >> annotation [

	<FMClass: #WhileStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]
