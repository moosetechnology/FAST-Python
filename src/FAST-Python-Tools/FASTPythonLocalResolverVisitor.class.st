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
	#category : 'FAST-Python-Tools-CFG/LocalResolver/SSA',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/LocalResolver/SSA'
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

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> resolve: aFASTBehaviouralEntity [

	scopes push: (FASTPythonLRScope for: aFASTBehaviouralEntity).

	"We fulsh the attributes in case this is not the fist resolution"
	aFASTBehaviouralEntity withAllContainedEntities do: [ :entity | entity resetLocalResolution ].

	aFASTBehaviouralEntity accept: self.
	scopes pop.
	self assert: scopes isEmpty
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

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyComprehension: aComprehension [
	"Reordering the visit of children to ensure for clauses are visited before the body and conditions since they can refer to it."

	"In Python 3, the comprehension has its own scope. In the future we should also manage python 2 that had no scope and could leek its variables."

	self useScope: (FASTPythonLRScope for: aComprehension) during: [
			self visitFASTPyTSplatExpression: aComprehension.
			self visitFASTPyExpression: aComprehension.

			self visitCollection: aComprehension forClauses.
			self visitCollection: aComprehension conditions.
			self visitEntity: aComprehension body ]
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

	anIdentifier isVariableWriteAccess ifTrue: [
		^ self ensureDeclarationOf: anIdentifier named: anIdentifier sourceCode declaration: anIdentifier variableDeclarator ].

	self bind: anIdentifier toDeclarationNamed: anIdentifier sourceCode
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

{ #category : 'visiting - reordering' }
FASTPythonLocalResolverVisitor >> visitFASTPyMethodDefinition: aMethodDefinition [
	"We resolve in the same way as functions."

	self visitFASTPyFunctionDefinition: aMethodDefinition
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
