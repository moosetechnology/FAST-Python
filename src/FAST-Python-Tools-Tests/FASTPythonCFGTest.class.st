Class {
	#name : 'FASTPythonCFGTest',
	#superclass : 'TestCase',
	#instVars : [
		'startBlock',
		'visitor'
	],
	#category : 'FAST-Python-Tools-Tests',
	#package : 'FAST-Python-Tools-Tests'
}

{ #category : 'running' }
FASTPythonCFGTest >> buildCFGFor: aString [

	self flag: #todo. "What should be the entry point?"
	startBlock := FASTPythonCFGVisitor buildCFGOf: (self parse: aString) allFunctionDefinitions first
]

{ #category : 'running' }
FASTPythonCFGTest >> parse: aString [

	^ FASTPythonImporter new
		  errorReportBlock: [ :i | i errors ifNotEmpty: [ self fail: 'Errors happened during parsing. Errors: ' , i errors printString ] ];
		  parse: aString withPlatformLineEndings
]

{ #category : 'tests - conditional expressions' }
FASTPythonCFGTest >> testFunctionWithConditionalExpression [

	| thenBlock elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    y()
    x() if i % 2 == 0 else y()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	self assert: (startBlock statements second class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).

	nullBlock := thenBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: elseBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithFor [

	| forBlock nullBlock |
	self buildCFGFor: 'def f(i):
    for x in i:
        print(x)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyIdentifier).
	self assert: (startBlock statements second class isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 1.
	self assert: (forBlock statements first isOfType: FASTPyCall).
	self assert: forBlock nextBlock equals: startBlock.
	
	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForConditionDoesNotMixWithPreviousStatements [
	"Since the for loop, we should not mix its condition with previous statements. "

	| forCondition forBlock nullBlock |
	self buildCFGFor: 'def f(i):
    y()
    for x in i:
        print(x)'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	
	forCondition := startBlock nextBlock.
	self assert: forCondition isConditional.
	self deny: forCondition isFinal.
	self assert: forCondition statements size equals: 2.
	self assert: (forCondition statements first class isOfType: FASTPyIdentifier).
	self assert: (forCondition statements second class isOfType: FASTPyIdentifier).
	self assert: forCondition nextBlocks size equals: 2.
	self assert: (forCondition nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := forCondition nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 1.
	self assert: (forBlock statements first isOfType: FASTPyCall).
	self assert: forBlock nextBlock equals: forCondition.

	nullBlock := forCondition nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithIfInElif [

	| thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock lastBlock |
	self buildCFGFor: 'def f(i):
	if i > 2:
		a() 
	elif i > 1:
		b()
		if i < 1.5:
			pass
		c()
	e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: thenBlock nextBlock equals: startBlock.

	elifConditionalBlock := startBlock nextFalseBlock.
	self assert: elifConditionalBlock isConditional.
	self deny: elifConditionalBlock isFinal.
	self assert: elifConditionalBlock statements size equals: 1.
	self assert: (elifConditionalBlock statements first isOfType: FASTPyComparisonOperator).

	ifConditionalBlock2 := elifConditionalBlock nextTrueBlock.
	self assert: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 2.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock2 statements second isOfType: FASTPyComparisonOperator).

	thenBlock2 := ifConditionalBlock2 nextTrueBlock.
	self deny: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 1.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyPassStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock nextBlock equals: thenBlock2 nextBlock.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).

	lastBlock := thenBlock nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: endOfElifBlock nextBlock.
	self assert: lastBlock equals: elifConditionalBlock nextFalseBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall)
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithIfInElif2 [

	| thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock elseBlock lastBlock |
	self buildCFGFor: 'def f(i):
	if i > 2:
		a() 
	elif i > 1:
		b()
		if i < 1.5:
			pass
		c()
	else:
		d()
	e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: thenBlock nextBlock equals: startBlock.

	elifConditionalBlock := startBlock nextFalseBlock.
	self assert: elifConditionalBlock isConditional.
	self deny: elifConditionalBlock isFinal.
	self assert: elifConditionalBlock statements size equals: 1.
	self assert: (elifConditionalBlock statements first isOfType: FASTPyComparisonOperator).

	ifConditionalBlock2 := elifConditionalBlock nextTrueBlock.
	self assert: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 2.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock2 statements second isOfType: FASTPyComparisonOperator).

	thenBlock2 := ifConditionalBlock2 nextTrueBlock.
	self deny: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 1.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyPassStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock nextBlock equals: thenBlock2 nextBlock.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).

	lastBlock := thenBlock nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: endOfElifBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall)
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThen [

	| thenBlock nextBlock |
	self buildCFGFor: 'def f(i):
    y()
    if i > 3:
        print(i)
    z()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	self assert: (startBlock statements second class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	nextBlock := startBlock nextFalseBlock.
	self deny: nextBlock isNullBlock.
	self assert: nextBlock identicalTo: thenBlock nextBlock.
	self assert: nextBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenAtEnd [

	| thenBlock nullBlock |
	self buildCFGFor: 'def f(i):
    y()
    if i > 3:
        print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	self assert: (startBlock statements second class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenAtStart [

	| thenBlock returnBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	returnBlock := startBlock nextFalseBlock.
	self deny: returnBlock isNullBlock.
	self assert: returnBlock identicalTo: thenBlock nextBlock.
	self assert: returnBlock isFinal.
	self assert: returnBlock statements size equals: 1.
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement)
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElif [

	| thenBlock elifConditionBlock elifBlock nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elifConditionBlock := startBlock nextFalseBlock.
	self assert: elifConditionBlock isConditional.
	self deny: elifConditionBlock isFinal.
	self assert: elifConditionBlock statements size equals: 1.
	self assert: (elifConditionBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 1.
	self assert: (elifBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := elifBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock nextBlock.
	self assert: nullBlock identicalTo: elifConditionBlock nextFalseBlock.
	self assert: nullBlock identicalTo: elifBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElif [

	| thenBlock elifConditionBlock elifBlock elifConditionBlock2 elifBlock2 nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass
    elif i < 10:
        a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elifConditionBlock := startBlock nextFalseBlock.
	self assert: elifConditionBlock isConditional.
	self deny: elifConditionBlock isFinal.
	self assert: elifConditionBlock statements size equals: 1.
	self assert: (elifConditionBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 1.
	self assert: (elifBlock statements first isOfType: FASTPyPassStatement).
	
	elifConditionBlock2 := elifConditionBlock nextFalseBlock.
	self assert: elifConditionBlock2 isConditional.
	self deny: elifConditionBlock2 isFinal.
	self assert: elifConditionBlock2 statements size equals: 1.
	self assert: (elifConditionBlock2 statements first isOfType: FASTPyComparisonOperator).

	elifBlock2 := elifConditionBlock2 nextTrueBlock.
	self deny: elifBlock2 isConditional.
	self deny: elifBlock2 isFinal.
	self assert: elifBlock2 statements size equals: 1.
	self assert: (elifBlock2 statements first isOfType: FASTPyCall).
	
	nullBlock := thenBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: elifBlock nextBlock.
	self assert: nullBlock identicalTo: elifConditionBlock2 nextFalseBlock.
	self assert: nullBlock identicalTo: elifBlock2 nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElifElse [

	| thenBlock elifConditionBlock elifBlock elifConditionBlock2 elifBlock2 elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass
    elif i < 10:
        a()
    else:
        b()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elifConditionBlock := startBlock nextFalseBlock.
	self assert: elifConditionBlock isConditional.
	self deny: elifConditionBlock isFinal.
	self assert: elifConditionBlock statements size equals: 1.
	self assert: (elifConditionBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 1.
	self assert: (elifBlock statements first isOfType: FASTPyPassStatement).
	
	elifConditionBlock2 := elifConditionBlock nextFalseBlock.
	self assert: elifConditionBlock2 isConditional.
	self deny: elifConditionBlock2 isFinal.
	self assert: elifConditionBlock2 statements size equals: 1.
	self assert: (elifConditionBlock2 statements first isOfType: FASTPyComparisonOperator).

	elifBlock2 := elifConditionBlock2 nextTrueBlock.
	self deny: elifBlock2 isConditional.
	self deny: elifBlock2 isFinal.
	self assert: elifBlock2 statements size equals: 1.
	self assert: (elifBlock2 statements first isOfType: FASTPyCall).

	elseBlock := elifConditionBlock2 nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	
	nullBlock := thenBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: elifBlock nextBlock.
	self assert: nullBlock identicalTo: elifBlock2 nextBlock.
	self assert: nullBlock identicalTo: elseBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElse [

	| thenBlock elifConditionBlock elifBlock elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass
    else:
      a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elifConditionBlock := startBlock nextFalseBlock.
	self assert: elifConditionBlock isConditional.
	self deny: elifConditionBlock isFinal.
	self assert: elifConditionBlock statements size equals: 1.
	self assert: (elifConditionBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 1.
	self assert: (elifBlock statements first isOfType: FASTPyPassStatement).

	elseBlock := elifConditionBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).

	nullBlock := elseBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock nextBlock.
	self assert: nullBlock identicalTo: elifBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElse [

	| thenBlock elseBlock returnBlock |
	self buildCFGFor: 'def f(i):
    y()
    if i > 3:
        print(i)
    else:
        pass
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	self assert: (startBlock statements second class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	returnBlock := thenBlock nextBlock.
	self deny: returnBlock isNullBlock.
	self assert: returnBlock identicalTo: elseBlock nextBlock.
	self assert: returnBlock isFinal.
	self assert: returnBlock statements size equals: 1.
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement)
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseAtEnd [

	| thenBlock elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    y()
    if i > 3:
        print(i)
    else:
        pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	self assert: (startBlock statements second class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := thenBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: elseBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseAtStart [

	| thenBlock elseBlock returnBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
        print(i)
    else:
        pass
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional not.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	returnBlock := thenBlock nextBlock.
	self deny: returnBlock isNullBlock.
	self assert: returnBlock identicalTo: elseBlock nextBlock.
	self assert: returnBlock isFinal.
	self assert: returnBlock statements size equals: 1.
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement)
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseInIfThen [

	| thenBlock thenBlock2 elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)
        else:
            pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first class isOfType: FASTPyCall).
	self assert: (thenBlock statements second class isOfType: FASTPyComparisonOperator).

	thenBlock2 := thenBlock nextTrueBlock.
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyCall).
	
	elseBlock := thenBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock2 nextBlock.
	self assert: nullBlock identicalTo: elseBlock nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenInIfThen [

	| thenBlock thenBlock2 nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first class isOfType: FASTPyCall).
	self assert: (thenBlock statements second class isOfType: FASTPyComparisonOperator).

	thenBlock2 := thenBlock nextTrueBlock.
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock nextFalseBlock.
	self assert: nullBlock identicalTo: thenBlock2 nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenInIfThenElse [

	| thenBlock thenBlock2 elseBlock nullBlock |
	self buildCFGFor: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)
    else:
      a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first class isOfType: FASTPyCall).
	self assert: (thenBlock statements second class isOfType: FASTPyComparisonOperator).

	thenBlock2 := thenBlock nextTrueBlock.
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyCall).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyCall).

	nullBlock := thenBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: elseBlock nextBlock.
	self assert: nullBlock identicalTo: thenBlock2 nextBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithOneStatement [

	self buildCFGFor: 'def funct():
	print("Hello")'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithSimpleReturn [

	self buildCFGFor: 'def funct():
	i = 0
	i += 4
	print(i)
	return i'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 4.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithSimpleStatements [

	self buildCFGFor: 'def funct():
	i = 0
	i += 4
	print(i)'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 3.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhile [

	| whileBlock nullBlock |
	self buildCFGFor: 'def f(i):
    while i < 4:
        i += 1
        print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	whileBlock := startBlock nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyAugmentedAssignment).
	self assert: (whileBlock statements second isOfType: FASTPyCall).
	self assert: whileBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileDoesNotMixWithPreviousStatements [
	"Since the while loop, we should not mix its condition with previous statements. "

	| whileCondition whileBlock nullBlock |
	self buildCFGFor: 'def f(i):
    y()
    while i < 4:
        i += 1
        print(i)'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyCall).
	
	whileCondition := startBlock nextBlock.
	self assert: whileCondition isConditional.
	self deny: whileCondition isFinal.
	self assert: whileCondition statements size equals: 1.
	self assert: (whileCondition statements first class isOfType: FASTPyComparisonOperator).
	self assert: whileCondition nextBlocks size equals: 2.
	self assert: (whileCondition nextBlocks select: #isNullBlock) size equals: 1.

	whileBlock := whileCondition nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyAugmentedAssignment).
	self assert: (whileBlock statements second isOfType: FASTPyCall).
	self assert: whileBlock nextBlock equals: whileCondition .

	nullBlock := whileCondition nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreak [

	| whileBlock nullBlock |
	self buildCFGFor: 'def f(i):
    while i < 4:
      y()
      break
      x()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	whileBlock := startBlock nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyCall).
	self assert: (whileBlock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: whileBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThen [

	| ifConditionalBlock thenBlock nullBlock |
	self buildCFGFor: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        break
        c()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenBreakingAndElse [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGFor: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        break
        c()
      else:
        d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	esleBlock := ifConditionalBlock nextFalseBlock.
	self deny: esleBlock isConditional.
	self deny: esleBlock isFinal.
	self assert: esleBlock statements size equals: 1.
	self assert: (esleBlock statements first isOfType: FASTPyCall).
	self assert: esleBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenBreakingAndElseBreaking [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGFor: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        break
        c()
      else:
        d()
        break
        e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	esleBlock := ifConditionalBlock nextFalseBlock.
	self deny: esleBlock isConditional.
	self deny: esleBlock isFinal.
	self assert: esleBlock statements size equals: 2.
	self assert: (esleBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: esleBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenElifAndElseAllBreaking [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGFor: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
			break
			c()
		elif i > 1:
			d()
			break
			e()
		else:
			f()
			break
			g()
	h()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	elifConditionalBlock := ifConditionalBlock nextFalseBlock.
	self assert: elifConditionalBlock isConditional.
	self deny: elifConditionalBlock isFinal.
	self assert: elifConditionalBlock statements size equals: 1.
	self assert: (elifConditionalBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionalBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 2.
	self assert: (elifBlock statements first isOfType: FASTPyCall).
	self assert: (elifBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock nextBlock.
	self assert: lastBlock equals: elifBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall)
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenElifBreakingAndElse [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGFor: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
		elif i > 1:
			c()
			break
			d()
		else:
			e()
	f()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: thenBlock nextBlock equals: startBlock.

	elifConditionalBlock := ifConditionalBlock nextFalseBlock.
	self assert: elifConditionalBlock isConditional.
	self deny: elifConditionalBlock isFinal.
	self assert: elifConditionalBlock statements size equals: 1.
	self assert: (elifConditionalBlock statements first isOfType: FASTPyComparisonOperator).

	elifBlock := elifConditionalBlock nextTrueBlock.
	self deny: elifBlock isConditional.
	self deny: elifBlock isFinal.
	self assert: elifBlock statements size equals: 2.
	self assert: (elifBlock statements first isOfType: FASTPyCall).
	self assert: (elifBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: elifBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall)
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithIfInElif [

	| ifConditionalBlock thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock elseBlock lastBlock |
	self buildCFGFor: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
		elif i > 1:
			c()
			if i < 1.5:
				break
			d()
		else:
			e()
	f()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first class isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 2.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: thenBlock nextBlock equals: startBlock.

	elifConditionalBlock := ifConditionalBlock nextFalseBlock.
	self assert: elifConditionalBlock isConditional.
	self deny: elifConditionalBlock isFinal.
	self assert: elifConditionalBlock statements size equals: 1.
	self assert: (elifConditionalBlock statements first isOfType: FASTPyComparisonOperator).

	ifConditionalBlock2 := elifConditionalBlock nextTrueBlock.
	self assert: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 2.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyCall).
	self assert: (ifConditionalBlock2 statements second isOfType: FASTPyComparisonOperator).

	thenBlock2 := ifConditionalBlock2 nextTrueBlock.
	self deny: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 1.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyBreakStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: ifConditionalBlock2 isConditional.
	self deny: ifConditionalBlock2 isFinal.
	self assert: ifConditionalBlock2 statements size equals: 1.
	self assert: (ifConditionalBlock2 statements first isOfType: FASTPyCall).
	self assert: ifConditionalBlock2 nextBlock equals: startBlock.
	
	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock2 nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall)
]
