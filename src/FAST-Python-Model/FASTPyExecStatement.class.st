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

	<FMClass: #ExecStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyExecStatement >> addScope: anObject [
	<generated>
	^ self scopes add: anObject
]

{ #category : 'accessing' }
FASTPyExecStatement >> code [
	"Relation named: #code type: #FASTPyTExecutable opposite: #parentExecStatement"

	<generated>
	^ code
]

{ #category : 'accessing' }
FASTPyExecStatement >> code: anObject [

	<generated>
	code := anObject
]

{ #category : 'accessing' }
FASTPyExecStatement >> scopes [
	"Relation named: #scopes type: #FASTPyExpression opposite: #parentExecStatementScopes"

	<generated>
	<derived>
	^ scopes
]

{ #category : 'accessing' }
FASTPyExecStatement >> scopes: anObject [

	<generated>
	scopes value: anObject
]
