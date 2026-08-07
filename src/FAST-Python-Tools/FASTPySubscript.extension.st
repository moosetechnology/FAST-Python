Extension { #name : 'FASTPySubscript' }

{ #category : '*FAST-Python-Tools' }
FASTPySubscript >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment."

	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"
	self selfOrTopmostTupleContainer parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	^ super variableDeclarator
]
