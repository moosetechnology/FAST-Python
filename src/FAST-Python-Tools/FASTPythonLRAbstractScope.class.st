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

{ #category : 'actions' }
FASTPythonLRAbstractScope >> declarationNamed: aVariableName ifPresent: aBlock [

	^ nameDictionary at: aVariableName ifPresent: aBlock
]

{ #category : 'actions' }
FASTPythonLRAbstractScope >> ensureDeclarationOf: aName declaration: aFASTNode [
	"If it is already present we do nothing. Else we create the local declaration.
	
	I just `ensure` that the local uses are initialized instead of reseting them as we do in other languages because in Python I have multiple variables that can be declared in the same assignment because of the tuples."

	^ nameDictionary
		  at: aName
		  ifPresent: [ :declaration |
				  declaration localResolverKind = aFASTNode localResolverKind
					  ifTrue: [ ^ declaration ]
					  ifFalse: [ "If the kind is different, we save a new declaration."
							  aFASTNode ensureLocalUses.
							  nameDictionary at: aName put: aFASTNode ] ]
		  ifAbsentPut: [
				  aFASTNode
					  ensureLocalUses;
					  yourself ]
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
