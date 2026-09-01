Extension { #name : 'FASTPyEntity' }

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> allNodesUsingMe [
	"If I am a variable, return all the nodes using me and all the other accesses of the same variable: the ancestors of each access of the variable, stopping (exclusively) when the parent is a FASTTStatementBlock (Module, function, method, clauses, ...).
	For example, for `return x + 3`, I return the return statement and the binary operation.

	I need the local resolution to be done before."

	^ self allAccesses
		  flatCollect: [ :access |
				  | node nodes |
				  nodes := OrderedCollection new.
				  node := access.
				  [ node parentNode isNotNil and: [ (node parentNode isOfType: FASTTStatementBlock) not ] ] whileTrue: [
						  node := node parentNode.
						  nodes add: node ].
				  node ifNil: [ self error: 'A variable should always be in a statement block' ].
				  nodes ]
		  as: Set
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> allNodesUsingMyVersion [
	"If I am a variable, return all the nodes using the accesses reachable from my current SSA version: the ancestors of each reachable access, stopping (exclusively) when the parent is a FASTTStatementBlock.
	Contrary to #allNodesUsingMe, I only consider the accesses of the current SSA version. In case of a Phi version, the accesses of all the reachable versions are considered.

	I need the SSA to be done before."

	^ self versionAccesses
		  flatCollect: [ :access |
				  | node nodes |
				  nodes := OrderedCollection new.
				  node := access.
				  [ node parentNode isNotNil and: [ (node parentNode isOfType: FASTTStatementBlock) not ] ] whileTrue: [
						  node := node parentNode.
						  nodes add: node ].
				  node ifNil: [ self error: 'A variable should always be in a statement block' ].
				  nodes ]
		  as: Set
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> callsOnVariable [
	"If I am a variable, return all the call nodes having my read accesses as receiver. This will group invocations and instantiations.

	I need the local resolution to be done before."

	^ self allReadAccesses
		  select: [ :access | access isReceiverOfCall ]
		  thenCollect: [ :access | access parentAttributeObject caller ]
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> callsOnVariableVersion [
	"If I am a variable, return all the call nodes having my variable version (SSA)) as receiver. This will group invocations and instantiations.

	I need the SSA to be done before."

	^ self versionReadAccesses
		  select: [ :access | access isReceiverOfCall ]
		  thenCollect: [ :access | access parentAttributeObject caller ]
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> cfg [

	^ FASTPythonCFGVisitor buildCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> fullCfg [

	^ FASTPythonCFGVisitor new buildFullCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> internalAccesses [
	"If I am a variable, return all internal access done on me and all other accesses of the same variable. 
	
	I need the local resolution to be done before.
	
	It can be of two kinds:
		- subscript `x[3]`
		- attribute `x.y`"

	^ self allAccesses
		  collect: #internalAccess
		  thenReject: #isNil
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
FASTPyEntity >> statementsUsingMe [
	"If I am a variable, return all the statements using me and all the other accesses of the same variable.
	Contrary to #allNodesUsingMe that returns all the nodes between the variable and its statement, I return only the statement containing the variable. For example, for `return x + 3`, #allNodesUsingMe returns the return statement and the binary operation while I only return the return statement.

	I need the local resolution to be done before."

	^ self allAccesses
		  collect: [ :access |
				  | node |
				  node := access.
				  [ node parentNode isNotNil and: [ (node parentNode isOfType: FASTTStatementBlock) not ] ] whileTrue: [ node := node parentNode ].
				  node ifNil: [ self error: 'A variable should always be in a statement block' ].
				  node ]
		  as: Set
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> statementsUsingMyVersion [
	"If I am a variable, return all the statements using the accesses reachable from my current SSA version.
	Contrary to #allNodesUsingMyVersion that returns all the nodes between the variable accesses and their statements, I return only the statements containing the variable.

	I need the SSA to be done before."

	^ self versionAccesses
		  collect: [ :access |
				  | node |
				  node := access.
				  [ node parentNode isNotNil and: [ (node parentNode isOfType: FASTTStatementBlock) not ] ] whileTrue: [ node := node parentNode ].
				  node ifNil: [ self error: 'A variable should always be in a statement block' ].
				  node ]
		  as: Set
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> transitiveAssignedExpressions [
	"I return for a write access to a variable, the expressions that were used during its assignment. If an expression references a variable, recursively add the expressions assigned to those variables."

	| toVisit visitedAccesses result |
	toVisit := OrderedCollection new.
	visitedAccesses := OrderedCollection new.
	result := OrderedCollection new.

	toVisit addAll: self assignedExpressions.

	[ toVisit isEmpty ] whileFalse: [
			| expression |
			result add: (expression := toVisit removeFirst).
			expression usedVariables do: [ :variable |
					variable versionWriteAccesses \ visitedAccesses do: [ :access |
							visitedAccesses add: access.
							toVisit addAll: access variableDeclarator assignedExpressions ] ] ].

	^ result
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> transitiveAssignedExpressionsMap [
	"I return a dictionary with all write accesses of the receiver (it needs to be a variable) as key, and their transitive assigned expressions as values."

	| result |
	result := Dictionary new.

	self versionWriteAccesses do: [ :access | result at: access put: access variableDeclarator transitiveAssignedExpressions ].
	^ result
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> usedVariables [
	"Return all entities in my subtree that have been resolved to local variable declarations.
	
	Once the LocalResolution has been done, this allows to find all variable nodes (declared in the model)."

	^ self query containedEntities recursively withProperty: #isResolvedVariable
]
