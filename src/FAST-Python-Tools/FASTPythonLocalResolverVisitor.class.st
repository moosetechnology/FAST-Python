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
		'namesContext'
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
			               self
				               ensureDeclarationOf: aName
				               declaration: (FASTNonLocalDeclaration new
						                name: aName;
						                yourself)
				               in: namesContext first ].

	aFASTNode localDeclaration: declaration.
	declaration addLocalUse: aFASTNode
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> declarationNamed: aName [

	namesContext do: [ :scope | scope at: aName ifPresent: [ :declaration | ^ declaration ] ].

	^ nil
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> ensureDeclarationOf: aName declaration: aFASTNode in: scope [
	"If it is already present we do nothing. Else we create the local declaration.
	
	I just `ensure` that the local uses are initialized instead of reseting them as we do in other languages because in Python I have multiple variables that can be declared in the same assignment because of the tuples."

	^ scope
		  at: aName
		  ifPresent: [ :declaration |
				  declaration localResolverKind = aFASTNode localResolverKind
					  ifTrue: [ ^ declaration ]
					  ifFalse: [
							  declaration shadowedBy: aFASTNode.

							  "If the kind is different, we save a new declaration."
							  aFASTNode ensureLocalUses.
							  scope at: aName put: aFASTNode ] ]
		  ifAbsentPut: [
				  aFASTNode
					  ensureLocalUses;
					  yourself ]
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> ensureDeclarationOf: anEntity named: aName declaration: aFASTNode [

	self ensureDeclarationOf: aName declaration: aFASTNode in: namesContext top.
	self bind: anEntity toDeclarationNamed: aName
]

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> initialize [

	super initialize.
	namesContext := Stack new
]

{ #category : 'initialization' }
FASTPythonLocalResolverVisitor >> resolve: aFASTBehaviouralEntity [

	self useNewScopeDuring: [
			"We flush the attributes in case this is not the fist resolution"
			aFASTBehaviouralEntity withAllContainedEntities do: [ :entity | entity resetLocalResolution ].

			aFASTBehaviouralEntity accept: self ].
		
	self assert: namesContext isEmpty
]

{ #category : 'declarations' }
FASTPythonLocalResolverVisitor >> useNewScopeDuring: aBlock [

	namesContext push: Dictionary new.

	[ aBlock value ] ensure: [ namesContext pop ]
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyComprehension: aComprehension [
	"Reordering the visit of children to ensure for clauses are visited before the body and conditions since they can refer to it."

	"In Python 3, the comprehension has its own scope. In the future we should also manage python 2 that had no scope and could leek its variables."

	self useNewScopeDuring: [
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
	self useNewScopeDuring: [ "Cannot use super because the super method does not visit parameters before the block statement so we miss the parameters declerations before their usage."
			self visitFASTTWithParameters: aFunctionDefinition.
			self visitFASTPyTWithTypeParameters: aFunctionDefinition.
			self visitFASTPyStatement: aFunctionDefinition.
			self visitEntity: aFunctionDefinition returnType.
			self visitFASTPyTDefinition: aFunctionDefinition ]
]

{ #category : 'visiting - reordering' }
FASTPythonLocalResolverVisitor >> visitFASTPyIfStatement: anIfStatement [
	"Visit then - elif(s) -> else "

	self visitFASTTConditionalStatement: anIfStatement.
	self visitFASTPyStatement: anIfStatement.

	self visitEntity: anIfStatement thenClause.
	self visitCollection: anIfStatement elifClauses.
	self visitFASTPyTWithElseClause: anIfStatement
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyImport: anImport [

	anImport importedEntities do: [ :entity |
			entity hasAlias
				ifTrue: [ self ensureDeclarationOf: entity named: entity alias declaration: anImport ]
				ifFalse: [ self ensureDeclarationOf: entity named: entity sourceCode declaration: anImport ] ].

	super visitFASTPyImport: anImport
]

{ #category : 'visiting - reordering' }
FASTPythonLocalResolverVisitor >> visitFASTPyMethodDefinition: aMethodDefinition [
	"We resolve in the same way as functions."

	self visitFASTPyFunctionDefinition: aMethodDefinition
]

{ #category : 'visiting' }
FASTPythonLocalResolverVisitor >> visitFASTPyTCanBeVariable: aTCanBeVariable [
	"This has some limits. For example, 
	
	x.y.z = 3
	v = x.y
	print(v.z)
	
	Here v.z should be linked to the z variable but it will not. This case will not be managed for now but we might need it in the future.
	
	Or also subscripts are linked if their source code is identical only."

	aTCanBeVariable isVariableWriteAccess
		ifTrue: [ self ensureDeclarationOf: aTCanBeVariable named: aTCanBeVariable localDeclarationName declaration: aTCanBeVariable ]
		ifFalse: [ self bind: aTCanBeVariable toDeclarationNamed: aTCanBeVariable localDeclarationName ].

	super visitFASTPyTCanBeVariable: aTCanBeVariable
]

{ #category : 'visiting - reordering' }
FASTPythonLocalResolverVisitor >> visitFASTPyWhileStatement: aWhileStatement [

	"Else block should be visited after the other ones."
	self visitFASTTConditionalStatement: aWhileStatement.
	self visitFASTTStatementBlock: aWhileStatement.
	self visitFASTPyStatement: aWhileStatement.
	self visitFASTPyTWithElseClause: aWhileStatement
]
