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
FASTPythonLRAbstractScope >> ensureDeclarationOf: aName declaration: aFASTNode [
	"If it is already present we do nothing "

	^ nameDictionary
		  at: aName
		  ifPresent: [ :declaration |
				  declaration localResolverKind = aFASTNode localResolverKind
					  ifTrue: [ ^ declaration ]
					  ifFalse: [ "If the kind is different, we save a new declaration."
							  aFASTNode clearLocalUses.
							  nameDictionary at: aName put: aFASTNode ] ]
		  ifAbsentPut: [
				  aFASTNode clearLocalUses.
				  aFASTNode ]
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
