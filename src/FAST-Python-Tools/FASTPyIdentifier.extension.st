Extension { #name : 'FASTPyIdentifier' }

{ #category : '*FAST-Python-Tools' }
FASTPyIdentifier >> localResolverKind [

	self isVariableWriteAccess ifTrue: [ ^ #variable ].

	self halt
]
