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

{ #category : 'visiting' }
FASTPythonSSAVisitor >> createPhiVersionFor: localDeclaration versions: allVersions [
	"No need to add it to the versions since it was already added by the previous versions."

	| phiVersion |
	phiVersion := FASTVariablePhiVersionSSA for: allVersions.
	localDeclaration activeVersion: phiVersion.
	^ phiVersion
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

{ #category : 'accessing' }
FASTPythonSSAVisitor >> currentActiveVersions [

	^ variableVersions collect: #activeVersion
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

{ #category : 'visiting' }
FASTPythonSSAVisitor >> producePhiVersionBasedOnPreviousVariables: previousVariables andNewVariableMap: newVariablesMap [

	| declarationsToMerge |
	declarationsToMerge := newVariablesMap values flatten collectAsSet: #localDeclaration.

	declarationsToMerge do: [ :localDeclaration |
			| allVersions |
			"First we collect all the versions to use to produce a new Phi version for the current local declaration. "
			allVersions := Set new.
			newVariablesMap valuesDo: [ :variables |
					variables
						detect: [ :variable | variable localDeclaration = localDeclaration ]
						ifFound: [ :variable | allVersions add: variable ] ].

			"If not all branches are creating a new version, we need to add the previous version also to the list of variables for the Phi variable. Note that it is possible it did not exist before."
			allVersions size = newVariablesMap size ifFalse: [
					previousVariables
						detect: [ :variable | variable localDeclaration = localDeclaration ]
						ifFound: [ :variable | allVersions add: variable ] ].

			self createPhiVersionFor: localDeclaration versions: allVersions ]
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
FASTPythonSSAVisitor >> visitCFGAbstractConditionalBlock: aBlock [

	| previousVariables newVariablesMap |
	self visitedBlocks add: aBlock.

	aBlock statements do: [ :statement | statement accept: self ].

	previousVariables := self currentActiveVersions. "We need to do this after visiting the statements that could produce new variables."
	newVariablesMap := IdentityDictionary new.

	aBlock nextBlocks do: [ :block |
			(self visitedBlocks includes: block) ifFalse: [ block accept: self ].
			newVariablesMap at: block put: (self currentActiveVersions difference: previousVariables) ].

	self producePhiVersionBasedOnPreviousVariables: previousVariables andNewVariableMap: newVariablesMap
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyFunctionDefinition: aFunctionDefinition [
	"Reordering for parameters to be visited before the statements in order to have all declarations"

	self visitFASTTWithParameters: aFunctionDefinition.
	self visitEntity: aFunctionDefinition returnType.
	self visitFASTPyTDefinition: aFunctionDefinition.
	self visitFASTPyTWithTypeParameters: aFunctionDefinition.
	self visitFASTPyStatement: aFunctionDefinition
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyIdentifier: anIdentifier [

	anIdentifier isVariableWriteAccess ifTrue: [ ^ self handleNewAssignemntTo: anIdentifier ].

	anIdentifier localDeclaration isNonLocalDeclaration ifFalse: [ anIdentifier ssaVersion: anIdentifier localDeclaration activeVersion ].

	super visitFASTPyIdentifier: anIdentifier
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyParameter: aParameter [
	"Contrary to the visit of py identifier, we should always have a local declaration for a parameter. If it is nil, there is a bug in the local resolver"

	aParameter isVariableWriteAccess ifTrue: [ self handleNewAssignemntTo: aParameter ].

	super visitFASTPyParameter: aParameter
]
