Extension { #name : 'FASTPyParameter' }

{ #category : '*FAST-Python-Tools' }
FASTPyParameter >> localResolverKind [
	"It was parameter at first, but parameters can be assigned so they act as variables."

	^ #variable
]

{ #category : '*FAST-Python-Tools' }
FASTPyParameter >> variableDeclarator [
	"For parameters, they are their own declarator."

	^ self
]
