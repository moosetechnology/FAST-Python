"
I am a node representing the `>>` part of a print statement. Print statement is only available in Python 2, not Python 3

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentPrintStatement` | `FASTPyChevron` | `redirection` | `FASTPyPrintStatement` | |

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `expression` | `FASTPyChevron` | `parentChevron` | `FASTPyExpression` | |



"
Class {
	#name : 'FASTPyChevron',
	#superclass : 'FASTPyEntity',
	#instVars : [
		'#expression => FMOne type: #FASTPyExpression opposite: #parentChevron',
		'#parentPrintStatement => FMOne type: #FASTPyPrintStatement opposite: #redirection'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyChevron class >> annotation [

	<FMClass: #Chevron super: #FASTPyEntity>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyChevron >> expression [
	"Relation named: #expression type: #FASTPyExpression opposite: #parentChevron"

	<generated>
	^ expression
]

{ #category : 'accessing' }
FASTPyChevron >> expression: anObject [

	<generated>
	expression := anObject
]

{ #category : 'accessing' }
FASTPyChevron >> parentPrintStatement [
	"Relation named: #parentPrintStatement type: #FASTPyPrintStatement opposite: #redirection"

	<generated>
	<container>
	<derived>
	^ parentPrintStatement
]

{ #category : 'accessing' }
FASTPyChevron >> parentPrintStatement: anObject [

	<generated>
	parentPrintStatement := anObject
]
