Extension { #name : 'FASTTEntity' }

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> ensureLocalUses [

	self attributeAt: #localUses ifAbsentPut: OrderedCollection new
]

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> resetLocalResolution [

	self removeAttribute: #localDeclaration.
	self removeAttribute: #localUses
]
