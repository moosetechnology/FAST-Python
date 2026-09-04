Class {
	#name : 'FASTPythonAssignedExpressionsInVariablesTest',
	#superclass : 'FASTPythonVariablesAnalysisTest',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
}

{ #category : 'tests' }
FASTPythonAssignedExpressionsInVariablesTest >> testAssignedExpressionsMap [

	| writenVariable1 writenVariable2 writenVariable3 map |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	writenVariable1 := model module statements first left.
	writenVariable2 := model module statements third left.
	writenVariable3 := model module statements fourth thenClause statements first left.

	map := model module statements second arguments first assignedExpressionsMap.

	self assert: map size equals: 1.
	self assertCollection: (map at: writenVariable1) hasSameElements: { model module statements first right }.

	map := map := model module statements fifth arguments first assignedExpressionsMap.

	self assert: map size equals: 2.
	self assertCollection: (map at: writenVariable2) hasSameElements: { model module statements third right }.
	self assertCollection: (map at: writenVariable3) hasSameElements: { model module statements fourth thenClause statements first right }
]

{ #category : 'tests' }
FASTPythonAssignedExpressionsInVariablesTest >> testAssignedExpressionsMapWithForInClause [

	| forInVariable map forInClause |
	self parseAndResolve: 'coll = [1, 2, 3]
y = [c for c in coll]'.

	forInClause := model module statements second right forClauses first.
	forInVariable := forInClause left.

	map := forInVariable assignedExpressionsMap.

	self assert: map size equals: 1.
	self assert: (map at: forInVariable) size equals: 1.
	self assertCollection: (map at: forInVariable) hasSameElements: { forInClause right }
]

{ #category : 'tests' }
FASTPythonAssignedExpressionsInVariablesTest >> testAssignedExpressionsMapWithLoop [

	| writenVariable1 writenVariable2 writenVariable3 map |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

for x in coll:
	print(x)

print(x)'.

	writenVariable1 := model module statements first left.
	writenVariable2 := model module statements third left.
	writenVariable3 := model module statements fourth left.

	map := model module statements second arguments first assignedExpressionsMap.

	self assert: map size equals: 1.
	self assertCollection: (map at: writenVariable1) hasSameElements: { model module statements first right }.

	map := map := model module statements fifth arguments first assignedExpressionsMap.

	self assert: map size equals: 2.
	self assertCollection: (map at: writenVariable2) hasSameElements: { model module statements third right }.
	self assertCollection: (map at: writenVariable3) hasSameElements: { model module statements fourth right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressions [

	| variable |
	self parseAndResolve: 'y = 4

x = y

print(x)'.

	variable := model module statements second transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsChain [

	| variable |
	self parseAndResolve: 'a = 1

b = a

c = b

print(c)'.
	variable := model module statements third transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements third right.
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsIsUnique [

	| variable |
	self parseAndResolve: 'a = 1

b = a

c = a

x = b + c

print(x)'.
	variable := model module statements fourth transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements fourth right.
			model module statements second right.
			model module statements third right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMap [
	| map |
	self parseAndResolve: 'y = 4

x = y

print(x)'.

	map := model module statements third arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements second left) hasSameElements: { model module statements second right. model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapChain [
	| map |
	self parseAndResolve: 'a = 1

b = a

c = b

print(c)'.

	map := model module statements fourth arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements third left) hasSameElements: { model module statements third right. model module statements second right. model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapIsUnique [

	| map |
	self parseAndResolve: 'a = 1

b = a

c = a

x = b + c

print(x)'.

	map := model module statements fifth arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements fourth left) hasSameElements: (model module statements fourth transitiveAssignedExpressions)
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithCycleOfVariables [
	| map |
	self parseAndResolve: 'x = 1

y = x

x = y

print(x)'.

	map := model module statements fourth arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements third left) hasSameElements: { model module statements third right. model module statements second right. model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithFunctionCall [
	| map |
	self parseAndResolve: 'y = call2()

x = call1(y)

print(x)'.

	map := model module statements third arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements second left) hasSameElements: { model module statements second right. model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithMultipleVariables [
	| map |
	self parseAndResolve: 'a = 1

b = 2

x = a + b

print(x)'.

	map := model module statements fourth arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements third left) hasSameElements: { model module statements third right. model module statements first right. model module statements second right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithMultipleWrites [
	| map |
	self parseAndResolve: 'if z > 3:
	x = a
else:
	x = b

print(x)'.

	map := model module statements second arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 2.
	self assertCollection: (map at: model module statements first thenClause statements first left) hasSameElements: { model module statements first thenClause statements first right }.
	self assertCollection: (map at: model module statements first elseClause statements first left) hasSameElements: { model module statements first elseClause statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithPhiVariable [
	| map |
	self parseAndResolve: 'if z > 3:
	y = 2
else:
	y = 3

x = y

print(x)'.

	map := model module statements third arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements second left) hasSameElements: { model module statements second right. model module statements first thenClause statements first right. model module statements first elseClause statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithReusedVariable [

	| map |
	self parseAndResolve: 'x = 1

x = x + 1

print(x)'.

	map := model module statements third arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements second left) hasSameElements: {
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsMapWithoutTransitivity [
	| map |
	self parseAndResolve: 'x = 5

print(x)'.

	map := model module statements second arguments first transitiveAssignedExpressionsMap.
	self assert: map size equals: 1.
	self assertCollection: (map at: model module statements first left) hasSameElements: { model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithCycleOfVariables [

	| variable |
	self parseAndResolve: 'x = 1

y = x

x = y

print(x)'.
	variable := model module statements third transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements third right.
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithForInClause [

	| forInClause result |
	self parseAndResolve: 'coll = [1, 2, 3]
y = [c for c in coll]'.

	forInClause := model module statements second right forClauses first.

	result := forInClause transitiveAssignedExpressions.

	self assert: result size equals: 2.
	self assertCollection: result hasSameElements: {
			forInClause right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithFunctionCall [

	| variable |
	self parseAndResolve: 'y = call2()

x = call1(y)

print(x)'.
	variable := model module statements second transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithMultipleVariables [

	| variable |
	self parseAndResolve: 'a = 1

b = 2

x = a + b

print(x)'.
	variable := model module statements third transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements third right.
			model module statements first right.
			model module statements second right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithPhiVariable [

	| variable |
	self parseAndResolve: 'if z > 3:
	y = 2
else:
	y = 3

x = y

print(x)'.

	variable := model module statements second transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements second right.
			model module statements first thenClause statements first right.
			model module statements first elseClause statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithReusedVariable [

	| variable |
	self parseAndResolve: 'x = 1

x = x + 1

print(x)'.
	variable := model module statements second transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: {
			model module statements second right.
			model module statements first right }
]

{ #category : 'tests - transitive' }
FASTPythonAssignedExpressionsInVariablesTest >> testTransitiveAssignedExpressionsWithoutTransitivity [

	| variable |
	self parseAndResolve: 'x = 5

print(x)'.
	variable := model module statements first transitiveAssignedExpressions.
	self assertCollection: variable hasSameElements: { model module statements first right }
]
