"
I am a test case to test some analysis on variables in Python.
"
Class {
	#name : 'FASTPythonVariablesAnalysisTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Algos',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Algos'
}

{ #category : 'parsing' }
FASTPythonVariablesAnalysisTest >> parseAndResolve: aString [

	self parse: aString.
	FASTPythonSSAVisitor resolve: model module
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllAccessesOfIdentifier [

	| variable result |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variable := model module statements first left.
	result := variable allAccesses.
	self assert: result size equals: 5.

	self assertCollection: model module statements second arguments first allAccesses hasSameElements: result.
	self assertCollection: model module statements third left allAccesses hasSameElements: result.
	self assertCollection: model module statements fourth thenClause statements first left allAccesses hasSameElements: result.
	self assertCollection: model module statements fifth arguments first allAccesses hasSameElements: result
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllReadAccessesOfIdentifier [

	| variable result |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variable := model module statements first left.
	result := variable allReadAccesses.
	self assert: result size equals: 2.
	self assertCollection: result hasSameElements: {
			model module statements second arguments first.
			model module statements fifth arguments first }.

	self assertCollection: model module statements second arguments first allReadAccesses hasSameElements: result.
	self assertCollection: model module statements third left allReadAccesses hasSameElements: result.
	self assertCollection: model module statements fourth thenClause statements first left allReadAccesses hasSameElements: result.
	self assertCollection: model module statements fifth arguments first allReadAccesses hasSameElements: result
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllWriteAccessesOfIdentifier [

	| variable result |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variable := model module statements first left.
	result := variable allWriteAccesses.
	self assert: result size equals: 3.
	self assertCollection: result hasSameElements: {
			model module statements first left.
			model module statements third left.
			model module statements fourth thenClause statements first left }.

	self assertCollection: model module statements second arguments first allWriteAccesses hasSameElements: result.
	self assertCollection: model module statements third left allWriteAccesses hasSameElements: result.
	self assertCollection: model module statements fourth thenClause statements first left allWriteAccesses hasSameElements: result.
	self assertCollection: model module statements fifth arguments first allWriteAccesses hasSameElements: result
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAssignedExpressionsMap [

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
FASTPythonVariablesAnalysisTest >> testVersionAccessesOfIdentifier [

	| variableVersion1 variableVersion2 variableVersion3 variablePhi |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variableVersion1 := model module statements first left.
	self assert: variableVersion1 versionAccesses size equals: 2.
	self assertCollection: variableVersion1 versionAccesses hasSameElements: {
			variableVersion1.
			model module statements second arguments first }.

	variableVersion2 := model module statements third left.
	self assertCollection: variableVersion2 versionAccesses hasSameElements: {
			variableVersion2.
			model module statements fifth arguments first }.

	variableVersion3 := model module statements fourth thenClause statements first left.
	self assertCollection: variableVersion3 versionAccesses hasSameElements: {
			variableVersion3.
			model module statements fifth arguments first }.

	variablePhi := model module statements fifth arguments first.
	self assertCollection: variablePhi versionAccesses hasSameElements: {
			variableVersion2.
			variableVersion3.
			model module statements fifth arguments first }
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testVersionReadAccessesOfIdentifier [

	| variableVersion1 variableVersion2 variableVersion3 variablePhi |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variableVersion1 := model module statements first left.
	self assertCollection: variableVersion1 versionReadAccesses hasSameElements: { model module statements second arguments first }.

	variableVersion2 := model module statements third left.
	self assertCollection: variableVersion2 versionReadAccesses hasSameElements: { model module statements fifth arguments first }.

	variableVersion3 := model module statements fourth thenClause statements first left.
	self assertCollection: variableVersion3 versionReadAccesses hasSameElements: { model module statements fifth arguments first }.

	variablePhi := model module statements fifth arguments first.
	self assertCollection: variablePhi versionReadAccesses hasSameElements: { model module statements fifth arguments first }
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testVersionWriteAccessesOfIdentifier [

	| variableVersion1 variableVersion2 variableVersion3 variablePhi |
	self parseAndResolve: 'x = 1
	
print(x)

x = 2

if y > 3:
	x = 3

print(x)'.

	variableVersion1 := model module statements first left.
	self assertCollection: variableVersion1 versionWriteAccesses hasSameElements: { variableVersion1 }.

	variableVersion2 := model module statements third left.
	self assertCollection: variableVersion2 versionWriteAccesses hasSameElements: { variableVersion2 }.

	variableVersion3 := model module statements fourth thenClause statements first left.
	self assertCollection: variableVersion3 versionWriteAccesses hasSameElements: { variableVersion3 }.

	variablePhi := model module statements fifth arguments first.
	self assertCollection: variablePhi versionWriteAccesses hasSameElements: {
			variableVersion2.
			variableVersion3 }
]
