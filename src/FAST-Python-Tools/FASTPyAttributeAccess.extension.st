Extension { #name : 'FASTPyAttributeAccess' }

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> isInstanceVariableAccess [

	self methodDefinition ifNotNil: [ :method | ^ self value isIdentifier and: [ self value name = method selfName ] ].

	^ false
]

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> localDeclarationName [

	^ self sourceCode
]

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> methodDefinition [
	"In case I am inside a method definition, return this method."

	^ (self containersOfType: FASTPyMethodDefinition)
		  ifNotEmpty: [ :methods |
				  self assert: methods size = 1.
				  methods anyOne ]
		  ifEmpty: [ nil ]
]

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> variableDeclarator [
	"In the case I represent a write access to a variable, I return the node representing my assignment."

	"If I am a variable defined in tuples, I should return the node initializing this tuple. Can be recursive (tuple in tuple)"

	self selfOrTopmostAssignableCollection parentAssignmentLeft ifNotNil: [ :assignment | ^ assignment ].

	^ super variableDeclarator
]
