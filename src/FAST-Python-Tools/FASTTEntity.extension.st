Extension { #name : 'FASTTEntity' }

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> isSameAsCFGCasePattern: aPattern [

	aPattern ifNil: [ ^ false ].

	aPattern isCollection ifTrue: [ ^ false ].

	^ self sourceCode = aPattern sourceCode
]
