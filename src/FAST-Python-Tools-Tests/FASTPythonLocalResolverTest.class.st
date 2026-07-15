Class {
	#name : 'FASTPythonLocalResolverTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'model'
	],
	#category : 'FAST-Python-Tools-Tests-Utilities',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Utilities'
}

{ #category : 'resolving' }
FASTPythonLocalResolverTest >> parseAndResolve: aString [

	model := self parse: aString.

	FASTPythonLocalResolverVisitor resolve: model module
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testDeclarationAndUsageOfGlobalInModule [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testGlobalAndTemporaryOfTheSameNameInFunction [

	| globalAssignment assignedGlobal usedGlobal temporaryAssignment assignedTemporary temporaryUsage1 temporaryUsage2 |
	self parseAndResolve: 'glob = 1

def fun():
    glob = 3
    print(glob)
    return glob

fun()
print(glob)'.

	globalAssignment := model module statements first.
	assignedGlobal := globalAssignment left.
	self assert: assignedGlobal localDeclaration equals: globalAssignment.
	self assert: assignedGlobal localDeclaration left name equals: 'glob'.
	self deny: assignedGlobal localDeclaration isNonLocalDeclaration.
	self assert: assignedGlobal localDeclaration localUses size equals: 2.
	self assert: assignedGlobal localDeclaration localUses first equals: assignedGlobal.

	usedGlobal := model module statements fourth arguments first.
	self assert: usedGlobal localDeclaration equals: globalAssignment.
	self assert: usedGlobal equals: assignedGlobal localDeclaration localUses second.

	temporaryAssignment := model module statements second statements first.
	assignedTemporary := temporaryAssignment left.
	self assert: assignedTemporary localDeclaration equals: temporaryAssignment.
	self assert: assignedTemporary localDeclaration left name equals: 'glob'.
	self deny: assignedTemporary localDeclaration isNonLocalDeclaration.
	self assert: assignedTemporary localDeclaration localUses size equals: 3.
	self assert: assignedTemporary localDeclaration localUses first equals: assignedTemporary.

	temporaryUsage1 := model module statements second statements second arguments first.
	self assert: temporaryUsage1 localDeclaration equals: temporaryAssignment.
	self assert: temporaryUsage1 equals: assignedTemporary localDeclaration localUses second.

	temporaryUsage2 := model module statements second statements third expression.
	self assert: temporaryUsage2 localDeclaration equals: temporaryAssignment.
	self assert: temporaryUsage2 equals: assignedTemporary localDeclaration localUses third
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testGlobalUsedInFunction [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'glob = 1

def fun():
    return glob

print(fun())'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'glob'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second statements first expression.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testGlobalUsedInLambda [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'x = 1

lambda: x'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second expression.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testLocalVariableInFunction [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'def f():
	x = 1
	return x
	
print(f())'.

	assignment := model module statements first statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements first statements second expression.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testTwoAssignationsCreateOneDeclaration [

	| assignment1 assignment2 assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
x = 2
x'.

	assignment1 := model module statements first.
	assignedVariable := assignment1 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	assignment2 := model module statements second.
	assignedVariable := assignment2 left.
	self assert: assignedVariable localDeclaration equals: assignment1.
	self assert: assignedVariable equals: assignedVariable localDeclaration localUses second.

	usedVariable := model module statements third.
	self assert: usedVariable localDeclaration equals: assignment1.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses third
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testUsageInCall [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'x = 1
print(x)'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableAccessedInForIn [

	| assignment assignedVariable usedVariable |
	self parseAndResolve: 'fruits = ["apple", "banana", "cherry"]
for x in fruits:
  pass'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'fruits'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.

	usedVariable := model module statements second right.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableAccessedInIf [

	| assignment assignedVariable usedVariable1 usedVariable2 |
	self parseAndResolve: 'glob = 1

if glob < 3:
    print(glob)'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'glob'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.

	usedVariable1 := model module statements second condition operands first.
	self assert: usedVariable1 localDeclaration equals: assignment.
	self assert: usedVariable1 equals: assignedVariable localDeclaration localUses second.

	usedVariable2 := model module statements second thenClause statements first arguments first.
	self assert: usedVariable2 localDeclaration equals: assignment.
	self assert: usedVariable2 equals: assignedVariable localDeclaration localUses third
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableDeclaredInFor [

	| assignement declared usedVariable |
	self parseAndResolve: 'for x in "banana":
    i = 2

print(i)'.

	assignement := model module statements first statements first.
	declared := assignement left.
	self assert: declared localDeclaration equals: assignement.
	self assert: declared localDeclaration left sourceCode equals: 'i'.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignement.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - while' }
FASTPythonLocalResolverTest >> testVariableDeclaredInWhile [

	| assignement declared usedVariable |
	self parseAndResolve: 'while False:
    i = 2

print(i)'.

	assignement := model module statements first statements first.
	declared := assignement left.
	self assert: declared localDeclaration equals: assignement.
	self assert: declared localDeclaration left sourceCode equals: 'i'.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: assignement.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfFor [

	| for declared usedVariable |
	self parseAndResolve: 'for x in "banana":
  print(x)'.

	for := model module statements first.
	declared := for left.
	self assert: declared localDeclaration equals: for.
	self assert: declared localDeclaration left sourceCode equals: 'x'.
	self deny: declared localDeclaration isNonLocalDeclaration.
	self assert: declared localDeclaration localUses size equals: 2.
	self assert: declared localDeclaration localUses first equals: declared.

	usedVariable := for statements first arguments first.
	self assert: usedVariable localDeclaration equals: for.
	self assert: usedVariable equals: declared localDeclaration localUses second
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForClashingWithOtherVariables [

	| assignation assignedVariable assignedVariableInFor usedVariable |
	self parseAndResolve: 'x = 3

for x in range(5):
    print(x)'.

	assignation := model module statements first.
	assignedVariable := assignation left.
	self assert: assignedVariable localDeclaration equals: assignation.
	self assert: assignedVariable localDeclaration left sourceCode equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	assignedVariableInFor := model module statements second left.
	self assert: assignedVariableInFor localDeclaration equals: assignation.
	self assert: assignedVariableInFor equals: assignedVariableInFor localDeclaration localUses second.

	usedVariable := model module statements second statements first arguments first.
	self assert: usedVariable localDeclaration equals: assignation.
	self assert: usedVariable equals: usedVariable localDeclaration localUses third
]

{ #category : 'tests - for' }
FASTPythonLocalResolverTest >> testVariableOfForStaysAfterFor [

	| for assignedVariable usedVariable |
	self parseAndResolve: 'for x in range(5):
    pass

print(x)'.

	for := model module statements first.
	assignedVariable := for left.
	self assert: assignedVariable localDeclaration equals: for.
	self assert: assignedVariable localDeclaration left sourceCode equals: 'x'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 2.
	self assert: assignedVariable localDeclaration localUses first equals: assignedVariable.

	usedVariable := model module statements second arguments first.
	self assert: usedVariable localDeclaration equals: for.
	self assert: usedVariable equals: usedVariable localDeclaration localUses second
]

{ #category : 'tests' }
FASTPythonLocalResolverTest >> testVariableRedefinedInIf [

	| assignment assignedVariable assignedVariable2 usedVariable |
	self parseAndResolve: 'glob = 1

if True:
    glob = 3

print(glob)'.

	assignment := model module statements first.
	assignedVariable := assignment left.
	self assert: assignedVariable localDeclaration equals: assignment.
	self assert: assignedVariable localDeclaration left name equals: 'glob'.
	self deny: assignedVariable localDeclaration isNonLocalDeclaration.
	self assert: assignedVariable localDeclaration localUses size equals: 3.

	assignedVariable2 := model module statements second thenClause statements first left.
	self assert: assignedVariable2 localDeclaration equals: assignment.
	self assert: assignedVariable2 equals: assignedVariable localDeclaration localUses second.

	usedVariable := model module statements third arguments first.
	self assert: usedVariable localDeclaration equals: assignment.
	self assert: usedVariable equals: assignedVariable localDeclaration localUses third
]
