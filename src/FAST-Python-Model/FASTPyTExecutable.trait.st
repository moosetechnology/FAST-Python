"
I represent something that can be executed by an exec statement

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentExecStatement` | `FASTPyTExecutable` | `code` | `FASTPyExecStatement` | |



"
Trait {
	#name : 'FASTPyTExecutable',
	#instVars : [
		'#parentExecStatement => FMOne type: #FASTPyExecStatement opposite: #code'
	],
	#category : 'FAST-Python-Model-Traits',
	#package : 'FAST-Python-Model',
	#tag : 'Traits'
}

{ #category : 'meta' }
FASTPyTExecutable classSide >> annotation [

	<FMClass: #TExecutable super: #Object>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyTExecutable >> parentExecStatement [
	"Relation named: #parentExecStatement type: #FASTPyExecStatement opposite: #code"

	<generated>
	<container>
	<derived>
	^ parentExecStatement
]

{ #category : 'accessing' }
FASTPyTExecutable >> parentExecStatement: anObject [

	<generated>
	parentExecStatement := anObject
]
