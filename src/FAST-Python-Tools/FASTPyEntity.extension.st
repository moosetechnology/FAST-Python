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
FASTPyEntity >> isInstanceVariableAccess [

	^ false
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> isVariableWriteAccess [
	"I am used in the LR and SSA builder to know if I represent the assignment of a variable."

	^ self variableDeclarator isNotNil
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
	
	Else, return myself."

	| node |
	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"
	node := self.
	[ node collectionInitializer isNotNil and: [ node collectionInitializer isTuple or: [ node collectionInitializer isList ] ] ] whileTrue: [
		node := node collectionInitializer ].

	^ node
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> variableDeclarator [
	"In case I am a write access to a variable, I return the node categorized as my declaration. Else I return nil.
	Nodes representing potential variable write access should override me.
	
	I am used by the LocalResolver and potentially SSA"

	^ nil
]
