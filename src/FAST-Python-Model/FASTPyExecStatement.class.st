"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `code` | `FASTPyExecStatement` | `parentExecStatement` | `FASTPyTExecutable` | |
| `scopes` | `FASTPyExecStatement` | `parentExecStatementScopes` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyExecStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#code => FMOne type: #FASTPyTExecutable opposite: #parentExecStatement',
		'#scopes => FMMany type: #FASTPyExpression opposite: #parentExecStatementScopes'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyExecStatement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #ExecStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyExecStatement >> addScope: anObject [

	<ignoreForCoverage>
	<generated>
	^ self scopes add: anObject
]

{ #category : 'accessing' }
FASTPyExecStatement >> code [
	"Relation named: #code type: #FASTPyTExecutable opposite: #parentExecStatement"

	<ignoreForCoverage>
	<generated>
	^ code
]

{ #category : 'accessing' }
FASTPyExecStatement >> code: anObject [

	<ignoreForCoverage>
	<generated>
	code := anObject
]

{ #category : 'accessing' }
FASTPyExecStatement >> scopes [
	"Relation named: #scopes type: #FASTPyExpression opposite: #parentExecStatementScopes"

	<ignoreForCoverage>
	<generated>
	<derived>
	^ scopes
]

{ #category : 'accessing' }
FASTPyExecStatement >> scopes: anObject [

	<ignoreForCoverage>
	<generated>
	scopes value: anObject
]
