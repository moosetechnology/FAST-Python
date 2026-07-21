"
I am a visitor used to link entities usages to their declaration. 

You can run me like this:

```st
FASTPythonLocalResolverVisitor resolve: aModule ""could be any behavioral entity of a FASTPython model.""
```

Once I ran, all entities will be able to get their declaration via `#localDeclaration`. Also, a local declaration knows its `#localUses`. 

The declaration can be various things:
- First variable assignement
- Function definition
- Variable declared in a loop structure (like in the left side of a for each)
- An imported entity
...
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

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> bind: aFASTNode toDeclarationNamed: aName [

	| declaration |
	declaration := (self declarationNamed: aName) ifNil: [ "If it is undeclared, we create an undeclared in the lowest scope in the stack."
			               scopes first ensureDeclarationOf: aName declaration: (FASTNonLocalDeclaration new
					                name: aName;
					                yourself) ].

	aFASTNode localDeclaration: declaration.
	declaration addLocalUse: aFASTNode
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> declarationNamed: aName [

	scopes do: [ :scope | scope declarationNamed: aName ifPresent: [ :declaration | ^ declaration ] ].
	^ nil
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> ensureDeclarationOf: anEntity named: aName declaration: aFASTNode [

	scopes top ensureDeclarationOf: aName declaration: aFASTNode.
	self bind: anEntity toDeclarationNamed: aName
]

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> initialize [

	super initialize.
	scopes := Stack new
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> isInTupleAssignment: anIdentifier [
	"I return true if my parent is a tuple on the left side of an assignment"

	anIdentifier collectionInitializer ifNil: [ ^ false ].

	anIdentifier collectionInitializer isTuple ifFalse: [ ^ false ].

	anIdentifier collectionInitializer parentAssignmentLeft ifNil: [ ^ false ].

	^ true
]

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> resolve: aFASTBehaviouralEntity [

	scopes push: ((aFASTBehaviouralEntity isClassDefinition
			  ifTrue: [ FASTPythonLRClassScope ]
			  ifFalse: [ FASTPythonLRScope ]) for: aFASTBehaviouralEntity).
			
	"We fulsh the attributes in case this is not the fist resolution"
	aFASTBehaviouralEntity withAllContainedEntities do: [ :entity | entity resetLocalResolution ].

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

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> useScope: aScope during: aBlock [

	scopes push: aScope.

	[ aBlock value ] ensure: [ scopes pop ]
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyAttributeAccess: anAttribute [
	"This should be improved later to check if we already encountered this accessed attribute and maybe this should go in the scopes?."

	| declaration |
	declaration := FASTNonLocalDeclaration new
		               name: anAttribute name;
		               yourself.

	declaration clearLocalUses.

	anAttribute localDeclaration: declaration.
	declaration addLocalUse: anAttribute.

	super visitFASTPyAttributeAccess: anAttribute
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

	self ensureDeclarationOf: aFunctionDefinition named: aFunctionDefinition name declaration: aFunctionDefinition.
	self
		useScope: (FASTPythonLRScope for: aFunctionDefinition)
		during: [ "Cannot use super because the super method does not visit parameters before the block statement so we miss the parameters declerations before their usage."
				self visitFASTTWithParameters: aFunctionDefinition.
				self visitFASTPyTWithTypeParameters: aFunctionDefinition.
				self visitFASTPyStatement: aFunctionDefinition.
				self visitEntity: aFunctionDefinition returnType.
				self visitFASTPyTDefinition: aFunctionDefinition ]
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyIdentifier: anIdentifier [

	| name |
	name := anIdentifier sourceCode.

	"I define a variable in a for statement. Thus I need to create a new declaration"
	anIdentifier parentForStatementLeft ifNotNil: [ :forStatement | ^ self ensureDeclarationOf: anIdentifier named: name declaration: forStatement ].

	"If I am in a tuple that is on the left side of an assignement, then I must declare a new variable"
	(self isInTupleAssignment: anIdentifier) ifTrue: [
		^ self ensureDeclarationOf: anIdentifier named: name declaration: anIdentifier collectionInitializer parentAssignmentLeft ].

	self bind: anIdentifier toDeclarationNamed: name
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyImport: anImport [

	anImport importedEntities do: [ :entity |
			entity hasAlias
				ifTrue: [ self ensureDeclarationOf: entity named: entity alias declaration: anImport ]
				ifFalse: [
						entity segments size = 1
							ifTrue: [ self ensureDeclarationOf: entity named: entity segments last declaration: anImport ]
							ifFalse: [ self flag: #todo "I don't know yet how to manage this" ] ] ].

	super visitFASTPyImport: anImport
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyParameter: aParameter [

	self ensureDeclarationOf: aParameter named: aParameter name declaration: aParameter.
	super visitFASTPyParameter: aParameter
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyVariable: aVariable [
	"We are declaring a variable in an assignation"

	aVariable parentAssignmentLeft ifNotNil: [ :assignment | ^ self ensureDeclarationOf: aVariable named: aVariable name declaration: assignment ].

	super visitFASTPyVariable: aVariable
]
