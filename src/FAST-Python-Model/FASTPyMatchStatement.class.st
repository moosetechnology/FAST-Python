"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `cases` | `FASTPyMatchStatement` | `parentMatchStatement` | `FASTPyCaseClause` | |
| `subject` | `FASTPyMatchStatement` | `parentMatchStatement` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyMatchStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#cases => FMMany type: #FASTPyCaseClause opposite: #parentMatchStatement',
		'#subject => FMOne type: #FASTPyExpression opposite: #parentMatchStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyMatchStatement class >> annotation [

	<FMClass: #MatchStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyMatchStatement >> addCase: anObject [
	<generated>
	^ self cases add: anObject
]

{ #category : 'accessing' }
FASTPyMatchStatement >> cases [
	"Relation named: #cases type: #FASTPyCaseClause opposite: #parentMatchStatement"

	<generated>
	<derived>
	^ cases
]

{ #category : 'accessing' }
FASTPyMatchStatement >> cases: anObject [

	<generated>
	cases value: anObject
]

{ #category : 'accessing' }
FASTPyMatchStatement >> subject [
	"Relation named: #subject type: #FASTPyExpression opposite: #parentMatchStatement"

	<generated>
	^ subject
]

{ #category : 'accessing' }
FASTPyMatchStatement >> subject: anObject [

	<generated>
	subject := anObject
]
