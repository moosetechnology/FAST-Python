Class {
	#name : 'FASTPythonLRAbstractScope',
	#superclass : 'Object',
	#instVars : [
		'nameDictionary',
		'entity'
	],
	#category : 'FAST-Python-Tools-LocalResolver',
	#package : 'FAST-Python-Tools',
	#tag : 'LocalResolver'
}

{ #category : 'instance creation' }
FASTPythonLRAbstractScope class >> for: anEntity [

	^ self new
		  entity: anEntity;
		  yourself
]

{ #category : 'as yet unclassified' }
FASTPythonLRAbstractScope >> declarationNamed: aVariableName ifPresent: aBlock [

	^ nameDictionary at: aVariableName ifPresent: aBlock
]

{ #category : 'as yet unclassified' }
FASTPythonLRAbstractScope >> ensureDeclarationOf: aVariableName assignment: anAssignment [
	"If it is already present we do nothing "

	^ nameDictionary
		  at: aVariableName
		  ifPresent: [ :declaration |
				  declaration localResolverKind = anAssignment localResolverKind
					  ifTrue: [ ^ declaration ]
					  ifFalse: [ "If the kind is different, we save a new declaration."
							  anAssignment clearLocalUses.
							  nameDictionary at: aVariableName put: anAssignment ] ]
		  ifAbsentPut: [
				  anAssignment clearLocalUses.
				  anAssignment ]
]

{ #category : 'accessing' }
FASTPythonLRAbstractScope >> entity: anObject [
	entity := anObject
]

{ #category : 'initialization' }
FASTPythonLRAbstractScope >> initialize [

	super initialize.
	nameDictionary := Dictionary new
]
