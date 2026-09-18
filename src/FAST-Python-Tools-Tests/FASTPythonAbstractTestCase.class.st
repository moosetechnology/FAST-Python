Class {
	#name : 'FASTPythonAbstractTestCase',
	#superclass : 'ParametrizedTestCase',
	#instVars : [
		'model',
		'persist'
	],
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'testing' }
FASTPythonAbstractTestCase class >> isAbstract [

	^ self = FASTPythonAbstractTestCase
]

{ #category : 'building suites' }
FASTPythonAbstractTestCase class >> testParameters [

	^ ParametrizedTestMatrix new forSelector: #persist addOptions: { false. true }
]

{ #category : 'running' }
FASTPythonAbstractTestCase >> exportAndImportModelIfNeeded [

	| json |
	self persist ifFalse: [ ^ self ].

	json := model asJSONString.

	model := json readStreamDo: [ :stream | FASTPyModel new importFromJSONStream: stream ]
]

{ #category : 'running' }
FASTPythonAbstractTestCase >> parse: aString [
	"I import a FAST Python model from a string and if #persist is true, I export and reimport the model to test that export/import works fine."

	self privateParse: aString.
	self exportAndImportModelIfNeeded
]

{ #category : 'accessing' }
FASTPythonAbstractTestCase >> persist [

	^ persist
]

{ #category : 'accessing' }
FASTPythonAbstractTestCase >> persist: anObject [

	persist := anObject
]

{ #category : 'running' }
FASTPythonAbstractTestCase >> privateParse: aString [
	"I parse a string and return a FAST Python model"

	^ model := FASTPythonImporter new
		           errorReportBlock: [ :i | i errors ifNotEmpty: [ self fail: 'Errors happened during parsing. Errors: ' , i errors printString ] ];
		           parse: aString withPlatformLineEndings
]
