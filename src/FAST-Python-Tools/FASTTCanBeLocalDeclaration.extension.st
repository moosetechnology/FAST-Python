Extension { #name : 'FASTTCanBeLocalDeclaration' }

{ #category : '*FAST-Python-Tools' }
FASTTCanBeLocalDeclaration >> ensureLocalUses [

	self attributeAt: #localUses ifAbsentPut: OrderedCollection new
]
