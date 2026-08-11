Class {
	#name : 'FASTPythonAbstractTestCase',
	#superclass : 'TestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Model-Tests',
	#package : 'FAST-Python-Model-Tests'
}

{ #category : 'testing' }
FASTPythonAbstractTestCase class >> isAbstract [

	^ self = FASTPythonAbstractTestCase
]

{ #category : 'running' }
FASTPythonAbstractTestCase >> parse: aString [

	^ model := FASTPythonImporter new
		           errorReportBlock: [ :i | i errors ifNotEmpty: [ self fail: 'Errors happened during parsing. Errors: ' , i errors printString ] ];
		           parse: aString withPlatformLineEndings
]
