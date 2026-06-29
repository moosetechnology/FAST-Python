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

{ #category : 'visiting - reordering' }
FASTPythonLocalResolverVisitor >> visitFASTPyForStatement: aForStatement [
	"Reorginizing the order"

	self visitEntity: aForStatement left.
	self visitEntity: aForStatement right.

	self visitFASTPyTWithElseClause: aForStatement.
	self visitFASTTStatementBlock: aForStatement.
	self visitFASTPyStatement: aForStatement
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyIdentifier: anIdentifier [

	| name |
	name := anIdentifier sourceCode.

	"I define a variable in a for statement. Thus I need to create a new declaration"
	anIdentifier parentForStatementLeft ifNotNil: [ :forStatement |
			scoper scopeAdd: name declaration: forStatement.
			anIdentifier localDeclaration: forStatement ].

	scoper bind: anIdentifier toLocalDeclaration: name
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyVariable: aVariable [

	"We are declaring a variable in an assignation"
	aVariable parentAssignmentLeft ifNotNil: [ :assignment |
			[
				scoper scopeAdd: aVariable name declaration: assignment.
				aVariable localDeclaration: assignment ]
				on: DuplicatedVariableError
				do: [ "Do nothing on the second declaration." ] ].

	super visitFASTPyVariable: aVariable
]
