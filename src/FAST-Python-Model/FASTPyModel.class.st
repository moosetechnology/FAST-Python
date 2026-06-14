Class {
	#name : 'FASTPyModel',
	#superclass : 'MooseModel',
	#traits : 'FASTPyTEntityCreator + FASTTEntityCreator',
	#classTraits : 'FASTPyTEntityCreator classTrait + FASTTEntityCreator classTrait',
	#category : 'FAST-Python-Model-Model',
	#package : 'FAST-Python-Model',
	#tag : 'Model'
}

{ #category : 'accessing' }
FASTPyModel class >> allSubmetamodelsPackagesNames [
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits' #'FAST-Core-Model')
]

{ #category : 'meta' }
FASTPyModel class >> annotation [

	<FMClass: #Model super: #MooseModel>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyModel >> allClassDefinitions [

	^ self allWithType: FASTPyClassDefinition
]

{ #category : 'accessing' }
FASTPyModel >> allFunctionDefinitions [

	^ self allWithType: FASTPyFunctionDefinition
]

{ #category : 'accessing' }
FASTPyModel >> allModules [

	^ self allWithType: FASTPyModule
]
