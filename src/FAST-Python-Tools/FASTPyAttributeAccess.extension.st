Extension { #name : 'FASTPyAttributeAccess' }

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> localDeclarationName [

	^ self sourceCode
]

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment."

	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"

	self selfOrTopmostAssignableCollection parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	^ super variableDeclarator
]
