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

	<ignoreForCoverage>
	<generated>
	^ #(#'Moose-Query' #'Famix-Traits' #'FAST-Core-Model')
]

{ #category : 'meta' }
FASTPyModel class >> annotation [

	<ignoreForCoverage>
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

{ #category : 'accessing' }
FASTPyModel >> allResolvedDeclarations [
	"This method needs the local resolution to be done.

	I return all the local declarations of the resolved variables of the model.
	"

	^ self allResolvedVariables collect: #localDeclaration as: Set
]

{ #category : 'accessing' }
FASTPyModel >> allResolvedDeclarationsByName [
	"This method needs the local resolution to be done.

	I return a Dictionary grouping all the local declarations of the resolved variables of the model by their name.
	The keys are the name (String) and the values are the collection of declarations having this name.
	"

	^ self allResolvedDeclarations groupedBy: #name
]

{ #category : 'accessing' }
FASTPyModel >> allResolvedVariableVersions [
	"This method needs the SSA resolution to be done.

	I return all the SSA versions of the resolved variables of the model.
	"

	^ self allResolvedVariables collect: #ssaVersion as: Set
]

{ #category : 'accessing' }
FASTPyModel >> allResolvedVariableVersionsByName [
	"This method needs the SSA resolution to be done.

	I return a Dictionary grouping all the SSA versions of the resolved variables of the model by their name.
	The keys are the name (String) and the values are the collection of versions having this name.
	"

	^ self allResolvedVariableVersions groupedBy: #name
]

{ #category : 'accessing' }
FASTPyModel >> allResolvedVariables [
	"This method needs the local resolution to be done.
	
	I return all nodes representing a variable in the model
	"

	^ self entities select: [ :entity | entity isQueryable and: [ entity isResolvedVariable ] ]
]

{ #category : 'accessing' }
FASTPyModel >> allResolvedVariablesByName [
	"I return a Dictionary grouping all the resolved variables of the model by their name.
The keys are the name (String) and the values are the collection of entities having this name."

	^ self allResolvedVariables groupedBy: #name
]

{ #category : 'accessing' }
FASTPyModel >> module [
	"In general a fast python model can only get one module so I return this module."

	self assert: self allModules size = 1.
	^ self allModules anyOne
]
