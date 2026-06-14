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
