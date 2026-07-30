Extension { #name : 'FASTPyForStatement' }

{ #category : '*FAST-Python-Tools' }
FASTPyForStatement >> localDeclarationName [

	^ left localDeclarationName
]

{ #category : '*FAST-Python-Tools' }
FASTPyForStatement >> localResolverKind [

	^ #variable
]
