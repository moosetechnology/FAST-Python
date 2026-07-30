"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestFASTPythonTools',
	#superclass : 'PackageManifest',
	#category : 'FAST-Python-Tools-Manifest',
	#package : 'FAST-Python-Tools',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestFASTPythonTools class >> ruleInconsistentMethodClassificationRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#FASTPythonLocalResolverVisitor)) #'2026-07-30T14:41:37.271103+02:00') )
]
