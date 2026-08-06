Extension { #name : 'FASTPyAttributeAccess' }

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment.
	
	I should be similar to the implementation of FASTPyIdentifier! We should check later to remove the duplication."

	| assignedNode |
	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"
	assignedNode := self.
	[ assignedNode collectionInitializer isNotNil and: [ assignedNode collectionInitializer isTuple ] ] whileTrue: [
		assignedNode := assignedNode collectionInitializer ].

	assignedNode parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	^ super variableDeclarator
]
