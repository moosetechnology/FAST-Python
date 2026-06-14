"
I represent an expression that can give an exception to raise in a raise statement.

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentRaiseStatement` | `FASTPyTRaised` | `exception` | `FASTPyRaiseStatement` | |



"
Trait {
	#name : 'FASTPyTRaised',
	#instVars : [
		'#parentRaiseStatement => FMOne type: #FASTPyRaiseStatement opposite: #exception'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTRaised classSide >> annotation [

	<FMClass: #TRaised super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTRaised >> parentRaiseStatement [
	"Relation named: #parentRaiseStatement type: #FASTPyRaiseStatement opposite: #exception"

	<generated>
	<container>
	<derived>
	^ parentRaiseStatement
]

{ #category : 'accessing' }
FASTPyTRaised >> parentRaiseStatement: anObject [

	<generated>
	parentRaiseStatement := anObject
]
