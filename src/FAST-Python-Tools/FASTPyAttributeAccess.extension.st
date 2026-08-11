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
