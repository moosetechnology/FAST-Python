Extension { #name : 'MooseObject' }

{ #category : '*FAST-Python-ExtraTools' }
MooseObject >> mmSetProperty: aFM3PropertyDescription to: value [

	[ super mmSetProperty: aFM3PropertyDescription to: value ]
		on: MessageNotUnderstood
		do: [ :exception | "Do nothing for derived properties"
				aFM3PropertyDescription isDerived ifTrue: [ ^ self ].
				exception resume ]
]
