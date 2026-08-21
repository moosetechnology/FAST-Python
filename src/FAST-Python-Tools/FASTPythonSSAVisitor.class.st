Class {
	#name : 'FASTPythonSSAVisitor',
	#superclass : 'FASTPythonVisitor',
	#traits : 'FASTCFGTVisitor',
	#classTraits : 'FASTCFGTVisitor classTrait',
	#instVars : [
		'newVariablesMap',
		'localDeclarations'
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
	allVersions size < 2 ifTrue: [ ^ self ]. "No need to create a phi version if we don't have at least 2 versions"

	phiVersion := FASTVariablePhiVersionSSA for: allVersions.
	localDeclaration activeVersion: phiVersion.
	^ phiVersion
]

{ #category : 'actions' }
FASTPythonSSAVisitor >> createVariableVersionFor: aFASTEntity [

	| newSSA |
	newSSA := FASTVariableVersionSSA for: aFASTEntity.
	aFASTEntity lastSSAVersion ifNotNil: [ :lastSSA | newSSA version: lastSSA version ].

	aFASTEntity localDeclaration activeVersion: newSSA.

	localDeclarations add: aFASTEntity localDeclaration.

	^ newSSA
]

{ #category : 'accessing' }
FASTPythonSSAVisitor >> currentActiveVersions [

	^ localDeclarations collect: #activeVersion
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
	localDeclarations := IdentitySet new.
	newVariablesMap := IdentityDictionary new
]

{ #category : 'hooks' }
FASTPythonSSAVisitor >> postConditonalsBranchVisitOf: firstBranchBlock conditional: aConditionalBlock [
	"Once we visited a conditional branch, we save the current active versions for this branch."

	| mapForConditional |
	mapForConditional := newVariablesMap at: aConditionalBlock.
	mapForConditional at: firstBranchBlock put: (self currentActiveVersions difference: (mapForConditional at: #previousVariables))
]

{ #category : 'hooks' }
FASTPythonSSAVisitor >> postConditonalsBranchesVisitOf: aConditionalBlock [
	"Once we're done visiting a conditional block we can clean the map and to build the Phi variables."

	| mapForConditional previousVariables |
	mapForConditional := newVariablesMap at: aConditionalBlock.
	previousVariables := mapForConditional at: #previousVariables.
	mapForConditional removeKey: #previousVariables.
	self producePhiVersionBasedOnPreviousVariables: previousVariables andNewVariableMap: mapForConditional.
	newVariablesMap removeKey: aConditionalBlock
]

{ #category : 'hooks' }
FASTPythonSSAVisitor >> preConditonalsBranchesVisitOf: aConditionalBlock [
	"When we start to visit the branches of a conditional, we start by creating an entri for this conditional in the new variables map and we save the actives versions present before visiting the childrem."

	newVariablesMap at: aConditionalBlock put: (IdentityDictionary with: #previousVariables -> self currentActiveVersions)
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

{ #category : 'visiting - reordering' }
FASTPythonSSAVisitor >> visitFASTPyFunctionDefinition: aFunctionDefinition [
	"Reordering for parameters to be visited before the statements in order to have all declarations"

	self visitFASTTWithParameters: aFunctionDefinition.
	self visitEntity: aFunctionDefinition returnType.
	self visitFASTPyTDefinition: aFunctionDefinition.
	self visitFASTPyTWithTypeParameters: aFunctionDefinition.
	self visitFASTPyStatement: aFunctionDefinition
]

{ #category : 'visiting - reordering' }
FASTPythonSSAVisitor >> visitFASTPyMethodDefinition: aMethodDefinition [
	"We resolve in the same way as functions."

	self visitFASTPyFunctionDefinition: aMethodDefinition
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyTCanBeVariable: aTCanBeVariable [

	aTCanBeVariable isVariableWriteAccess
		ifTrue: [ self handleNewAssignemntTo: aTCanBeVariable ]
		ifFalse: [ aTCanBeVariable localDeclaration isNonLocalDeclaration ifFalse: [ aTCanBeVariable ssaVersion: aTCanBeVariable localDeclaration activeVersion ] ].

	super visitFASTPyTCanBeVariable: aTCanBeVariable
]

{ #category : 'visiting' }
FASTPythonSSAVisitor >> visitFASTPyTDefinition: aTDefinition [
	"We need to redo the CFG for definitions"

	| cfg |
	self visitFASTTNamedEntity: aTDefinition.
	self visitCollection: aTDefinition decorators.

	cfg := aTDefinition cfg.
	self visit: cfg
]
