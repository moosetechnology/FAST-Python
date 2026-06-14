"
I am a FAST Python importer. 

I mostly declare the TS language to use and redirect the visit to `FASTPythonVisitor`.
"
Class {
	#name : 'FASTPythonImporter',
	#superclass : 'TSFASTAbstractImporter',
	#category : 'FAST-Python-Tools-Importing',
	#package : 'FAST-Python-Tools',
	#tag : 'Importing'
}

{ #category : 'world menu' }
FASTPythonImporter class >> devFASTPythonMenu: aBuilder [

	<worldMenu>
	(aBuilder item: #DevFASTPython)
		order: 100;
		label: 'FAST Python dev utilities';
		"parent: #Famix; uncomment later when the dev will be more advanced."
		icon: MooseIcons mooseIcon;
		with: [
				(aBuilder item: #ResetMM)
					label: 'Regenerate MM';
					order: 1;
					icon: (self iconNamed: #refresh);
					action: [ FASTPythonMetamodelGenerator new generate ].
				(aBuilder item: #ImportBatch1)
					label: 'Import batch 1';
					order: 2;
					icon: (self iconNamed: #smallNew);
					action: [ self devParseBatch1 ].
				(aBuilder item: #ImportBatch1To10)
					label: 'Import batch 1 to 10';
					order: 2;
					icon: (self iconNamed: #smallNew);
					action: [ self devParseFiles: ('/Users/cyril/marius/10batches' asFileReference allFiles select: [ :f | f extension = 'py' ]) ].
				(aBuilder item: #'Toggle FAST Importer Debug mode')
					action: [ TSFASTVisitor isInDebugMode: TSFASTVisitor isInDebugMode not ];
					order: 99999;
					withSeparatorAfter;
					help: 'If this is enabled, errors will not be caught in the FAST importing but passed.';
					icon: (self iconNamed: #configuration) ]
]

{ #category : 'development support' }
FASTPythonImporter class >> devParseAll [
	"Command specific to help me develop. this is useful to know the file to parse everything and detect if this raises any error.
	We do not save the models to not flood the memory and allow their GC."

	<script>
	self devParseFiles: ('/Users/cyril/marius/selected_notebooks_converted' asFileReference allFiles select: [ :f | f extension = 'py' ])
]

{ #category : 'development support' }
FASTPythonImporter class >> devParseBatch1 [

	<script>
	[ self devParseBatchNumber: '001' ] spy
]

{ #category : 'development support' }
FASTPythonImporter class >> devParseBatchNumber: aString [
	"Command specific to help me develop. this is useful to know the file to parse everything and detect if this raises any error.
	We do not save the models to not flood the memory and allow their GC."

	<script>
	self devParseFiles: (('/Users/cyril/marius/selected_notebooks_converted/batch_' , aString) asFileReference allFiles select: [ :f | f extension = 'py' ])
]

{ #category : 'development support' }
FASTPythonImporter class >> devParseFiles: aCollection [
	"Command specific to help me develop. this is useful to know the file to parse everything and detect if this raises any error.
	We do not save the models to not flood the memory and allow their GC..
	
	I save as last element the time it took to run on the full batch."

	| result |
	result := OrderedCollection new.

	result add: [
			aCollection
				do: [ :file |
						| timeToRun |
						timeToRun := [ self parseFile: file ] millisecondsToRun.
						result add: file -> timeToRun ]
				displayingProgress: [ :file | file pathString ] ] millisecondsToRun.

	result inspect
]

{ #category : 'accessing' }
FASTPythonImporter >> tsLanguage [

	^ TSLanguage python
]

{ #category : 'accessing' }
FASTPythonImporter >> visitorClass [

	^ FASTPythonTreeSitterVisitor
]
