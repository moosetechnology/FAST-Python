"
I am a visitor used to link variables usages to their declaration. 

You can run me like this:

```st
FASTPythonLocalResolverVisitor resolve: aModule ""could be any behavioral entity of a FASTPython model.""
```

Once I ran, all variables will be able to get their declaration via `#localDeclaration`. Also, a local declaration knows its `#localUses`. 

In this version, this works only for variables declared in the entity to resolve. It will not work for example if you import a global variable from another module because it is not possible to know if this is a variable or something else. 
"
Class {
	#name : 'FASTPythonLocalResolverVisitor',
	#superclass : 'FASTPythonVisitor',
	#instVars : [
		'scoper'
	],
	#category : 'FAST-Python-Tools-Utilities',
	#package : 'FAST-Python-Tools',
	#tag : 'Utilities'
}

{ #category : 'instance creation' }
FASTPythonLocalResolverVisitor class >> resolve: aPythonEntity [

	^ self new resolve: aPythonEntity
]

{ #category : 'instance creation' }
FASTPythonLocalResolverVisitor >> resolve: aFASTBehaviouralEntity [

	scoper := FASTLocalResolverScoping new.
	aFASTBehaviouralEntity accept: self
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyAssignment: anAssignment [

	anAssignment left isVariableEntity ifTrue: [
			scoper scopeAdd: anAssignment left name declaration: anAssignment.

			anAssignment left localDeclaration: anAssignment ].

	super visitFASTPyAssignment: anAssignment
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyIdentifier: anIdentifier [

	scoper bind: anIdentifier toLocalDeclaration: anIdentifier sourceCode
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyVariable: aVariable [

	"If I am on the left side of an assignation, no need to do anything, it's already done in my parent."
	aVariable parentAssignmentLeft ifNotNil: [ ^ self ].
	
	super visitFASTPyVariable: aVariable 
]
