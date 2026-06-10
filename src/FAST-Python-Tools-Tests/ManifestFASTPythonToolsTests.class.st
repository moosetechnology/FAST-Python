"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestFASTPythonToolsTests',
	#superclass : 'PackageManifest',
	#category : 'FAST-Python-Tools-Tests-Manifest',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestFASTPythonToolsTests class >> ruleReCollectionAtCollectionSizeRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#FASTPythonImporterTest)) #'2026-03-03T01:09:10.854455+01:00') #(#(#RGPackageDefinition #(#'FAST-Python-Tools-Tests')) #'2026-06-10T14:34:34.337737+02:00') )
]
