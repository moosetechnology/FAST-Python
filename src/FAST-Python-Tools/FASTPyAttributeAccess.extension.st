Extension { #name : 'FASTPyAttributeAccess' }

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> localDeclarationName [

	^ self sourceCode
]

{ #category : '*FAST-Python-Tools' }
FASTPyAttributeAccess >> localResolverKind [

	^ #variable
]
