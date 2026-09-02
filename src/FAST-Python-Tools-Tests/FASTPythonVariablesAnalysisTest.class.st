"
I am a test case to test some analysis on variables in Python.
"
Class {
	#name : 'FASTPythonVariablesAnalysisTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Analysis',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Analysis'
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
FASTPythonVariablesAnalysisTest >> testAllResolvedVariablesByNameEmptyModel [
	| byName |
	self parseAndResolve: ''.

	byName := model allResolvedVariablesByName.

	self assert: byName isEmpty
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllResolvedVariablesByNameGroupsNames [
	| byName |
	self parseAndResolve: 'x = 1

x = 2

y = 3'.

	byName := model allResolvedVariablesByName.

	self assert: byName size equals: 2.
	self assert: byName keys asArray sort equals: #('x' 'y').
	self assert: (byName at: 'x') size equals: 2.
	self assert: (byName at: 'y') size equals: 1
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllResolvedVariablesByNameWithDistinctNames [
	| byName |
	self parseAndResolve: 'x = 1

y = 2

z = 3'.

	byName := model allResolvedVariablesByName.

	self assert: byName size equals: 3.
	self assert: byName keys asArray sort equals: #('x' 'y' 'z').
	self assert: (byName values allSatisfy: [ :each | each size = 1 ])
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSABasicVersionsExcludesPhiVersions [
	| versions |
	self parseAndResolve: 'if z > 3:
	x = 2
else:
	x = 3

print(x)'.

	versions := model module statements first thenClause statements first left allSSABasicVersions.

	self assert: versions size equals: 2.
	self assert: (versions noneSatisfy: [ :each | each isPhi ]).
	self assertCollection: (versions collect: [ :each | each version ]) asArray hasSameElements: { 1. 2 }
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSABasicVersionsFromAnyAccess [
	| writeAccess readAccess |
	self parseAndResolve: 'if z > 3:
	x = 2
else:
	x = 3

print(x)'.

	writeAccess := model module statements first thenClause statements first left.
	readAccess := model module statements last arguments first.

	self assert: writeAccess allSSABasicVersions size equals: 2.
	self assert: readAccess allSSABasicVersions size equals: 2
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSABasicVersionsOnReassignedVariable [
	| versions |
	self parseAndResolve: 'x = 1

print(x)

x = 2

print(x)'.

	versions := model module statements first left allSSABasicVersions.

	self assert: versions size equals: 2.
	self assertCollection: (versions collect: [ :each | each version ]) asArray hasSameElements: { 1. 2 }
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSABasicVersionsOnVariableWithOneVersion [
	| versions |
	self parseAndResolve: 'x = 1

print(x)'.

	versions := model module statements first left allSSABasicVersions.

	self assert: versions size equals: 1.
	self assert: versions anyOne version equals: 1
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSAVersionsFromAnyAccess [
	| writeAccess readAccess |
	self parseAndResolve: 'x = 1

print(x)

x = 2

print(x)'.

	writeAccess := model module statements first left.
	readAccess := model module statements last arguments first.

	self assert: writeAccess allSSAVersions size equals: 2.
	self assert: readAccess allSSAVersions size equals: 2
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSAVersionsIncludesPhiVersion [
	| versions |
	self parseAndResolve: 'if z > 3:
	x = 2
else:
	x = 3

print(x)'.

	versions := model module statements first thenClause statements first left allSSAVersions.

	self assert: versions size equals: 3.
	self assert: (versions count: [ :each | each isPhi ]) equals: 1
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSAVersionsOnReassignedVariable [
	| versions |
	self parseAndResolve: 'x = 1

print(x)

x = 2

print(x)'.

	versions := model module statements first left allSSAVersions.

	self assert: versions size equals: 2.
	self assertCollection: (versions collect: [ :each | each version ]) asArray hasSameElements: { 1. 2 }
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSAVersionsOnVariableWithOneVersion [
	| versions |
	self parseAndResolve: 'x = 1

print(x)'.

	versions := model module statements first left allSSAVersions.

	self assert: versions size equals: 1.
	self assert: versions anyOne version equals: 1
]

{ #category : 'tests' }
FASTPythonVariablesAnalysisTest >> testAllSSAVersionsOnlyForTheReceiverVariable [
	| versions |
	self parseAndResolve: 'x = 1

y = 2

x = 3

print(x)'.

	versions := model module statements first left allSSAVersions.

	self assert: versions size equals: 2.
	self assertCollection: (versions collect: [ :each | each version ]) asArray hasSameElements: { 1. 2 }
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
