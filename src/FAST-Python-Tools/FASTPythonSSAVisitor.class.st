Class {
	#name : 'FASTPythonSSAVisitor',
	#superclass : 'FASTPythonVisitor',
	#traits : 'FASTCFGTVisitor',
	#classTraits : 'FASTCFGTVisitor classTrait',
	#instVars : [
		'variableVersions'
	],
	#category : 'FAST-Python-Tools-CFG/LocalResolver/SSA',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/LocalResolver/SSA'
}

{ #category : 'resolving' }
FASTPythonSSAVisitor class >> resolve: aPythonEntity [

	^ self new resolve: aPythonEntity
]

{ #category : 'actions' }
FASTPythonSSAVisitor >> createVariableVersionFor: aFASTEntity [

	| newSSA |
	newSSA := FASTVariableVersionSSA for: aFASTEntity.
	aFASTEntity localDeclaration activeVersion ifNotNil: [ :lastSSA | newSSA version: lastSSA version ].

	aFASTEntity localDeclaration activeVersion: newSSA.

	variableVersions add: aFASTEntity localDeclaration.

	^ newSSA
]

{ #category : 'actions' }
FASTPythonSSAVisitor >> handleNewAssignemntTo: aFASTEntity [

	aFASTEntity ssaVersion: ((self createVariableVersionFor: aFASTEntity)
			 newVersionNumber;
			 yourself)
]

{ #category : 'initialization' }
FASTPythonSSAVisitor >> initialize [

	super initialize.
	variableVersions := IdentitySet new
]

{ #category : 'actions' }
FASTPythonSSAVisitor >> resolve: aFASTBehaviouralEntity [

	| cfg |
	"First we do a local resolution so that each entity are linked to their local declaration"
	FASTPythonLocalResolverVisitor resolve: aFASTBehaviouralEntity.

	"Then we build the CFG to know the different paths on the entity"
	cfg := aFASTBehaviouralEntity cfg.

	"And lastly, I can build the SSA now that I have the CFG and Local declarations."
	self visit: cfg
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visit: aCFGBlockOrFASTEntity [

	self flag: #todo. "Should be moved to the CFG visitor of FAST"
	^ aCFGBlockOrFASTEntity ifNotNil: [ aCFGBlockOrFASTEntity accept: self ]
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyIdentifier: anIdentifier [

	anIdentifier isSSAVariableAssignment ifTrue: [ self handleNewAssignemntTo: anIdentifier ].

	super visitFASTPyIdentifier: anIdentifier
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyParameter: aParameter [
	"Contrary to the visit of py identifier, we should always have a local declaration for a parameter. If it is nil, there is a bug in the local resolver"

	aParameter localDeclaration isSSAVariableAssignment ifTrue: [ self handleNewAssignemntTo: aParameter ].

	super visitFASTPyParameter: aParameter
]
