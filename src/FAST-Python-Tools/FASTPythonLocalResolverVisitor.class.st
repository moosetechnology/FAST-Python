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
		'scopes'
	],
	#category : 'FAST-Python-Tools-LocalResolver',
	#package : 'FAST-Python-Tools',
	#tag : 'LocalResolver'
}

{ #category : 'instance creation' }
FASTPythonLocalResolverVisitor class >> resolve: aPythonEntity [

	^ self new resolve: aPythonEntity
]

{ #category : 'as yet unclassified' }
FASTPythonLocalResolverVisitor >> bind: aVariable toDeclarationNamed: aVariableName [

	| declaration |
	declaration := (self declarationNamed: aVariableName) ifNil: [ self error: 'Not yet implemented.' ].

	aVariable localDeclaration: declaration.
	declaration addLocalUse: aVariable
]

{ #category : 'as yet unclassified' }
FASTPythonLocalResolverVisitor >> declarationNamed: aVariableName [

	scopes do: [ :scope | scope declarationNamed: aVariableName ifPresent: [ :declaration | ^ declaration ] ].
	^ nil
]

{ #category : 'as yet unclassified' }
FASTPythonLocalResolverVisitor >> ensureDeclarationOf: aVariable named: aVariableName assignment: anAssignment [

	scopes top ensureDeclarationOf: aVariableName assignment: anAssignment.
	self bind: aVariable toDeclarationNamed: aVariableName
]

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> initialize [

	super initialize.
	scopes := Stack new
]

{ #category : 'instance creation' }
FASTPythonLocalResolverVisitor >> resolve: aFASTBehaviouralEntity [

	scopes push: ((aFASTBehaviouralEntity isClassDefinition
			  ifTrue: [ FASTPythonLRClassScope ]
			  ifFalse: [ FASTPythonLRScope ]) for: aFASTBehaviouralEntity).

	aFASTBehaviouralEntity accept: self.
	scopes pop.
	self assert: scopes isEmpty
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> shouldSkipIdentifier: anIdentifier [
	"In fact we could have a variable, but I'll manage it later.
	https://github.com/moosetechnology/FAST-Python/issues/20"

	self flag: #todo.
	anIdentifier caller ifNotNil: [ ^ true ].

	^ false
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
FASTPythonLocalResolverVisitor >> visitFASTPyFunctionDefinition: aFunctionDefinition [

	scopes push: (FASTPythonLRScope for: aFunctionDefinition).
	super visitFASTPyFunctionDefinition: aFunctionDefinition.
	scopes pop
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyIdentifier: anIdentifier [

	| name |
	(self shouldSkipIdentifier: anIdentifier) ifTrue: [ ^ self ].

	name := anIdentifier sourceCode.

	"I define a variable in a for statement. Thus I need to create a new declaration"
	anIdentifier parentForStatementLeft ifNotNil: [ :forStatement | ^ self ensureDeclarationOf: anIdentifier named: name assignment: forStatement ].

	self bind: anIdentifier toDeclarationNamed: name
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyParameter: aParameter [

	self ensureDeclarationOf: aParameter named: aParameter name assignment: aParameter.
	super visitFASTPyParameter: aParameter
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyVariable: aVariable [
	"We are declaring a variable in an assignation"

	aVariable parentAssignmentLeft ifNotNil: [ :assignment | ^ self ensureDeclarationOf: aVariable named: aVariable name assignment: assignment ].

	super visitFASTPyVariable: aVariable
]
