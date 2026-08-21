Extension { #name : 'FASTPyIdentifier' }

{ #category : '*FAST-Python-Tools' }
FASTPyIdentifier >> localResolverKind [

	self isVariableWriteAccess ifTrue: [ ^ #variable ].

	self halt "I don't know if it can be something else."
]
