Class {
	#name : 'FASTPythonAbstractTestCase',
	#superclass : 'TestCase',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
FASTPythonAbstractTestCase >> parse: aString [

	^ FASTPythonImporter new
		  errorReportBlock: [ :i | i errors ifNotEmpty: [ self fail: 'Errors happened during parsing. Errors: ' , i errors printString ] ];
		  parse: aString withPlatformLineEndings
]
