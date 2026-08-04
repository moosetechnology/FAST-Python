"
## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |
| `parentAsPatternTarget` | `FASTPyTAsPatternTarget` | `target` | `FASTPyAsPattern` | |
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |
| `parentDeleteStatement` | `FASTPyTDeletable` | `expression` | `FASTPyDeleteStatement` | The delete statement that own the expression (if it's the case)|



"
Class {
	#name : 'FASTPyTuple',
	#superclass : 'FASTPyCollectionInitializer',
	#traits : 'FASTPyTAsPatternTarget + FASTPyTAssignable + FASTPyTDeletable',
	#classTraits : 'FASTPyTAsPatternTarget classTrait + FASTPyTAssignable classTrait + FASTPyTDeletable classTrait',
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyTuple class >> annotation [

	<FMClass: #Tuple super: #FASTPyCollectionInitializer>
	<package: #'FAST-Python-Model'>
	<generated>
]
