Extension { #name : 'FASTTEntity' }

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> resetLocalResolution [

	self removeAttribute: #localDeclaration.
	self removeAttribute: #localUses
]
