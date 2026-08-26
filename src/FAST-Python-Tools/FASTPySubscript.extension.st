Extension { #name : 'FASTPySubscript' }

{ #category : '*FAST-Python-Tools' }
FASTPySubscript >> localDeclarationName [

	^ self sourceCode
]

{ #category : '*FAST-Python-Tools' }
FASTPySubscript >> localResolverKind [

	^ #subscript
]
