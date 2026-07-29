Extension { #name : 'FASTPyAssignment' }

{ #category : '*FAST-Python-Tools' }
FASTPyAssignment >> isVariableAssignment [

	^ true
]

{ #category : '*FAST-Python-Tools' }
FASTPyAssignment >> localResolverKind [

	^ #variable
]
