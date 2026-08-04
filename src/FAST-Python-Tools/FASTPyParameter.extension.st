Extension { #name : 'FASTPyParameter' }

{ #category : '*FAST-Python-Tools' }
FASTPyParameter >> localResolverKind [

	^ #parameter
]

{ #category : '*FAST-Python-Tools' }
FASTPyParameter >> variableDeclarator [
	"For parameters, they are their own declarator."

	^ self
]
