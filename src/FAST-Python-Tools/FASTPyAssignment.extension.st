Extension { #name : 'FASTPyAssignment' }

{ #category : '*FAST-Python-Tools' }
FASTPyAssignment >> isVariableAssignment [

	^ true
]

{ #category : '*FAST-Python-Tools' }
FASTPyAssignment >> localDeclarationName [

	^ left localDeclarationName
]

{ #category : '*FAST-Python-Tools' }
FASTPyAssignment >> localResolverKind [

	^ #variable
]
