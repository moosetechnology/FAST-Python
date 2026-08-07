Class {
	#name : 'FASTPythonMetamodelGenerator',
	#superclass : 'FamixMetamodelGenerator',
	#instVars : [
		'entity',
		'_ERROR',
		'tEntity',
		'asPattern',
		'assertStatement',
		'assignment',
		'attribute',
		'augmentedAssignment',
		'await',
		'binaryOperator',
		'booleanOperator',
		'breakStatement',
		'call',
		'caseClause',
		'chevron',
		'classDefinition',
		'classPattern',
		'comment',
		'comparisonOperator',
		'complexPattern',
		'concatenatedString',
		'conditionalExpression',
		'constrainedType',
		'continueStatement',
		'decorator',
		'deleteStatement',
		'dictPattern',
		'dictionary',
		'dictionaryComprehension',
		'dottedName',
		'elifClause',
		'ellipsis',
		'elseClause',
		'escapeInterpolation',
		'escapeSequence',
		'exceptClause',
		'execStatement',
		'finallyClause',
		'float',
		'forInClause',
		'forStatement',
		'formatExpression',
		'functionDefinition',
		'generatorExpression',
		'genericType',
		'globalStatement',
		'identifier',
		'ifClause',
		'ifStatement',
		'importFromStatement',
		'importStatement',
		'integer',
		'interpolation',
		'keywordArgument',
		'keywordPattern',
		'keywordSeparator',
		'lambda',
		'lambdaParameters',
		'list',
		'listComprehension',
		'listPattern',
		'matchStatement',
		'memberType',
		'module',
		'namedExpression',
		'none',
		'nonlocalStatement',
		'notOperator',
		'pair',
		'parameter',
		'parenthesizedListSplat',
		'passStatement',
		'patternList',
		'positionalSeparator',
		'printStatement',
		'raiseStatement',
		'returnStatement',
		'set',
		'setComprehension',
		'slice',
		'splatType',
		'string',
		'subscript',
		'tryStatement',
		'tuple',
		'type',
		'typeAliasStatement',
		'typeConversion',
		'unaryOperator',
		'unionPattern',
		'unionType',
		'whileStatement',
		'withStatement',
		'yield',
		'tComment',
		'tNamedBehaviouralEntity',
		'tNamedEntity',
		'tVariableEntity',
		'methodDefinition',
		'boolean',
		'tStringLiteral',
		'tBooleanLiteral',
		'literal',
		'tLiteral',
		'tExpression',
		'expression',
		'tBinaryExpression',
		'operator',
		'tUnaryOperator',
		'tAssignment',
		'variable',
		'import',
		'importedEntity',
		'fromModule',
		'tInvocation',
		'tStatementBlock',
		'tReturnStatement',
		'tStatement',
		'collectionInitializer',
		'tConditionalStatement',
		'complex',
		'thenClause',
		'statement',
		'tWithStatements',
		'tNumericalLiteral',
		'tWithCondition',
		'tWithParameters',
		'tDefinition',
		'tDecoratorExpression',
		'tWithElseClause',
		'tWithComment',
		'tAsPatternTarget',
		'tAsPatternSource',
		'tWithStatementItem',
		'tRaised',
		'tAssignable',
		'tReturnReferenceable',
		'tSplatExpression',
		'tSplatParameterTarget',
		'tPattern',
		'tClassPatternElement',
		'tUnionMember',
		'tDeletable',
		'tTypeContent',
		'typeParameter',
		'tWithTypeParameters',
		'splat',
		'splatParameter',
		'comprehension',
		'tSuperclass',
		'tCallable',
		'tSliceIndex',
		'tAwaitable',
		'tExecutable',
		'tBreakStatement',
		'tContinueStatement',
		'tCanBeVariable'
	],
	#category : 'FAST-Python-Model-Generator',
	#package : 'FAST-Python-Model-Generator'
}

