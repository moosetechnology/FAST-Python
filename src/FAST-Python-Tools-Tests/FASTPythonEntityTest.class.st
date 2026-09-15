Class {
	#name : 'FASTPythonEntityTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Core',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Core'
}

{ #category : 'testing' }
FASTPythonEntityTest class >> shouldInheritSelectors [

	^ false
]

{ #category : 'parsing' }
FASTPythonEntityTest >> sourceCodeWithTwoFunctions [

	^ 'import foo

def function_one():
    a = 1
    return a

def function_two():
    b = 2
    return b'
]

{ #category : 'tests' }
FASTPythonEntityTest >> testBoundaryLinesAreInclusive [

	self parse: self sourceCodeWithTwoFunctions.

	self assert: ((model module nodesIncludedBetween: 4 and: 4) includes: model module statements second statements first).
	self assert: ((model module nodesIncludedBetween: 5 and: 5) includes: model module statements second statements second)
]

{ #category : 'tests' }
FASTPythonEntityTest >> testIncludedNodesWithinLineRange [

	| nodes |
	self parse: self sourceCodeWithTwoFunctions.

	nodes := model module nodesIncludedBetween: 3 and: 5.

	self denyEmpty: nodes.
	self assert: (nodes includes: model module statements second).
	self deny: (nodes includes: model module statements first).
	self deny: (nodes includes: model module statements third).
	self assert: (nodes allSatisfy: [ :each | (each startLine between: 3 and: 5) and: [ each endLine between: 3 and: 5 ] ])
]

{ #category : 'tests' }
FASTPythonEntityTest >> testLineRangeCoveringWholeSourceIncludesAllStatements [

	| nodes |
	self parse: self sourceCodeWithTwoFunctions.

	nodes := model module nodesIncludedBetween: 1 and: 9.

	self assert: (nodes includes: model module statements first).
	self assert: (nodes includes: model module statements second).
	self assert: (nodes includes: model module statements third)
]

{ #category : 'tests' }
FASTPythonEntityTest >> testNoNodesWhenLineRangeIsOutsideSource [

	self parse: self sourceCodeWithTwoFunctions.

	self assertEmpty: (model module nodesIncludedBetween: 100 and: 200)
]

{ #category : 'tests' }
FASTPythonEntityTest >> testNodeStartingInsideButEndingOutsideIsExcluded [

	| nodes |
	self parse: self sourceCodeWithTwoFunctions.

	nodes := model module nodesIncludedBetween: 7 and: 8.

	self assert: (nodes includes: model module statements third statements first).
	self deny: (nodes includes: model module statements third statements second).
	self deny: (nodes includes: model module statements third)
]

{ #category : 'tests' }
FASTPythonEntityTest >> testPartiallyOverlappingNodesAreExcluded [

	| nodes |
	self parse: self sourceCodeWithTwoFunctions.

	nodes := model module nodesIncludedBetween: 4 and: 5.

	self assert: (nodes includes: model module statements second statements first).
	self assert: (nodes includes: model module statements second statements second).
	self deny: (nodes includes: model module statements second).
	self assert: (nodes allSatisfy: [ :each | (each startLine between: 4 and: 5) and: [ each endLine between: 4 and: 5 ] ])
]
