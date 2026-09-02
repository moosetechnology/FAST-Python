Class {
	#name : 'FASTPythonMetamodelTest',
	#superclass : 'TSFASTAbstractImporterTest',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
FASTPythonMetamodelTest >> testCanResetMetamodel [

	self shouldnt: [ FASTPyModel resetMetamodel ] raise: Error
]

{ #category : 'tests' }
FASTPythonMetamodelTest >> testGeneratorIsUpToDate [

	| changes |
	changes := FASTPythonMetamodelGenerator new changesToApply.
	self assert: changes isEmpty description: [
			'The generator FASTPythonMetamodelGenerator  is not in sync with its meta-model. Please, regenerate your MMs with `FamixMetamodelGenerator generateAllMetamodels`. List of changes: '
			, changes printString ]
]
