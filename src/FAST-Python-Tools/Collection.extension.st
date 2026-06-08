Extension { #name : 'Collection' }

{ #category : '*FAST-Python-Tools' }
Collection >> isSameAsCFGCasePattern: aPattern [

	aPattern isCollection ifFalse: [ ^ false ].

	^ aPattern with: self do: [ :patternA :patternB | patternA isSameAsCFGCasePattern: patternB ]
]
