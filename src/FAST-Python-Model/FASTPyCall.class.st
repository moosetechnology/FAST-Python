"
I represent a call in python. The call can represent multiple things such as:
- a function invocation such as `flush(var)`
- a method invocation such as `self.increment()`
- a class instantiation such as Stack()

## Relations
======================

### Parents
| Relation | Origin | Opposite | Type | Comment |
|---|
| `argumentOwner` | `FASTTExpression` | `arguments` | `FASTTWithArguments` | my owner|
| `assignedIn` | `FASTTExpression` | `expression` | `FASTTAssignment` | Optional assignment where this expression is used|
| `caller` | `FASTPyTCallable` | `callee` | `FASTPyCall` | The call entity calling me (if it's the case)|
| `expressionStatementOwner` | `FASTTExpression` | `expression` | `FASTTExpressionStatement` | The expression statement that own me (if it's the case|
| `parentAsPatternSource` | `FASTPyTAsPatternSource` | `source` | `FASTPyAsPattern` | |
| `parentAssignmentLeft` | `FASTPyTAssignable` | `left` | `FASTPyAssignment` | |
| `parentAwait` | `FASTPyTAwaitable` | `expression` | `FASTPyAwait` | |
| `parentClassDefinition` | `FASTPyTSuperclass` | `superclasses` | `FASTPyClassDefinition` | |
| `parentConditional` | `FASTTExpression` | `condition` | `FASTTWithCondition` | Optional condition statement/expression where this expression is used|
| `parentDeclarator` | `FASTPyTDecoratorExpression` | `expression` | `FASTPyDecorator` | |
| `parentDeleteStatement` | `FASTPyTDeletable` | `expression` | `FASTPyDeleteStatement` | The delete statement that own the expression (if it's the case)|
| `parentExecStatement` | `FASTPyTExecutable` | `code` | `FASTPyExecStatement` | |
| `parentExpression` | `FASTTExpression` | `expression` | `FASTTUnaryExpression` | Parent (unary) expression|
| `parentExpressionLeft` | `FASTTExpression` | `leftOperand` | `FASTTBinaryExpression` | Parent (binary) expression of which I am left side|
| `parentExpressionRight` | `FASTTExpression` | `rightOperand` | `FASTTBinaryExpression` | Parent (binary) expression of which I am right side|
| `parentRaiseStatement` | `FASTPyTRaised` | `exception` | `FASTPyRaiseStatement` | |
| `parentSplat` | `FASTPyTSplatExpression` | `expression` | `FASTPySplat` | |
| `parentWithStatementItem` | `FASTPyTWithStatementItem` | `items` | `FASTPyWithStatement` | |
| `returnOwner` | `FASTTExpression` | `expression` | `FASTTReturnStatement` | The return statement that own the expression (if it's the case)|

### Children
| Relation | Origin | Opposite | Type | Comment |
|---|
| `arguments` | `FASTTWithArguments` | `argumentOwner` | `FASTTExpression` | My arguments|
| `callee` | `FASTPyCall` | `caller` | `FASTPyTCallable` | I represent what is called. Can be a class for an instantiation. A function invocation. A method invocation. The call of the return of a call. The call of something invoked from an array access...|
| `invoked` | `FASTTInvocation` | `invokedIn` | `FASTTNamedEntity` | The name of the behavioural invoked|


## Properties
======================

| Name | Type | Default value | Comment |
|---|
| `endPos` | `Number` | nil | |
| `startPos` | `Number` | nil | |

"
Class {
	#name : 'FASTPyCall',
	#superclass : 'FASTPyExpression',
	#traits : 'FASTPyTReturnReferenceable + FASTPyTWithStatementItem + FASTTInvocation',
	#classTraits : 'FASTPyTReturnReferenceable classTrait + FASTPyTWithStatementItem classTrait + FASTTInvocation classTrait',
	#instVars : [
		'#callee => FMOne type: #FASTPyTCallable opposite: #caller'
	],
	#category : 'FAST-Python-Model-Entities',
	#package : 'FAST-Python-Model',
	#tag : 'Entities'
}

{ #category : 'meta' }
FASTPyCall class >> annotation [

	<FMClass: #Call super: #FASTPyExpression>
	<package: #'FAST-Python-Model'>
	<generated>
]

{ #category : 'accessing' }
FASTPyCall >> callee [
	"Relation named: #callee type: #FASTPyTCallable opposite: #caller"

	<generated>
	<FMComment: 'I represent what is called. Can be a class for an instantiation. A function invocation. A method invocation. The call of the return of a call. The call of something invoked from an array access...'>
	^ callee
]

{ #category : 'accessing' }
FASTPyCall >> callee: anObject [

	<generated>
	callee := anObject
]
