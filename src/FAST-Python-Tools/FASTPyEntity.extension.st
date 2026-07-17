Extension { #name : 'FASTPyEntity' }

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> cfg [

	^ FASTPythonCFGVisitor buildCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> fullCfg [

	^ FASTPythonCFGVisitor new buildFullCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> localResolverKind [
	"In the local resolver, if we redefine an entity with an entity of the same kind, we keep the same declaration. Else we create a new one. 
	
	I am used to know the kind of entity that is been declared."

	^ self subclassResponsibility
]