{ #category : 'accessing' }
FASTPythonMetamodelGenerator class >> metamodelToolGenerators [

	^ { FamixVisitorGenerator }
]

{ #category : 'accessing' }
FASTPythonMetamodelGenerator class >> packageName [

	^ #'FAST-Python-Model'
]

{ #category : 'accessing' }
FASTPythonMetamodelGenerator class >> prefix [

	^ #FASTPy
]

{ #category : 'accessing' }
FASTPythonMetamodelGenerator class >> submetamodels [

	^ { FASTMetamodelGenerator }
]

{ #category : 'definition' }
FASTPythonMetamodelGenerator >> defineClasses [

	super defineClasses.
	entity := builder newClassNamed: #Entity.

	_ERROR := builder newClassNamed: #ERROR.

	(asPattern := builder newClassNamed: #AsPattern) comment:
		'I represent the aliasing of an expression in Python. When the expression can only be an identifier, I store it as a property named "alias" instead of instantiating an AsPattern node.'.

	(assertStatement := builder newClassNamed: #AssertStatement) comment:
		'I represent an assert statement node in python. It hold a collection of expressions to assert.'.

	(assignment := builder newClassNamed: #Assignment) comment:
		'I represent an assignment in Python (not to confuse with an augmented assignment or a wlrus assignment). My left value is the expression used to get the variable to assign. It can be typed optionally. My right side if the expression to store. It can be optional because I also represent a typed variable declaration.'.

	(attribute := builder newClassNamed: #AttributeAccess) comment: 'I represent an access to an attribute such as `module.globalVariable`.'.

	(augmentedAssignment := builder newClassNamed: #AugmentedAssignment) comment:
		'An augmented assignment is an assignment done using operands such as `+=` or `-=`. It is a specialization of normal assignments.'.

	(await := builder newClassNamed: #Await) comment: 'I represent the usage of an await keyword in an asynchronous function definition'.

	binaryOperator := builder newClassNamed: #BinaryOperator.

	boolean := builder newClassNamed: #Boolean.

	booleanOperator := builder newClassNamed: #BooleanOperator.

	(breakStatement := builder newClassNamed: #BreakStatement) comment: 'I represent a break statement used to break loops.'.

	(call := builder newClassNamed: #Call) comment: 'I represent a call in python. The call can represent multiple things such as:
- a function invocation such as `flush(var)`
- a method invocation such as `self.increment()`
- a class instantiation such as Stack()'.

	(caseClause := builder newClassNamed: #CaseClause) comment: 'I represent a case clause in a match statement in Python.'.

	(chevron := builder newClassNamed: #Chevron) comment:
		'I am a node representing the `>>` part of a print statement. Print statement is only available in Python 2, not Python 3'.

	(classDefinition := builder newClassNamed: #ClassDefinition) comment:
		'I represent a class definition. I have a name, a list of expressions to declare my superclasses, a list of keywords to customize the metaclass and a block of code.'.
	classDefinition withTesting.

	(classPattern := builder newClassNamed: #ClassPattern) comment: 'A class pattern is used in a case clause to match classes.'.

	(collectionInitializer := builder newClassNamed: #CollectionInitializer) comment:
		'I am an abstract class to represent collection initializers in Python. I should be transformed into a trait to put in FAST directly.'.

	comment := builder newClassNamed: #Comment.

	comparisonOperator := builder newClassNamed: #ComparisonOperator.

	(comprehension := builder newAbstractClassNamed: #Comprehension) comment:
		'I am an abstract class for comprehensions. Comprehensions are a structure in python to generate some collections or a generator.'.

	(complex := builder newClassNamed: #Complex) comment: 'I represent a complex number such as `2j`'.

	concatenatedString := builder newClassNamed: #ConcatenatedString.

	(conditionalExpression := builder newClassNamed: #ConditionalExpression) comment: 'I represent a conditional expression such as `x if x > 2 else y`'.

	(constrainedType := builder newClassNamed: #ConstrainedType) comment:
		'I represent the concretization of a generic type in a given context. For example: `def f[T: int](): pass`, we are here constraining `T` to be an `int` or a subclass of `int`'.

	(continueStatement := builder newClassNamed: #ContinueStatement) comment: 'I represent a continue statement to use in loops.'.

	(decorator := builder newClassNamed: #Decorator) comment:
		'I represent a decorator in Python. I can be applied to class, function or method definition using the `@` symbol.'.

	(deleteStatement := builder newClassNamed: #DeleteStatement) comment: 'I represent a delete statement in Python.'.

	(dictionary := builder newClassNamed: #Dictionary) comment:
		'I represent the initialization of a new dictionnary in Python. Each of my children should be instances of Pair.'.

	dictionaryComprehension := builder newClassNamed: #DictionaryComprehension.

	(dottedName := builder newClassNamed: #DottedName) comment: 'I have a syntax close to attribute accesses but I am used only in match statements.'.

	elifClause := builder newClassNamed: #ElifClause.
	ellipsis := builder newClassNamed: #Ellipsis.
	elseClause := builder newClassNamed: #ElseClause.
	escapeInterpolation := builder newClassNamed: #EscapeInterpolation.
	escapeSequence := builder newClassNamed: #EscapeSequence.
	exceptClause := builder newClassNamed: #ExceptClause.
	execStatement := builder newClassNamed: #ExecStatement.
	expression := builder newAbstractClassNamed: #Expression.
	finallyClause := builder newClassNamed: #FinallyClause.
	float := builder newClassNamed: #Float.
	forInClause := builder newClassNamed: #ForInClause.
	forStatement := builder newClassNamed: #ForStatement.
	formatExpression := builder newClassNamed: #FormatExpression.
	fromModule := builder newClassNamed: #FromModule.
	functionDefinition := builder newClassNamed: #FunctionDefinition.
	generatorExpression := builder newClassNamed: #GeneratorExpression.
	genericType := builder newClassNamed: #GenericType.
	globalStatement := builder newClassNamed: #GlobalStatement.
	identifier := builder newClassNamed: #Identifier.
	ifClause := builder newClassNamed: #IfClause.
	ifStatement := builder newClassNamed: #IfStatement.
	import := builder newClassNamed: #Import.
	importedEntity := builder newClassNamed: #ImportedEntity.
	importFromStatement := builder newClassNamed: #ImportFromStatement.
	importStatement := builder newClassNamed: #ImportStatement.
	integer := builder newClassNamed: #Integer.
	interpolation := builder newClassNamed: #Interpolation.
	keywordArgument := builder newClassNamed: #KeywordArgument.
	keywordPattern := builder newClassNamed: #KeywordPattern.
	keywordSeparator := builder newClassNamed: #KeywordSeparator.
	lambda := builder newClassNamed: #Lambda.
	lambdaParameters := builder newClassNamed: #LambdaParameters.
	list := builder newClassNamed: #List.
	listComprehension := builder newClassNamed: #ListComprehension.
	literal := builder newAbstractClassNamed: #Literal.
	matchStatement := builder newClassNamed: #MatchStatement.
	memberType := builder newClassNamed: #MemberType.
	methodDefinition := builder newClassNamed: #MethodDefinition.
	module := builder newClassNamed: #Module.
	namedExpression := builder newClassNamed: #Walrus.
	none := builder newClassNamed: #None.
	nonlocalStatement := builder newClassNamed: #NonlocalStatement.
	notOperator := builder newClassNamed: #NotOperator.
	operator := builder newClassNamed: #Operator.
	pair := builder newClassNamed: #Pair.
	parameter := builder newClassNamed: #Parameter.
	parenthesizedListSplat := builder newClassNamed: #ParenthesizedListSplat.
	passStatement := builder newClassNamed: #PassStatement.
	positionalSeparator := builder newClassNamed: #PositionalSeparator.
	printStatement := builder newClassNamed: #PrintStatement.
	raiseStatement := builder newClassNamed: #RaiseStatement.
	returnStatement := builder newClassNamed: #ReturnStatement.
	set := builder newClassNamed: #Set.
	setComprehension := builder newClassNamed: #SetComprehension.
	slice := builder newClassNamed: #Slice.
	(splat := builder newClassNamed: #Splat) comment:
		'In Python a collection (list or dictionary) splat is the unpacking of a collection in a call or in the definition of another definition like `[ *list , 4 ]` or `func(*list)`'.
	(splatParameter := builder newClassNamed: #SplatParameter) comment:
		'A splat parameter is a parameter that is a list slpat such as *args or a dictionary splat such as **kwargs.'.
	splatType := builder newClassNamed: #SplatType.
	statement := builder newAbstractClassNamed: #Statement.
	string := builder newClassNamed: #String.
	subscript := builder newClassNamed: #Subscript.
	thenClause := builder newClassNamed: #ThenClause.
	tryStatement := builder newClassNamed: #TryStatement.
	tuple := builder newClassNamed: #Tuple.
	tuple withTesting.
	type := builder newClassNamed: #Type.
	typeAliasStatement := builder newClassNamed: #TypeAliasStatement.
	typeConversion := builder newClassNamed: #TypeConversion.
	typeParameter := builder newClassNamed: #TypeParameter.
	unaryOperator := builder newClassNamed: #UnaryOperator.
	unionPattern := builder newClassNamed: #UnionPattern.
	unionType := builder newClassNamed: #UnionType.
	variable := builder newClassNamed: #Variable.
	whileStatement := builder newClassNamed: #WhileStatement.
	withStatement := builder newClassNamed: #WithStatement.
	yield := builder newClassNamed: #Yield
]

{ #category : 'definition' }
FASTPythonMetamodelGenerator >> defineHierarchy [
	"define class hierarchy"

	super defineHierarchy.

	entity --|> tEntity.
	entity --|> tWithComment.
	
	"Adding a bunch of traits in errors to not interupt the parsing much if we have an error."
	_ERROR --|> expression.
	
	expression --|> tSliceIndex.

	asPattern --|> tWithStatementItem.

	assignment --|> expression. "This should be a statement and not an expression. But making it an expression make it easier to manage nested assignments."
	assignment --|> tAssignable.

	assertStatement --|> statement.

	attribute --|> expression.
	attribute --|> tReturnReferenceable.
	attribute --|> tAsPatternTarget.
	attribute --|> tSplatParameterTarget.
	attribute --|> tNamedEntity.
	attribute --|> tCanBeVariable.
	
	augmentedAssignment --|> assignment.
	
	await --|> expression.

	binaryOperator --|> operator.
	binaryOperator --|> tBinaryExpression.
	binaryOperator --|> tSplatExpression.
	binaryOperator --|> tPattern.

	booleanOperator --|> operator.
	booleanOperator --|> tBinaryExpression. "I am not 100% sure this is the best trait to use but it seems to work well for now"
	booleanOperator --|> tSplatExpression.
	booleanOperator --|> tRaised.

	boolean --|> literal.
	boolean --|> tBooleanLiteral.
	
	breakStatement --|> statement.
	breakStatement --|> tBreakStatement.

	call --|> expression.
	call --|> tInvocation.
	call --|> tReturnReferenceable.
	call --|> tWithStatementItem.
	
	caseClause --|> tStatementBlock.
	caseClause --|> tWithCondition.

	classDefinition --|> statement.
	classDefinition --|> tDefinition.
	classDefinition --|> tWithTypeParameters.
	
	classPattern --|> tPattern.

	collectionInitializer --|> expression.
	collectionInitializer --|> tSplatExpression.
	collectionInitializer --|> tPattern.
	
	comment --|> tComment.

	comparisonOperator --|> operator.

	complex --|> literal.
	complex --|> tNumericalLiteral.
	
	comprehension --|> expression.	
	comprehension --|> tSplatExpression.
	
	concatenatedString --|> expression.
	
	conditionalExpression --|> expression.
	conditionalExpression --|> tWithCondition.
	conditionalExpression --|> tSuperclass.
	conditionalExpression --|> tCallable.
	conditionalExpression --|> tExecutable.
	
	continueStatement --|> statement.
	continueStatement --|> tContinueStatement.
	
	constrainedType --|> tTypeContent.

	deleteStatement --|> statement.

	dictionary --|> collectionInitializer.
	
	dictionaryComprehension --|> comprehension.
	
	dottedName --|> expression.
	dottedName --|> tPattern.
	dottedName --|> tClassPatternElement.

	elseClause --|> tStatementBlock.

	elifClause --|> tStatementBlock.
	elifClause --|> tConditionalStatement.
	
	ellipsis --|> literal.
	
	exceptClause --|> tStatementBlock.
	
	execStatement --|> statement.

	expression --|> statement. "In Python expressions can also be expression statements."
	expression --|> tExpression.
	expression --|> tTypeContent. "Not sure all expressions should be but it's simpler like this."
	
	finallyClause --|> tStatementBlock.
	
	float --|> literal.
	float --|> tNumericalLiteral.
	
	forInClause --|> expression. "This is wrong! I am just here temporarily until we rework the relation to the for in clause (I need to be able to be a clause of a list comprehension)"

	forStatement --|> statement.
	forStatement --|> tStatementBlock.
	forStatement --|> tWithElseClause.

	functionDefinition --|> statement.
	functionDefinition --|> tDefinition.
	functionDefinition --|> tWithTypeParameters.
	functionDefinition --|> tWithParameters.
	
	generatorExpression --|> comprehension.
	
	genericType --|> tTypeContent.
	genericType --|> tWithTypeParameters.
	genericType --|> tNamedEntity.

	globalStatement --|> statement.

	identifier --|> expression.
	identifier --|> tReturnReferenceable.
	identifier --|> tAsPatternTarget.
	identifier --|> tSplatParameterTarget.
	identifier --|> tNamedEntity.
	identifier --|> tCanBeVariable.
	
	ifClause --|> expression. "This is wrong! I am just here temporarily until we rework the relation to the for in clause (I need to be able to be a clause of a list comprehension)"

	ifStatement --|> statement.
	ifStatement --|> tConditionalStatement.
	ifStatement --|> tWithElseClause.
	
	import --|> statement.

	importStatement --|> import.

	importFromStatement --|> import.

	integer --|> literal.
	integer --|> tNumericalLiteral.
	
	keywordArgument --|> expression.
	keywordArgument --|> tNamedEntity.
	
	keywordPattern --|> tClassPatternElement.
	keywordPattern --|> tPattern.
	keywordPattern --|> tNamedEntity.
	
	keywordSeparator --|> tVariableEntity. "I'm not fan because they cannot be in assignation but that will do for now."
	
	lambda --|> expression.
	lambda --|> tWithParameters.
	lambda --|> tDecoratorExpression.
	lambda --|> tCallable.
	
	list --|> collectionInitializer.
	list --|> tAsPatternTarget.
	list --|> tAssignable.
	
	listComprehension --|> comprehension.
	
	literal --|> expression.
	literal --|> tLiteral.
	literal --|> tPattern.
	
	matchStatement --|> statement.

	methodDefinition --|> statement.
	methodDefinition --|> tDefinition.
	methodDefinition --|> tWithTypeParameters.
	methodDefinition --|> tWithParameters.

	module --|> tStatementBlock.
	module --|> #THasImmediateSource.
	module withPrecedenceOf: #THasImmediateSource.
	
	namedExpression --|> expression.
	namedExpression --|> tNamedEntity.
	
	none --|> literal.

	nonlocalStatement --|> statement.
	
	notOperator --|> operator.
	notOperator --|> tUnaryOperator.

	operator --|> expression.

	pair --|> expression.
	
	parameter --|> tVariableEntity.
	parameter --|> tCanBeVariable.

	passStatement --|> statement.
	
	positionalSeparator --|> tVariableEntity. "I'm not fan because they cannot be in assignation but that will do for now."
	
	printStatement --|> statement.
	
	raiseStatement --|> statement.

	returnStatement --|> statement.
	returnStatement --|> tReturnStatement.

	set --|> collectionInitializer.
	
	setComprehension --|> comprehension.
	
	slice --|> tSliceIndex.
	
	splat --|> expression.
	splat --|> tPattern.
	splat --|> tSuperclass.

	splatParameter --|> parameter.
	
	splatType --|> tTypeContent.
	splatType --|> tNamedEntity.
	
	statement --|> tStatement.

	string --|> literal.
	string --|> tStringLiteral.
	string --|> tSplatExpression.
	string --|> tExecutable.
	
	subscript --|> expression.
	subscript --|> tReturnReferenceable.
	subscript --|> tAsPatternTarget.
	subscript --|> tCanBeVariable.
	
	tAsPatternTarget --|> tAsPatternSource.

	tDefinition --|> tNamedEntity.
	tDefinition --|> tStatementBlock.
	
	tReturnReferenceable --|> tAssignable.
	tReturnReferenceable --|> tRaised.
	tReturnReferenceable --|> tAsPatternSource.
	tReturnReferenceable --|> tSplatExpression.
	tReturnReferenceable --|> tDecoratorExpression.
	tReturnReferenceable --|> tDeletable.
	tReturnReferenceable --|> tSuperclass.
	tReturnReferenceable --|> tCallable.
	tReturnReferenceable --|> tAwaitable.
	tReturnReferenceable --|> tExecutable.

	thenClause --|> tStatementBlock.

	tuple --|> collectionInitializer.
	tuple --|> tAsPatternTarget.
	tuple --|> tAssignable.
	tuple --|> tDeletable.
	
	tryStatement --|> statement.
	tryStatement --|> tStatementBlock.
	tryStatement --|> tWithElseClause.
	
	typeAliasStatement --|> statement.
	
	typeParameter --|> tTypeContent.

	unaryOperator --|> operator.
	unaryOperator --|> tUnaryOperator.
	
	unionPattern --|> tPattern.
	
	unionType --|> tTypeContent.

	variable --|> identifier.
	variable --|> tVariableEntity.
	variable --|> tAssignable.

	whileStatement --|> statement.
	whileStatement --|> tConditionalStatement.
	whileStatement --|> tStatementBlock.
	whileStatement --|> tWithElseClause.
	
	withStatement --|> statement.
	withStatement --|> tStatementBlock.
	
	yield --|> expression
]

{ #category : 'definition' }
FASTPythonMetamodelGenerator >> defineProperties [

	super defineProperties.
	
	augmentedAssignment property: #operator type: #String. 
	
	(caseClause property: #alias type: #String) comment: 'Alias used if an as pattern is used in the clause.'.

	(comparisonOperator property: #operators type: #String)
		multivalued: true;
		comment: 'The comparators applied in order. Possible operators:  <, <=, ==, !=, >=, >, <>, in, not in, is, is not'.

	(dottedName property: #identifiers type: #String)
		multivalued: true;
		comment: 'The elements separated by a .'.
	
	(exceptClause property: #alias type: #String) comment: 'Alias used if an as pattern is used in the clause.'.

	(fromModule property: #segments type: #String)
		multivalued: true;
		comment:
			'The segments of the module path. For example if you declare `xml.etree.ElementTree` as module, the segments will be { ''xml'' . ''etree'' . ''ElementTree''}.'.
			
	(importedEntity property: #segments type: #String)
		multivalued: true;
		comment:
			'The segments of the imported entity. For example if you import `xml.etree.ElementTree`, the segments will be { ''xml'' . ''etree'' . ''ElementTree''}.'.

	(importedEntity property: #alias type: #String) comment: 'If the imported entity has an alias, I contain it.'.
	
	(interpolation property: #formatSpecifier type: #String) comment: 'If specified, the format of the interpolation.'.
	
	(interpolation property: #typeConversion type: #String) comment: 'If specified, the type conversion of the interpolation.'.

	unaryOperator property: #operator type: #String
]

{ #category : 'definition' }
FASTPythonMetamodelGenerator >> defineRelations [

	super defineRelations.
	
	(assignment property: #left) <>- (tAssignable property: #parentAssignmentLeft).
	(assignment property: #right) <>- (expression property: #parentAssignmentRight).
	(assignment property: #type) <>- (type property: #parentAssignment).

	(asPattern property: #target) <>- (tAsPatternTarget property: #parentAsPatternTarget).

	(asPattern property: #source) <>- (tAsPatternSource property: #parentAsPatternSource).

	((assertStatement property: #expressions) comment: 'The expressions asserted')
	<>-* ((expression property: #parentAssertStatement) comment: 'The assert statement that own the expression (if it''s the case)').

	((attribute property: #value) comment:
		 'I am the receiver of the attribute. I can be multiple things such as a variable, a call, another attribute access, a primitive type, a subscript...')
	<>- ((expression property: #parentAttributeObject) comment: 'My parent if I define the object of an attribute access (if it''s the case).').

	(await property: #expression) <>- (tAwaitable property: #parentAwait).

	((call property: #callee) comment:
		 'I represent what is called. Can be a class for an instantiation. A function invocation. A method invocation. The call of the return of a call. The call of something invoked from an array access...')
	<>- ((tCallable property: #caller) comment: 'The call entity calling me (if it''s the case)').
	
	(caseClause property: #pattern) <>-(tPattern property: #parentCaseClause).
	
	(chevron property: #expression) <>- (expression property: #parentChevron).
	
	(classDefinition property: #superclasses) <>-* (tSuperclass property: #parentClassDefinition).
	(classDefinition property: #keywords) <>-* (keywordArgument property: #parentClassDefinition).
	
	(classPattern property: #elements) <>-* (tClassPatternElement property: #parentClassPattern).

	((collectionInitializer property: #initializers) comment: 'Each initializer defines one element.')
	<>-* ((expression property: #collectionInitializer) comment: 'The owner of the expression').

	((comparisonOperator property: #operands) comment:
		 'List of the operands of the comparison operands. For example if we have `a == b != c`, it will be a, b and c.')
	<>-* ((expression property: #parentComparisonOperator) comment: 'Parent comparison expression of which I am.').
	
	(comprehension property: #body) <>- (expression property: #parentComprehensionBody).
	(comprehension property: #forClauses) <>-* (expression property: #parentComprehensionForClause).
	(comprehension property: #conditions) <>-* (expression property: #parentComprehensionCondition).

	(concatenatedString property: #strings) <>-* (string property: #parentConcatenatedString).

	(conditionalExpression property: #thenExpression) <>- (expression property: #parentConditionalExpressionThen).
	(conditionalExpression property: #elseExpression) <>- (expression property: #parentConditionalExpressionElse).
	
	(constrainedType property: #type) <>- (type property: #parentContrainedType).
	(constrainedType property: #bound) <>- (type property: #parentContrainedTypeBound).

	(decorator property: #expression) <>- (tDecoratorExpression property: #parentDeclarator).

	((deleteStatement property: #expression) comment: 'The expression to apply the delete on')
	<>- ((tDeletable property: #parentDeleteStatement) comment: 'The delete statement that own the expression (if it''s the case)').
	
	(exceptClause property: #expression) <>- (expression property: #parentExceptClause). "We could point less things than expression, but in reality in Python any expression can be provided. It will just end up in runtime error."
	
	(execStatement property: #code) <>- (tExecutable property: #parentExecStatement).
	(execStatement property: #scopes) <>-* (expression property: #parentExecStatementScopes).

	(forInClause property: #left) <>- (expression property: #parentForInClauseLeft).
	(forInClause property: #right) <>- (expression property: #parentForInClauseRight).

	((forStatement property: #right) comment: 'The list that the for statement iterates over')
	<>- ((expression property: #parentForStatementRight) comment: 'The for statement right owner (if possible)').
	((forStatement property: #left) comment: 'The identifier of the created local variable or tuple')
	<>- ((expression property: #parentForStatementLeft) comment: 'The for statement left owner (if possible)').
	
	(functionDefinition property: #returnType) <>- (type property: #parentFunctionDefinition).

	(genericType property: #arguments) <>-* (type property: #parentGenericTypeArgument).
	
	((globalStatement property: #variables) comment: 'The variables scoped')
	<>-* ((variable property: #parentGlobalStatement) comment: 'The global statement defining my scope (if it''s the case)').

	(ifClause property: #expression) <>- (expression property: #parentIfClause).

	(ifStatement property: #thenClause) <>- (thenClause property: #parentIfStatement).
	(ifStatement property: #elifClauses) <>-* (elifClause property: #parentIfStatement).

	((import property: #importedEntities) comment: 'List of the imported entities.')
	<>-* ((importedEntity property: #import) comment: 'Import declaring me as imported entity.').

	((importFromStatement property: #fromModule) comment:
		 'Module in which the imported entities should be looked for. `from datetime import date` has `datetime` as fromModule..')
	<>- ((fromModule property: #import) comment: 'Import declaring me as from import module.').

	(interpolation property: #expression) <>- (expression property: #parentInterpolation).

	((keywordArgument property: #value) comment: 'The value of the keyword argument.')
	<>- ((expression property: #parentKeywordArgument) comment: 'Keyword argument from which I am the value (if it''s the case)').
	
	(keywordPattern property: #value) <>- (tPattern property: #parentKeywordPatternValue).

	(lambda property: #expression) <>- (expression property: #parentLambda).
	
	(matchStatement property: #subject) <>- (expression property: #parentMatchStatement).
	(matchStatement property: #cases) <>-* (caseClause property: #parentMatchStatement).
	
	(methodDefinition property: #returnType) <>- (type property: #parentMethodDefinition).
	
	(namedExpression property: #value) <>- (expression property: #parentWalrus).
	
	((nonlocalStatement property: #variables) comment: 'The variables scoped')
	<>-* ((variable property: #parentNonlocalStatement) comment: 'The global statement defining my scope (if it''s the case)').

	(pair property: #key) <>- (expression property: #parentPairKey).

	(pair property: #value) <>- (expression property: #parentPairValuer).
	
	(parameter property: #type) <>- (type property: #parentParameter).
	(parameter property: #defaultValue) <>- (expression property: #parentDefaultParameterValue).

	(printStatement property: #expressions) <>-* (expression property: #prarentPrintStatement).
	(printStatement property: #redirection) <>- (chevron property: #parentPrintStatement). 
	
	(raiseStatement property: #exception) <>- (tRaised property: #parentRaiseStatement).

	(splat property: #expression) <>- (tSplatExpression property: #parentSplat).

	((slice property: #components) comment: 'The components are the expressions between the `:` of a slice.')
	<>-* ((expression property: #parentSlice) comment: 'Slice in which I am a component (start, end or step) (If it''s the case)'''). "Originally, I created a trait for Slice content because the python syntax does not allow all expressions. But multiple libraries are changing the syntax to accept other objects such as float, list or even string. So now I point FASTPyExpression to not fail on all those cases."

	(string property: #interpolations) <>-* (interpolation property: #parentString).

	((subscript property: #value) comment: 'The receiver of the subscript')
	<>- ((expression property: #parentSubscriptValue) comment: 'My parent if I define the receiver of a subscript (if it''s the case).').
	((subscript property: #indices) comment: 'The elements defining the indices to select in a subscript.')
	<>-* ((tSliceIndex property: #parentSubscriptIndex) comment: 'My parent if I am defining an index to select of a subscript (if it''s the case)').

	(tDefinition property: #decorators) <>-* (decorator property: #parentDefinition).
	
	(tryStatement property: #excepts) <>-* (exceptClause property: #parentTryStatement).

	(splatParameter property: #target) <>- (tSplatParameterTarget property: #parentSplatParameter).

	((tUnaryOperator property: #argument) comment: 'Expression influanced by the unary operator..')
	<>- ((expression property: #parentUnaryOperator) comment: 'Parent unary operator in which I am.').
	
	(type property: #content) <>- (tTypeContent property: #parentType).
	
	(typeAliasStatement property: #left) <>- (type property: #parentyTypeAliasStatementAlias).
	(typeAliasStatement property: #right) <>- (type property: #parentyTypeAliasStatementType).
	
	(tryStatement property: #finally) <>- (finallyClause property: #parentTryStatement).

	(tWithElseClause property: #elseClause) <>- (elseClause property: #parentIfStatement).
	
	(tWithTypeParameters property: #typeParameters) <>-* (type property: #parentWithTypeParameters).
	
	(unionPattern property: #members) <>-* (tPattern property: #parentUnionPattern).
	
	(unionType property: #types) <>-* (type property: #parentUnionType).

	(withStatement property: #items) <>-* (tWithStatementItem property: #parentWithStatementItem).
	
	(yield property: #expression) <>- (expression property: #parentYield)
]

{ #category : 'definition' }
FASTPythonMetamodelGenerator >> defineTraits [

	super defineTraits.
	
	"Entity"
	tEntity := self remoteTrait: #TEntity withPrefix: #FAST.
	
	"FAST-Python"
	tAsPatternTarget := (builder newTraitNamed: #TAsPatternTarget) comment: 'I represent an entity that could be the alias/target of an as pattern.'.

	tAsPatternSource := (builder newTraitNamed: #TAsPatternSource) comment: 'I represent an entity that could be aliased in an as pattern.'.

	tAssignable := (builder newTraitNamed: #TAssignable) comment: 'I represent something that can be assigned in an assignment'.
	
	tAwaitable := (builder newTraitNamed: #TAwaitable) comment: 'I represent an entity that is awaitable and can be in an await statement'.
	
	tCallable := (builder newTraitNamed: #TCallable) comment: 'I represent something that can be the receiver of a call'.
	
	tCanBeVariable := (builder newTraitNamed: #TCanBeVariable) comment: 'Represent everything that can be a variable. Used for the LocalResolver and the SSA builder. Maybe I should be merged with TAssignable?'.
	
	tClassPatternElement := (builder newTraitNamed: #TClassPatternElement) comment: 'I represent the elements of a class pattern in python pattern matcher. The first element is the class name, the others the arguments.'.

	tDecoratorExpression := (builder newTraitNamed: #TDecoratorExpression) comment: 'I represent an entity that *can* be the expression of a decorator.'.

	tDefinition := builder newTraitNamed: #TDefinition.

	tDeletable := (builder newTraitNamed: #TDeletable) comment: 'I represent an expression that can be in a delete statement.'.
	
	tExecutable := (builder newTraitNamed: #TExecutable) comment: 'I represent something that can be executed by an exec statement'.
	
	tPattern := (builder newTraitNamed: #TPattern) comment: 'I represent an entity that can be the pattern of a case clause in a match statement..'.

	tRaised := (builder newTraitNamed: #TRaised) comment: 'I represent an expression that can give an exception to raise in a raise statement.'.

	tReturnReferenceable := (builder newTraitNamed: #TReturnReferenceable) comment: 'Lot of relations in python points to references. And some nodes can return lot of those references such as call, subscript, tuple, attribute. I am here to group those dependences.'.
	
	tSliceIndex := (builder newTraitNamed: #TSliceIndex) comment: 'I represent an entity that can be in the brackets of a subscript.'.

	tSplatExpression := (builder newTraitNamed: #TSplatExpression) comment: 'My users are expressions that can be in a collection splat. For example in `[ *getList(), 3 ]`, we have a list splat on the call `getList()`. Get list, is the expression of the splat.'.

	tSplatParameterTarget := (builder newTraitNamed: #TSplatParameterTarget) comment: 'My users are parameter target in a splat. For example in `def f(*list): pass`, we have a list splat parameter named list.'.
	
	tSuperclass := (builder newTraitNamed: #TSuperclass) comment: 'My users are expressions that can define a superclass in a class declaration.'.
	
	tTypeContent := (builder newTraitNamed: #TTypeContent) comment: 'My user can be used as a type declaration'.

	tUnaryOperator := builder newTraitNamed: #TUnaryOperator.
	
	tWithElseClause := builder newTraitNamed: #TWithElseClause.

	tWithStatementItem := (builder newTraitNamed: #TWithStatementItem) comment: 'I represent an entity that can be the item of a with_statement.'.

	tWithTypeParameters := (builder newTraitNamed: #TWithTypeParameters) comment: 'I represent an entity with type parameters such as generic types, function/method definition or class definition'.
	
	"Remotes"
	tAssignment := self remoteTrait: #TAssignment withPrefix: #FAST.
	tBinaryExpression := self remoteTrait: #TBinaryExpression withPrefix: #FAST.
	tBooleanLiteral := self remoteTrait: #TBooleanLiteral withPrefix: #FAST.
	tBreakStatement := self remoteTrait: #TBreakStatement withPrefix: #FAST.
	tComment := self remoteTrait: #TComment withPrefix: #FAST.
	tConditionalStatement := self remoteTrait: #TConditionalStatement withPrefix: #FAST.
	tContinueStatement := self remoteTrait: #TContinueStatement withPrefix: #FAST.
	tExpression := self remoteTrait: #TExpression withPrefix: #FAST.
	tInvocation := self remoteTrait: #TInvocation withPrefix: #FAST.
	tLiteral := self remoteTrait: #TLiteral withPrefix: #FAST.
	tNamedBehaviouralEntity := self remoteTrait: #TNamedBehaviouralEntity withPrefix: #FAST.
	tNamedEntity := self remoteTrait: #TNamedEntity withPrefix: #FAST.
	tNumericalLiteral := self remoteTrait: #TNumericalLiteral withPrefix: #FAST.
	tReturnStatement := self remoteTrait: #TReturnStatement withPrefix: #FAST.
	tStatement := self remoteTrait: #TStatement withPrefix: #FAST.
	tStatementBlock := self remoteTrait: #TStatementBlock withPrefix: #FAST.
	tStringLiteral := self remoteTrait: #TStringLiteral withPrefix: #FAST.
	tVariableEntity := self remoteTrait: #TVariableEntity withPrefix: #FAST.
	tWithCondition := self remoteTrait: #TWithCondition withPrefix: #FAST.
	tWithComment := self remoteTrait: #TWithComments withPrefix: #FAST.
	tWithParameters := self remoteTrait: #TWithParameters withPrefix: #FAST.
	tWithStatements := self remoteTrait: #TWithStatements withPrefix: #FAST
]
