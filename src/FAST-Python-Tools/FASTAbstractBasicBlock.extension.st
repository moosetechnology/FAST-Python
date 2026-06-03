Extension { #name : 'FASTAbstractBasicBlock' }

{ #category : '*FAST-Python-Tools' }
FASTAbstractBasicBlock >> withAllFollowingBlocks [

	^ self withDeep: #nextBlocks collect: #yourself
]
