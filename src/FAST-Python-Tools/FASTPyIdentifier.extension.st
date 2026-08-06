Extension { #name : 'FASTPyIdentifier' }

{ #category : '*FAST-Python-Tools' }
FASTPyIdentifier >> localResolverKind [

	self isVariableWriteAccess ifTrue: [ ^ #variable ].

	self halt "I don't know if it can be something else."
]

{ #category : '*FAST-Python-Tools' }
FASTPyIdentifier >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment.
	
	I should be similar to the implementation of FASTPyAttributeAccess! We should check later to remove the duplication."

	| assignedNode |
	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"
	assignedNode := self.
	[ assignedNode collectionInitializer isNotNil and: [ assignedNode collectionInitializer isTuple ] ] whileTrue: [ assignedNode := assignedNode collectionInitializer ].

	assignedNode parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	assignedNode parentForStatementLeft ifNotNil: [ :for | ^ for ].

	assignedNode parentForInClauseLeft ifNotNil: [ :clause | ^ clause ].

	^ super variableDeclarator
]
