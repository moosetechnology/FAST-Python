Extension { #name : 'FASTPyEntity' }

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> cfg [

	^ FASTPythonCFGVisitor buildCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> fullCfg [

	^ FASTPythonCFGVisitor new buildFullCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> isResolvedVariable [
	"Return true if this entity has been resolved to a local variable declaration.
	
	This method needs the local resolution to have happen. Variable that are not declared in the imported code are ignored because we cannot know if they are variables or other things."

	| decl |
	decl := self localDeclarationIfAbsent: [ ^ false ].

	decl isNonLocalDeclaration ifTrue: [ ^ false ].

	^ decl localResolverKind = #variable
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> lastSSAVersion [
	"Return the last active SSA version if there is one. In Python lots of things can shadow each other, so we check if there was not a variable shadowed previously.
	
	For example:
	
	x = 3 
	
	def x(): pass
	
	x = 4
	
	Here the second assignment follow the first one but was interrupted by the function. But we still need to link them in the SSA."

	| entity |
	entity := self localDeclaration.
	[ entity isNotNil ] whileTrue: [
			entity activeVersion ifNotNil: [ :version | ^ version ].
			entity := entity shadowing ].

	^ nil
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> localResolverKind [
	"In the local resolver, if we redefine an entity with an entity of the same kind, we keep the same declaration. Else we create a new one. 
	
	I am used to know the kind of entity that is been declared."

	^ self error: 'This entity cannot be a local declaration or is missing the overriding method.'
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> selfOrTopmostAssignableCollection [
	"If I am in a tuple, I return the tuple (this applies recursively, if I am in a tuple in a tuple I return the topmost tuple).
	If I am in a splat used as assignment target (e.g. `a, *b = ...`), I also go through the splat.
	
	Else, return myself."

	| node |
	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"
	node := self.
	[ node collectionInitializer isNotNil and: [ node collectionInitializer isTuple or: [ node collectionInitializer isList ] ] ] whileTrue: [
		node := node collectionInitializer ].

	node parentSplat ifNotNil: [ :splat | ^ splat selfOrTopmostAssignableCollection ].

	^ node
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> transitiveAssignedExpressions [
	"I return for a variable, the expressions that were used during its assignment. If an expression references a variable, recursively add the expressions assigned if those variables."

	| visitedExpressions visitedAccesses result toVisit |
	visitedExpressions := OrderedCollection new.
	visitedAccesses := OrderedCollection new.
	result := OrderedCollection new.

	self flag: #todo. "Simplify once the todo of #assignedExpressions is done"
	self versionWriteAccesses do: [ :access |
			visitedAccesses add: access.
			result addAll: access variableDeclarator assignedExpressions ].

	[
		toVisit := result \ visitedExpressions.
		toVisit isEmpty ] whileFalse: [
			toVisit do: [ :expression |
					visitedExpressions add: expression.
					expression usedVariables do: [ :variable |
							variable versionWriteAccesses \ visitedAccesses do: [ :access |
									visitedAccesses add: access.
									result addAll: access variableDeclarator assignedExpressions ] ] ] ].

	^ result
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> usedVariables [
	"Return all entities in my subtree that have been resolved to local variable declarations.
	
	Once the LocalResolution has been done, this allows to find all variable nodes (declared in the model)."

	^ self query containedEntities recursively withProperty: #isResolvedVariable
]
