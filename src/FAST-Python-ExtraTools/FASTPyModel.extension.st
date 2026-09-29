Extension { #name : 'FASTPyModel' }

{ #category : '*FAST-Python-ExtraTools' }
FASTPyModel >> exportAsJSONWithDerived [

	^ self exportAsJSONWithDerivedBlacklist: #(  )
]

{ #category : '*FAST-Python-ExtraTools' }
FASTPyModel >> exportAsJSONWithDerivedBlacklist: aCollection [
	"The blacklist should be a collection of properties to exclude such as `TEntityMetalevelDependency>>fanIn`."

	^ String streamContents: [ :stream |
			  FMModelExporterWithDerived new
				  blacklist: aCollection;
				  model: ((FMModel withMetamodel: self metamodel)
						   addAll: self entities;
						   yourself);
				  printer: (FMJSONPrinter on: stream);
				  run ]
]
