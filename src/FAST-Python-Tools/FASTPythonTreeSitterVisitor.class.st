Class {
	#name : 'FASTPythonTreeSitterVisitor',
	#superclass : 'TSFASTCustomizableVisitor',
	#category : 'FAST-Python-Tools-Importing',
	#package : 'FAST-Python-Tools',
	#tag : 'Importing'
}

{ #category : 'class initialization' }
FASTPythonTreeSitterVisitor class >> initialize [
	"For now we use the bleeding edge"

	TSLibrariesPython gitBranchToUse: 'master'
]

{ #category : 'private' }
FASTPythonTreeSitterVisitor >> handleBinaryOperator: aTSNode ofKind: aClass [

	| fastEntity |
	self onNextContextDo: [ :contextEntry |
			contextEntry
				add: 'leftOperand' asAliasOfField: 'left';
				add: 'rightOperand' asAliasOfField: 'right' ].

	fastEntity := self handleNode: aTSNode.
	
	"TreeSitter does not seems to manage operator. See: https://github.com/tree-sitter/tree-sitter-python/issues/328
	So I try to het this property manually."
	fastEntity operator: (fastEntity sourceText copyFrom: fastEntity leftOperand endPos + 1 to: fastEntity rightOperand startPos - 1) trim.

	^ fastEntity
]

{ #category : 'private' }
FASTPythonTreeSitterVisitor >> handleCollectionNode: aTSNode kind: aFASTClass [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #initializers ].

	^ self handleNode: aTSNode kind: aFASTClass
]

{ #category : 'private' }
FASTPythonTreeSitterVisitor >> handleParameterNode: aTSNode name: aString [

	| parameter |
	parameter := self handleNode: aTSNode kind: FASTPyParameter parentBlock: [ :entity | self topFastEntity addParameter: entity ].
	parameter name: aString.
	^ parameter
]

{ #category : 'initialization' }
FASTPythonTreeSitterVisitor >> initialize [

	super initialize.
	self languageName: 'Py'
]

{ #category : 'testing' }
FASTPythonTreeSitterVisitor >> isIdentifierAVariableInTheCurrentContext [
	"I am sure that an identifier is a variable in some cases:
	- It is directly in the left side of an assignation
	- It's in a global statement
	- It's in a non local statement"

	(context top field = #left and: [ context top isOfFASTType: FASTPyAssignment ]) ifTrue: [ ^ true ].

	^ (context top isOfFASTType: FASTPyGlobalStatement) or: [ context top isOfFASTType: FASTPyNonlocalStatement ]
]

{ #category : 'testing' }
FASTPythonTreeSitterVisitor >> isInParameter: aNode [

	| parent type |
	parent := aNode parent.
	type := parent type.


	(#( parameters lambda_parameters typed_parameter ) includes: type) ifTrue: [ ^ true ].

	^ (#( typed_default_parameter default_parameter ) includes: type) and: [ context top field ~= #defaultValue ]
]

{ #category : 'testing' }
FASTPythonTreeSitterVisitor >> shouldIdentifierSetNameProperty [

	({ FASTPyGenericType.  FASTPySplatType } anySatisfy: [ :class | context top isOfFASTType: class ]) ifTrue: [ ^ true ].
	
	(context top field = #attribute and: [ context top isOfFASTType: FASTPyAttributeAccess ]) ifTrue: [ ^ true ].

	^ context top field = #name and: [ context top isOfFASTType: FASTTNamedEntity ]
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitAliasedImport: aTSNode [
	"Nothing to do. The visit of my children will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitArgumentList: aTSNode [
	"We skip this node and visit the children directly."
	
	(self topFastEntity isOfType: FASTPyClassDefinition) ifTrue: [ self setTopFieldTo: 'superclasses' ].
	self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitAsPattern: aTSNode [

	aTSNode parent type = #case_pattern ifTrue: [
			"We are the alias of a case clause."
			| fastEntity children |
			children := aTSNode collectNamedChild.
			"This is ugly code because I skip the case_pattern but I don't have time to do better for now."
			fastEntity := children first collectNamedChild first accept: self.
			fastEntity parentCaseClause alias: (self sourceCodeOf: children second).
			^ fastEntity ].
		
	aTSNode parent type = #except_clause ifTrue: [
			"We are the alias of a except clause."
			| fastEntity children |
			children := aTSNode collectNamedChild.
			fastEntity := children first accept: self.
			fastEntity parentExceptClause alias: (self sourceCodeOf: children second).
			^ fastEntity ].

	self onNextContextDo: [ :entry |
			entry
				add: 'target' asAliasOfField: 'alias';
				aliasUnnamedFieldAs: 'source' ].

	^ self handleNode: aTSNode kind: FASTPyAsPattern
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitAsPatternTarget: aTSNode [
	"Nothing to do. The visit of my child will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitAssertStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expressions ].

	^ self handleNode: aTSNode kind: FASTPyAssertStatement
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitAttribute: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'value' asAliasOfField: 'object' ].

	^ self handleNode: aTSNode kind: FASTPyAttributeAccess
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitAugmentedAssignment: aTSNode [

	| fastEntity |

	fastEntity := self handleNode: aTSNode kind: FASTPyAugmentedAssignment.
	
	"TreeSitter does not seems to manage operator. See: https://github.com/tree-sitter/tree-sitter-python/issues/328
	So I try to het this property manually."
	fastEntity operator: (fastEntity sourceText copyFrom: fastEntity left endPos + 1 to: fastEntity right startPos - 1) trim.

	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitAwait: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aTSNode kind: FASTPyAwait
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitBinaryOperator: aTSNode [

	^ self handleBinaryOperator: aTSNode ofKind: FASTPyBinaryOperator
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitBlock: aTSNode [
	"I should be simplified a little bit when the importer will be stable."
	
	self onNextContextDo: [ :contextEntry | contextEntry aliasUnnamedFieldAs: 'statements' ].

	aTSNode parent type = #else_clause ifTrue: [
		^ self handleNode: aTSNode kind: FASTPyElseClause parentBlock: [ :entity | self topFastEntity elseClause: entity ] ].

	((context top isOfFASTType: FASTPyIfStatement) and: [ context top field = #consequence ]) ifTrue: [ ^ self handleNode: aTSNode kind: FASTPyThenClause ].

	self setTopFieldTo: #statements. "We manually update the field to bypass the block"
	^ self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitBooleanOperator: aTSNode [

	^ self handleBinaryOperator: aTSNode ofKind: FASTPyBooleanOperator
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitCall: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'callee' asAliasOfField: 'function' ].

	^ self handleNode: aTSNode kind: FASTPyCall
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitCaseClause: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'pattern' ].

	^ self handleNode: aTSNode kind: FASTPyCaseClause parentBlock: [ :entity | self topFastEntity addCase: entity ]
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitCasePattern: aTSNode [
	"We skip this node to put the content in the case_clause."

	^ self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitChevron: aTSNode [
	
	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aTSNode kind: FASTPyChevron parentBlock: [ :entity | self topFastEntity redirection: entity ]
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitClassDefinition: aNode [

	self onNextContextDo: [ :entry | entry add: 'statementBlock' asAliasOfField: 'body' ].

	^ self handleNode: aNode kind: FASTPyClassDefinition
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitClassPattern: aNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #elements ].

	^ self handleNode: aNode kind: FASTPyClassPattern
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitComment: aTSNode [

	^ self handleNode: aTSNode parentBlock: [ :entity | self topFastEntity addComment: entity ]
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitComparisonOperator: aTSNode [

	| fastEntity |
	self onNextContextDo: [ :contextEntry | contextEntry aliasUnnamedFieldAs: 'operands' ].

	fastEntity := self handleNode: aTSNode. "The node does not gives us the operators so we try to get them ourselves."
	fastEntity operators:
		(fastEntity operands overlappingPairsCollect: [ :operand1 :operand2 | (fastEntity sourceText copyFrom: operand1 endPos + 1 to: operand2 startPos - 1) trim ])
			asArray.

	^ fastEntity
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitComplexPattern: aTSNode [

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyBinaryOperator from: aTSNode.

	self setParentOf: fastEntity.

	self pushContext: fastEntity node: aTSNode during: [
			"The TS node has no field for this node but we have 2 concepts in the nodes: the left and the right."
			self setTopFieldTo: 'leftOperand'.
			(aTSNode namedChildAt: 1) accept: self.
			self setTopFieldTo: 'rightOperand'.
			(aTSNode namedChildAt: 2) accept: self ].
		
	fastEntity operator: (fastEntity sourceText copyFrom: fastEntity leftOperand endPos + 1 to: fastEntity rightOperand startPos - 1) trim.

	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitComprehension: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'forClauses' ].

	^ self handleNode: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitConcatenatedString: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #strings ].

	^ self handleNode: aTSNode kind: FASTPyConcatenatedString
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitConditionalExpression: aTSNode [

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyConditionalExpression from: aTSNode.

	self setParentOf: fastEntity.

	self
		pushContext: fastEntity
		node: aTSNode
		during: [ "The TS node has no field for this node but we have 3 concepts in the nodes: the first is the #thenExpression, the second the #condition and the third the #elseExpression. None is optional and in FAST we want to distinguish them. So we set a field by hand."
				self setTopFieldTo: 'thenExpression'.
				(aTSNode namedChildAt: 1) accept: self.
				self setTopFieldTo: 'condition'.
				(aTSNode namedChildAt: 2) accept: self.
				self setTopFieldTo: 'elseExpression'.
				(aTSNode namedChildAt: 3) accept: self ].

	^ fastEntity
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitConstrainedType: aTSNode [

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyConstrainedType from: aTSNode.

	self topFastEntity content: fastEntity.

	self pushContext: fastEntity node: aTSNode during: [
			"The TS node has no field for this node but we have 2 concepts in the nodes: the type and its bounds.."
			self setTopFieldTo: 'type'.
			(aTSNode namedChildAt: 1) accept: self.
			self setTopFieldTo: 'bound'.
			(aTSNode namedChildAt: 2) accept: self ].
		
	^ fastEntity
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDecoratedDefinition: aTSNode [
	"We do not wish to create a node for a decorated_definition. The node will always have an unnamed field containing the decorators and a definition field with the definition."

	| fastEntity definitionNode |
	definitionNode := aTSNode detectChildWithFieldName: 'definition'.
	fastEntity := definitionNode accept: self.

	self pushContext: fastEntity node: definitionNode during: [
			self setTopFieldTo: 'decorators'.
			(aTSNode collectFieldNameOfNamedChild at: '<unnamedChild>') asTSNodes do: [ :node | node accept: self ] ].

	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitDecorator: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aTSNode kind: FASTPyDecorator
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDefaultParameter: aTSNode [

	| children parameter |
	children := aTSNode collectNamedChild.
	parameter := children first accept: self.
	
	"We want the positions of the full parameter."
	parameter startPos: (self characterPositionAtByte: aTSNode startByte) + 1.
	parameter endPos: (self characterPositionAtByte: aTSNode endByte).

	self pushContext: parameter node: aTSNode during: [
			self setTopFieldTo: 'defaultValue'.
			children second accept: self ].

	^ parameter
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitDeleteStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aTSNode kind: FASTPyDeleteStatement
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDictPattern: aTSNode [
	"We do not want something specific for dict pattern, we just want to create a dictionary."

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyDictionary from: aTSNode.
	self setParentOf: fastEntity.

	self pushContext: fastEntity node: aTSNode during: [
			| children |
			children := aTSNode collectFieldNameOfNamedChild.
			self setTopFieldTo: 'initializers'.
			children at: #key ifPresent: [ :keys |
					children at: #value ifPresent: [ :values |
							keys asTSNodes with: values asTSNodes do: [ :key :value |
									| pair |
									pair := self instantiateFastEntity: FASTPyPair from: key.
									pair endPos: (self characterPositionAtByte: value endByte).
									fastEntity addInitializer: pair.
									self pushContext: pair node: key during: [
											self setTopFieldTo: 'key'.
											key accept: self.
											self setTopFieldTo: 'value'.
											value accept: self ] ] ] ].
			children at: '<unnamedChild>' ifPresent: [ :splats | splats asTSNodes do: [ :node | node accept: self ] ] ].

	^ fastEntity
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDictionary: aTSNode [

	^ self handleCollectionNode: aTSNode kind: FASTPyDictionary
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDictionaryComprehension: aTSNode [

	^ self visitComprehension: aTSNode
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitDictionarySplat: aTSNode [
	"Treat both splat the same way."

	^ self visitListSplat: aTSNode
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitDictionarySplatPattern: aTSNode [
	"Handle both nodes the same."

	^ self visitListSplatPattern: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitDottedName: aTSNode [

	| fastEntity |

	"In case it is in the `name` field of an import, we create an ImportedEntity."
	(context anySatisfy: [ :entry | entry field = #name and: [ entry isOfFASTType: FASTPyImport ] ]) ifTrue: [
			"For the souce anchor, if the parent is an alias, we want to include it in the imported entity source."
			fastEntity := self instantiateFastEntity: FASTPyImportedEntity from: (aTSNode parent type = #aliased_import
					               ifTrue: [ aTSNode parent ]
					               ifFalse: [ aTSNode ]).
			self topFastEntity addImportedEntity: fastEntity.
			
			"Instead of saving a collection of FASTPyIdentifier, we save in a property the segments of the imported entity."
			fastEntity segments: (aTSNode namedChildren collect: [ :child | self sourceCodeOf: child ]).
			^ fastEntity ].
		
	"In a relative import, I add my parts in the list of segments."
	(aTSNode parent type = #relative_import) ifTrue: [  ^ self topFastEntity fromModule addSegments: ((self sourceCodeOf: aTSNode) splitOn: $.) ].
	
	"In case it is in the `module_name` field of an import, we create a FromImportModule."
	(context anySatisfy: [ :entry | (entry isOfFASTType: FASTPyImportFromStatement) and: [ entry field = #module_name ] ]) ifTrue: [
			"For the souce anchor, if the parent is an alias, we want to include it in the imported entity source."
			fastEntity := self instantiateFastEntity: FASTPyFromModule from: aTSNode.
			self topFastEntity fromModule: fastEntity.
			
			"Instead of saving a collection of FASTPyIdentifier, we save in a property the segments of the imported entity."
			fastEntity segments: (aTSNode namedChildren collect: [ :child | self sourceCodeOf: child ]).
			^ fastEntity ].
		
	"In the general case, I do not create children nodes. Only having a collection of the names is enought I think."
	fastEntity := self instantiateFastEntity: FASTPyDottedName from: aTSNode.
	self setParentOf: fastEntity.
	fastEntity identifiers: (aTSNode namedChildren collect: [ :child | self sourceCodeOf: child ]).

	^ fastEntity 
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitElifClause: aTSNode [

	^ self handleNode: aTSNode kind: FASTPyElifClause parentBlock: [ :entity | self topFastEntity addElifClause: entity ]
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitElseClause: aTSNode [

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting - error' }
FASTPythonTreeSitterVisitor >> visitEscapedInterpolation: aTSNode [

	self error: 'We sould never finish here because we took the decision of not representing them and the node visit should be skipped in #visitStringContent:.'
]

{ #category : 'visiting - error' }
FASTPythonTreeSitterVisitor >> visitEscapedSequence: aTSNode [

	self error: 'We sould never finish here because we took the decision of not representing them and the node visit should be skipped in #visitStringContent:.'
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitExceptClause: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'expression' asAliasOfField: 'value' ].

	^ self handleNode: aTSNode kind: FASTPyExceptClause parentBlock: [ :entity | self topFastEntity addExcept: entity ]
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitExecStatement: aNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #scopes ].

	^ self handleNode: aNode kind: FASTPyExecStatement
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitExpressionList: aTSNode [
	"We considere expression lists are tuples."

	^ self visitTuple: aTSNode
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitExpressionStatement: aTSNode [
	"HERE FOR COMPATIBILITY!
	
	Tree Sitter python changed its tree in this commit: https://github.com/tree-sitter/tree-sitter-python/commit/26855eabccb19c6abf499fbc5b8dc7cc9ab8bc64
	
	I am here for compatibility with versions of TS python before this commit. I can be dropped in the future once nobody will use this older TS python version."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitFalse: aNode [

	^ self handleNode: aNode kind: FASTPyBoolean
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitFinallyClause: aTSNode [

	^ self handleNode: aTSNode kind: FASTPyFinallyClause parentBlock: [ :entity | self topFastEntity finally: entity ]
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitFormatSpecifier: aTSNode [

	^ self topFastEntity formatSpecifier: (self sourceCodeOf: aTSNode) allButFirst "We skip the $: character"
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitFunctionDefinition: aNode [
	"TreeSitter has the same nodes for method and function definitions but in FAST we want to disambiguate."

	self onNextContextDo: [ :contextEntry |
			contextEntry
				add: 'statementBlock' asAliasOfField: 'body';
				add: 'returnType' asAliasOfField: 'return_type' ].

	^ (context anySatisfy: [ :entry | entry fastEntity isClassDefinition ])
		  ifTrue: [ self handleNode: aNode kind: FASTPyMethodDefinition ]
		  ifFalse: [ self handleNode: aNode kind: FASTPyFunctionDefinition ]
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitFutureImportStatement: aTSNode [
	"We treat future import as an import from statement"

	| fastEntity |
	fastEntity := self visitImportFromStatement: aTSNode.

	fastEntity fromModule: ((self instantiateFastEntity: FASTPyFromModule from: aTSNode)
			 segments: { '__future__' };
			 yourself).

	^ fastEntity
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitGeneratorExpression: aTSNode [

	^ self visitComprehension: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitGenericType: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #typeConstructor ].

	^ self handleNode: aTSNode kind: FASTPyGenericType
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitGlobalStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'variables' ].

	^ self handleNode: aTSNode kind: FASTPyGlobalStatement
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitIdentifier: aNode [

	| name |
	name := self sourceCodeOf: aNode.

	(self isInParameter: aNode) ifTrue: [ ^ self handleParameterNode: aNode name: name ].

	"If we are in a field `name` then we are probably in a definition of an entity and we set my content as a name."
	self shouldIdentifierSetNameProperty ifTrue: [ ^ self topFastEntity name: name ].

	self isIdentifierAVariableInTheCurrentContext ifTrue: [
			| variable |
			variable := self handleNode: aNode kind: FASTPyVariable.
			variable name: name.
			^ variable ].

	"In case we are in an alias, we edit the property alias of the last imported entity"
	aNode parent type = #aliased_import ifTrue: [ ^ self topFastEntity importedEntities last alias: name ].

	^ (self handleNode: aNode)
		  name: name;
		  yourself
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitIfClause: aTSNode [
	"The condition always goes in the condition property."

	| oldField |
	oldField := context top field.
	self setTopFieldTo: ((context top isOfFASTType: FASTPyComprehension)
			 ifTrue: [ 'conditions' ]
			 ifFalse: [ 'condition' ]).
	self rawVisitChildren: aTSNode.
	self setTopFieldTo: oldField
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitIfStatement: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'thenClause' asAliasOfField: 'consequence' ].

	^ self handleNode: aTSNode kind: FASTPyIfStatement
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitImportFromStatement: aTSNode [

	self onNextContextDo: [ :entry |
			entry
				add: 'importedEntities' asAliasOfField: 'name';
				add: 'fromModule' asAliasOfField: 'module_name' ].

	^ self handleNode: aTSNode kind: FASTPyImportFromStatement
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitImportPrefix: aTSNode [

	| fastEntity |
	fastEntity := self handleNode: aTSNode kind: FASTPyFromModule.
	fastEntity segments: { (self sourceCodeOf: aTSNode) }.
	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitImportStatement: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'importedEntities' asAliasOfField: 'name' ].

	^ self handleNode: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitInteger: aTSNode [
	"In python we have integers and complex numbers.
	A Complex ends with a j"

	^ self handleNode: aTSNode kind: ((self sourceCodeOf: aTSNode) last isLetter
			   ifTrue: [ FASTPyComplex ]
			   ifFalse: [ FASTPyInteger ])
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitKeywordArgument: aTSNode [

	"In class definition we want to separate keyword because they affect the metaclass while other arguments affects the superclasses."
	(self topFastEntity isOfType: FASTPyClassDefinition) ifTrue: [ self setTopFieldTo: 'keywords' ].

	^ self handleNode: aTSNode kind: FASTPyKeywordArgument
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitKeywordPattern: aTSNode [

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyKeywordPattern from: aTSNode.

	self setParentOf: fastEntity.

	self pushContext: fastEntity node: aTSNode during: [
			| children |
			children := aTSNode collectNamedChild.
			fastEntity name: (self sourceCodeOf: children first).
			self setTopFieldTo: 'value'.
			children second accept: self ].

	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitLambda: aTSNode [

	self onNextContextDo: [ :entry | entry add: 'expression' asAliasOfField: 'body' ].

	^ self handleNode: aTSNode kind: FASTPyLambda
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitLambdaParameters: aNode [

	^ self visitParameters: aNode
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitLineContinuation: aTSNode [
	"We do not represent that in FAST, at least for the moment. So I skip this node and act as if the children were in my parent."

	^ self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitList: aTSNode [

	^ self handleCollectionNode: aTSNode kind: FASTPyList
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitListComprehension: aTSNode [

	^ self visitComprehension: aTSNode
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitListPattern: aTSNode [

	^ self visitList: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitListSplat: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'expression' ].

	^ self handleNode: aTSNode kind: FASTPySplat
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitListSplatPattern: aTSNode [
	"In case we are a parameter we skip the children because it always is an identifier"

	(self isInParameter: aTSNode) ifTrue: [
			| fastEntity |
			fastEntity := self instantiateFastEntity: FASTPySplatParameter from: aTSNode.
			self topFastEntity addParameter: fastEntity.
			fastEntity name: (self sourceCodeOf: aTSNode collectNamedChild anyOne).
			^ fastEntity ].

	^ self handleNode: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitMemberType: aTSNode [

	self error: 'Cyril: I have no idea how we can have this node? If you end up here, please open an issue with your file or a snippet to parse to end up here!'
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitModule: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'statements' ].

	^ self handleNode: aTSNode kind: FASTPyModule
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitNamedExpression: aTSNode [

	^ self handleNode: aTSNode kind: FASTPyWalrus
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitNonlocalStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'variables' ].

	^ self handleNode: aTSNode kind: FASTPyNonlocalStatement
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitParameters: aNode [
	"For parameters we want one by parameter. Not one node for multiple ones."

	^ self rawVisitChildren: aNode
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitParenthesizedExpression: aTSNode [
	"We do not represent that in FAST, at least for the moment. So I skip this node and act as if the children were in my parent."

	^ self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitParenthesizedListSplat: aTSNode [

	self error: 'Cyril: I have no idea how we can have this node? If you end up here, please open an issue with your file or a snippet to parse to end up here!'
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitPatternList: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'initializers' ].

	^ self handleNode: aTSNode kind: FASTPyTuple
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitPrintStatement: aTSNode [

	self onNextContextDo: [ :entry | entry add: #expressions asAliasOfField: 'argument' ].

	^ self handleNode: aTSNode kind: FASTPyPrintStatement
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitRaiseStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #exception ].

	^ self handleNode: aTSNode kind: FASTPyRaiseStatement
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitRelativeImport: aTSNode [
	"Nothing to do. The visit of my children will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitReturnStatement: aTSNode [

	^ self visitStatement: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitSet: aTSNode [

	^ self handleCollectionNode: aTSNode kind: FASTPySet
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitSetComprehension: aTSNode [

	^ self visitComprehension: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitSlice: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'components' ].

	^ self handleNode: aTSNode kind: FASTPySlice
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitSplatPattern: aTSNode [

	^ ((self sourceCodeOf: aTSNode) beginsWith: '**')
		  ifTrue: [ self visitDictionarySplat: aTSNode ]
		  ifFalse: [ self visitListSplat: aTSNode ]
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitString: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #interpolations ].

	^ self handleNode: aTSNode kind: FASTPyString
]

{ #category : 'visiting - noop' }
FASTPythonTreeSitterVisitor >> visitStringContent: aNode [
	"We only want one node for the string, my parent."

	
]

{ #category : 'visiting - noop' }
FASTPythonTreeSitterVisitor >> visitStringEnd: aNode [
	"We only want one node for the string, my parent."

	
]

{ #category : 'visiting - noop' }
FASTPythonTreeSitterVisitor >> visitStringStart: aNode [
	"We only want one node for the string, my parent."

	
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitSubscript: aTSNode [

	self onNextContextDo: [ :entry | entry add: #indices asAliasOfField: 'subscript' ].

	^ self handleNode: aTSNode kind: FASTPySubscript
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitTrue: aNode [

	^ self handleNode: aNode kind: FASTPyBoolean
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitTuple: aTSNode [

	^ self handleCollectionNode: aTSNode kind: FASTPyTuple
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitTupleExpression: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #initializers ].

	^ self handleNode: aTSNode kind: FASTPyTuple
]

{ #category : 'visiting - redirect' }
FASTPythonTreeSitterVisitor >> visitTuplePattern: aTSNode [

	^ self visitTuple: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitType: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #content ].

	^ self handleNode: aTSNode kind: FASTPyType
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitTypeConversion: aTSNode [

	^ self topFastEntity typeConversion: (self sourceCodeOf: aTSNode) allButFirst "We skip the $! character"
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitTypeParameter: aTSNode [
	"Nothing to do. The visit of my child will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self setTopFieldTo: 'typeParameters'.
	self rawVisitChildren: aTSNode
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitTypedDefaultParameter: aTSNode [

	| children parameter |
	children := aTSNode collectNamedChild.
	parameter := children first accept: self.
	
	"We want the positions of the full parameter."
	parameter startPos: (self characterPositionAtByte: aTSNode startByte) + 1.
	parameter endPos: (self characterPositionAtByte: aTSNode endByte).

	self pushContext: parameter node: aTSNode during: [
			self setTopFieldTo: 'type'.
			children second accept: self.
			self setTopFieldTo: 'defaultValue'.
			children third accept: self ].

	^ parameter
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitTypedParameter: aTSNode [

	| children parameter |
	children := aTSNode collectNamedChild.
	parameter := children first accept: self.
	
	"We want the positions of the full parameter."
	parameter startPos: (self characterPositionAtByte: aTSNode startByte) + 1.
	parameter endPos: (self characterPositionAtByte: aTSNode endByte).

	self pushContext: parameter node: aTSNode during: [
			self setTopFieldTo: 'type'.
			children second accept: self ].

	^ parameter
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitUnaryOperator: aTSNode [

	| fastEntity |
	fastEntity := self handleNode: aTSNode.
	
	"TreeSitter does not seems to manage operator. See: https://github.com/tree-sitter/tree-sitter-python/issues/328"
	fastEntity operator: (fastEntity sourceText copyFrom: fastEntity startPos to: fastEntity argument startPos - 1) trim.

	^ fastEntity
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitUnionPattern: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #members ].

	^ self handleNode: aTSNode kind: FASTPyUnionPattern
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitUnionType: aTSNode [

	"If we have union types in union types, we want to flatten them in only one node. But the implementation might need to change depending on this issue: https://github.com/tree-sitter/tree-sitter-python/issues/334"
	(self topFastEntity isOfType: FASTPyUnionType) ifTrue: [ ^ self rawVisitChildren: aTSNode ].

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #types ].

	^ self handleNode: aTSNode kind: FASTPyUnionType
]

{ #category : 'visiting' }
FASTPythonTreeSitterVisitor >> visitWildcardImport: aTSNode [

	| fastEntity |
	fastEntity := self instantiateFastEntity: FASTPyImportedEntity from: aTSNode.
	self topFastEntity addImportedEntity: fastEntity.
	fastEntity segments: { '*' }.
	^ fastEntity
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitWithClause: aTSNode [
	"Nothing to do. The visit of my child will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting - skip' }
FASTPythonTreeSitterVisitor >> visitWithItem: aTSNode [
	"Nothing to do. The visit of my child will take care of things. I use the #raw version since it is what should be used to skip a context level."

	self rawVisitChildren: aTSNode
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitWithStatement: aTSNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: 'items' ].

	^ self handleNode: aTSNode kind: FASTPyWithStatement
]

{ #category : 'visiting - alias' }
FASTPythonTreeSitterVisitor >> visitYield: aNode [

	self onNextContextDo: [ :entry | entry aliasUnnamedFieldAs: #expression ].

	^ self handleNode: aNode kind: FASTPyYield
]
