"
I am a package containing extra tools. Originally for Profile contract.
"
Class {
	#name : 'ManifestFASTPythonExtraTools',
	#superclass : 'PackageManifest',
	#category : 'FAST-Python-ExtraTools-Manifest',
	#package : 'FAST-Python-ExtraTools',
	#tag : 'Manifest'
}

{ #category : 'asserting' }
ManifestFASTPythonExtraTools class >> shouldBeIncludedByDefaultInMetamodelsWith: aCollectionOfPackages [
	"Includes in MM that are based on FAST"

	^ aCollectionOfPackages anySatisfy: [ :package | package definedClasses anySatisfy: [ :class | class = FASTPyEntity ] ]
]
