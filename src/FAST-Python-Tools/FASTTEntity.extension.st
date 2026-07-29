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

{ #category : '*FAST-Python-Tools' }
FASTTEntity >> withLocalDeclarationDo: aBlock [
	"Used for LocalResolver"

	| declaration |
	self flag: #todo. "Move to FAST"
	declaration := self attributeAt: #localDeclaration.

	"Do nothing on non local declaration."
	declaration isNonLocalDeclaration ifTrue: [ ^ nil ].

	^ aBlock cull: declaration
]
