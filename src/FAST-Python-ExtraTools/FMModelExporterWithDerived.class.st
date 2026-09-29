"
I am a special exporter that exports also derived properties. This is useful when we want to provide a model to people not using Moose.

I also allow to give a blacklist of properties to exclude. It should contain identifier of properties to exclude in this form: `TEntityMetaLevelDependency>>#fanIn` for example.

If a property fails to be computed, it is not exported.

Example 

```smalltalk
model exportAsJSONWithDerivedBlacklist: #('TEntityMetaLevelDependency>>#isDead' 'TEntityMetaLevelDependency>>#fanIn' 'TEntityMetaLevelDependency>>#fanOut' 'TEntityMetaLevelDependency>>#numberOfDeadChildren' 'TEntityMetaLevelDependency>>#numberOfExternalClients' 'TEntityMetaLevelDependency>>#numberOfExternalProviders' 'TEntityMetaLevelDependency>>#numberOfInternalProviders' 'TEntityMetaLevelDependency>>#numberOfInternalClients')
```

"
Class {
	#name : 'FMModelExporterWithDerived',
	#superclass : 'FMModelExporter',
	#instVars : [
		'blacklist'
	],
	#category : 'FAST-Python-ExtraTools',
	#package : 'FAST-Python-ExtraTools'
}

{ #category : 'accessing' }
FMModelExporterWithDerived >> blacklist [
	^ blacklist
]

{ #category : 'accessing' }
FMModelExporterWithDerived >> blacklist: anObject [
	blacklist := anObject
]

{ #category : 'initialization' }
FMModelExporterWithDerived >> initialize [

	super initialize.
	blacklist := OrderedCollection new
]

{ #category : 'exporting' }
FMModelExporterWithDerived >> shouldExportProperty: property for: anEntity [

	(self blacklist includes: property compiledMethod name) ifTrue: [ ^ false ].

	^ [ super shouldExportProperty: property for: anEntity ]
		  on: Error
		  do: [
				  property traceCr.
				  false ]
]

{ #category : 'exporting' }
FMModelExporterWithDerived >> shouldIgnoreProperty: property [

	(model metamodel includes: property) ifFalse: [ ^ true ].

	^ false
]
