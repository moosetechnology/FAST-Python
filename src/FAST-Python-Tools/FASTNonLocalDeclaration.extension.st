Extension { #name : 'FASTNonLocalDeclaration' }

{ #category : '*FAST-Python-Tools' }
FASTNonLocalDeclaration >> activeVersion [

	^ self localUses first activeVersion
]
