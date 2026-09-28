Extension { #name : 'FASTPyEntity' }

{ #category : '*FAST-Python-ExtraTools' }
FASTPyEntity >> uniqueIdentifier [

	<FMProperty: #uniqueIdentifier type: #String>
	<FMComment: 'An ID that will not change compared to the moose ID. This is used for the Profile project.'>
	^ self attributeAt: #uniqueIdentifier ifAbsentPut: [ UUID new asString ]
]
