Extension { #name : 'FASTTEntity' }

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> resetLocalResolution [

	(self attributeAt: #localUses ifAbsent: [ nil ]) ifNotNil: [ :uses | uses removeAll ].
	self removeAttribute: #localDeclaration.
	self removeAttribute: #localUses
]
