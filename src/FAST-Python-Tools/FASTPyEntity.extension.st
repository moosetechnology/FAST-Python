Extension { #name : 'FASTPyEntity' }

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> cfg [

	^ FASTPythonCFGVisitor buildCFGOf: self
]

{ #category : '*FAST-Python-Tools' }
FASTPyEntity >> fullCfg [

	^ FASTPythonCFGVisitor new buildFullCFGOf: self
]
