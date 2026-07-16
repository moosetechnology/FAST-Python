Extension { #name : 'FASTTEntity' }

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> hasLocalDeclaration [

	self attributeAt: #localDeclaration ifAbsent: [ ^ false ].

	^ true
]
