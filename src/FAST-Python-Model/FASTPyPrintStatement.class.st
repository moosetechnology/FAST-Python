"
## Relations
======================

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expressions` | `FASTPyPrintStatement` | `prarentPrintStatement` | `FASTPyExpression` | |
| `redirection` | `FASTPyPrintStatement` | `parentPrintStatement` | `FASTPyChevron` | |



"
Class {
	#name : 'FASTPyPrintStatement',
	#superclass : 'FASTPyStatement',
	#instVars : [
		'#expressions => FMMany type: #FASTPyExpression opposite: #prarentPrintStatement',
		'#redirection => FMOne type: #FASTPyChevron opposite: #parentPrintStatement'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyPrintStatement class >> annotation [

	<ignoreForCoverage>
	<FMClass: #PrintStatement super: #FASTPyStatement>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'adding' }
FASTPyPrintStatement >> addExpression: anObject [

	<ignoreForCoverage>
	<generated>
	^ self expressions add: anObject
]

{ #category : 'accessing' }
FASTPyPrintStatement >> expressions [
	"Relation named: #expressions type: #FASTPyExpression opposite: #prarentPrintStatement"

	<ignoreForCoverage>
	<generated>
	<derived>
	^ expressions
]

{ #category : 'accessing' }
FASTPyPrintStatement >> expressions: anObject [

	<ignoreForCoverage>
	<generated>
	expressions value: anObject
]

{ #category : 'accessing' }
FASTPyPrintStatement >> redirection [
	"Relation named: #redirection type: #FASTPyChevron opposite: #parentPrintStatement"

	<ignoreForCoverage>
	<generated>
	^ redirection
]

{ #category : 'accessing' }
FASTPyPrintStatement >> redirection: anObject [

	<ignoreForCoverage>
	<generated>
	redirection := anObject
]
