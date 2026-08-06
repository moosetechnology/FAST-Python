Class {
	#name : 'FASTPythonCFGTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#instVars : [
		'startBlock'
	],
	#category : 'FAST-Python-Tools-Tests-Algos',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Algos'
}

{ #category : 'running' }
FASTPythonCFGTest >> buildCFGForFunction: aString [

	startBlock := FASTPythonCFGVisitor buildCFGOf: (self parse: aString) allFunctionDefinitions first
]

{ #category : 'tests' }
FASTPythonCFGTest >> testCFGOfClass [

	startBlock := FASTPythonCFGVisitor buildCFGOf: (self parse: 'class Class():
	i = 0
	
	def funct2(i):
		var = i + 4
		return var
	
	i = funct2(i)
	print(i)
	return i') allClassDefinitions first.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 5.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testCFGOfFunction [

	startBlock := FASTPythonCFGVisitor buildCFGOf: (self parse: 'def funct():
	i = 0
	
	def funct2(i):
		var = i + 4
		return var
	
	i = funct2(i)
	print(i)
	return i') allFunctionDefinitions first.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 5.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testCFGOfLambda [

	startBlock := FASTPythonCFGVisitor buildCFGOf: ((self parse: 'lambda x: im_path_ls[name_ls.index(x)]') allWithType: FASTPyLambda) first.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testCFGOfModule [

	startBlock := FASTPythonCFGVisitor buildCFGOf: (self parse: 'i = 0

def funct2(i):
	var = i + 4
	return var

i = funct2(i)
print(i)') allModules first.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 4.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testContainingLambdas [
	"Regression test. The CFG was duplicating the lambda node until now."

	self buildCFGForFunction: 'def funct():
	l = lambda x: x + 2
	l(4)'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionInFunction [
	
	self buildCFGForFunction: 'def funct():
	i = 0
	
	def funct2(i):
		var = i + 4
		return var
	
	i = funct2(i)
	print(i)
	return i'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 5.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithCodeAfterReturn [

	self buildCFGForFunction: 'def i():
    return 3
    if y > 4:
	a()'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyReturnStatement).
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests - conditional expressions' }
FASTPythonCFGTest >> testFunctionWithConditionalExpression [

	| thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    x() if i % 2 == 0 else y()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyComparisonOperator).
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
	self buildCFGForFunction: 'def f(i):
    for x in i:
        print(x)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 2.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: forBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForConditionDoesNotMixWithPreviousStatements [
	"Since the for loop, we should not mix its condition with previous statements. "

	| forCondition forBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    for x in i:
        print(x)'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).

	forCondition := startBlock nextBlock.
	self assert: forCondition isConditional.
	self deny: forCondition isFinal.
	self assert: forCondition statements size equals: 1.
	self assert: (forCondition statements first isOfType: FASTPyIdentifier).
	self assert: forCondition nextBlocks size equals: 2.
	self assert: (forCondition nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := forCondition nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 2.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: forBlock nextBlock equals: forCondition.

	nullBlock := forCondition nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: forCondition mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreak [

	| forBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
     for x in i:
      y()
      break
      x()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 3.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: (forBlock statements third isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: forBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThen [

	| ifConditionalBlock thenBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        break
        c()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThen2 [

	| ifConditionalBlock thenBlock endOfFor nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        break
        c()
      d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	endOfFor := ifConditionalBlock nextFalseBlock.
	self deny: endOfFor isConditional.
	self deny: endOfFor isFinal.
	self assert: endOfFor statements size equals: 1.
	self assert: (endOfFor statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThenBreakingAndElse [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
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
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThenBreakingAndElseBreaking [

	| ifConditionalBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
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
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: elseBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThenElifAndElseAllBreaking [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
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
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

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
	self assert: (elseBlock statements second isOfType: FASTPyBreakStatement).

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock nextBlock.
	self assert: lastBlock equals: elifBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakInIfThenElifBreakingAndElse [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
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
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

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
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithBreakingIfThenElse [

	| ifConditionalBlock thenBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		a()
		if i > 2:
			b() 
			break
			c()
		else:
			d()
			break
			e()
		f()
	g()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyBreakStatement).

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinue [

	| forBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
     for x in i:
      y()
      continue
      x()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 3.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: (forBlock statements third isOfType: FASTPyContinueStatement).
	self assert: forBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThen [

	| ifConditionalBlock thenBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        continue
        c()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThen2 [

	| ifConditionalBlock thenBlock endOfFor nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        continue
        c()
      d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	endOfFor := ifConditionalBlock nextFalseBlock.
	self deny: endOfFor isConditional.
	self deny: endOfFor isFinal.
	self assert: endOfFor statements size equals: 1.
	self assert: (endOfFor statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThenContinuingAndElse [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        continue
        c()
      else:
        d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	esleBlock := ifConditionalBlock nextFalseBlock.
	self deny: esleBlock isConditional.
	self deny: esleBlock isFinal.
	self assert: esleBlock statements size equals: 1.
	self assert: (esleBlock statements first isOfType: FASTPyCall).
	self assert: esleBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThenContinuingAndElseContinuing [

	| ifConditionalBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    for x in i:
      a()
      if i > 2:
        b() 
        continue
        c()
      else:
        d()
        continue
        e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThenElifAndElseAllContinuing [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		a()
		if i > 2:
			b() 
			continue
			c()
		elif i > 1:
			d()
			continue
			e()
		else:
			f()
			continue
			g()
	h()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
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
	self assert: (elifBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elifBlock nextBlock equals: startBlock.

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinueInIfThenElifContinuingAndElse [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		a()
		if i > 2:
			b() 
		elif i > 1:
			c()
			continue
			d()
		else:
			e()
	f()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

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
	self assert: (elifBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elifBlock nextBlock equals: startBlock.

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithContinuingIfThenElse [

	| ifConditionalBlock thenBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		a()
		if i > 2:
			b() 
			continue
			c()
		else:
			d()
			continue
			e()
		f()
	g()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionalBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithElseWithBreakInAllBranches [

	| forBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		print(i)
		break
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 3.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: (forBlock statements third isOfType: FASTPyBreakStatement).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := elseBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: forBlock nextBlock.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithElseWithBreakInIf [

	| forBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		print(i)
		if 1 > 2:
			break
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	forBlock := startBlock nextTrueBlock.
	self assert: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 3.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: (forBlock statements third isOfType: FASTPyComparisonOperator).
	self assert: forBlock nextFalseBlock equals: startBlock.

	thenBlock := forBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyBreakStatement).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := elseBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock.
	self assert: nullBlock equals: forBlock mergeBlock
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithElseWithoutBreak [

	| forBlock elseBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
		print(i)
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	forBlock := startBlock nextTrueBlock.
	self deny: forBlock isConditional.
	self deny: forBlock isFinal.
	self assert: forBlock statements size equals: 2.
	self assert: (forBlock statements first isOfType: FASTPyIdentifier).
	self assert: (forBlock statements second isOfType: FASTPyCall).
	self assert: forBlock nextBlock equals: startBlock.

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self assert: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement)
]

{ #category : 'tests - for' }
FASTPythonCFGTest >> testFunctionWithForWithIfInElif [

	| ifConditionalBlock thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	for x in i:
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
	self assert: (startBlock statements first isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	ifConditionalBlock := startBlock nextTrueBlock.
	self assert: ifConditionalBlock isConditional.
	self deny: ifConditionalBlock isFinal.
	self assert: ifConditionalBlock statements size equals: 3.
	self assert: (ifConditionalBlock statements first isOfType: FASTPyIdentifier).
	self assert: (ifConditionalBlock statements second isOfType: FASTPyCall).
	self assert: (ifConditionalBlock statements third isOfType: FASTPyComparisonOperator).

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
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyBreakStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).
	self assert: endOfElifBlock nextBlock equals: startBlock.

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
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfInElif [

	| thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

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
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyPassStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock equals: thenBlock2 nextBlock.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).
	self assert: endOfElifBlock equals: ifConditionalBlock2 mergeBlock.

	lastBlock := thenBlock nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: endOfElifBlock nextBlock.
	self assert: lastBlock equals: elifConditionalBlock nextFalseBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfInElif2 [

	| thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyCall).

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
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyPassStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock equals: thenBlock2 nextBlock.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).
	self assert: endOfElifBlock equals: ifConditionalBlock2 mergeBlock.

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
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThen [

	| thenBlock nextBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    if i > 3:
        print(i)
    z()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyComparisonOperator).
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
	self assert: nextBlock isFinal.
	self assert: nextBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenAtEnd [

	| thenBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    if i > 3:
        print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenAtStart [

	| thenBlock returnBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
        print(i)
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement).
	self assert: returnBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElif [

	| thenBlock elifConditionBlock elifBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElif [

	| thenBlock elifConditionBlock elifBlock elifConditionBlock2 elifBlock2 nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass
    elif i < 10:
        a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElifElse [

	| thenBlock elifConditionBlock elifBlock elifConditionBlock2 elifBlock2 elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElifElse [

	| thenBlock elifConditionBlock elifBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
        print(i)
    elif i < 8:
        pass
    else:
      a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElse [

	| thenBlock elseBlock returnBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    if i > 3:
        print(i)
    else:
        pass
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyComparisonOperator).
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
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement).
	self assert: returnBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseAtEnd [

	| thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    if i > 3:
        print(i)
    else:
        pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseAtStart [

	| thenBlock elseBlock returnBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
        print(i)
    else:
        pass
    return True'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (returnBlock statements first isOfType: FASTPyReturnStatement).
	self assert: returnBlock equals: startBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenElseInIfThen [

	| thenBlock thenBlock2 elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)
        else:
            pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyComparisonOperator).

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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock.
	self assert: nullBlock equals: thenBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenInIfThen [

	| thenBlock thenBlock2 nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyComparisonOperator).

	thenBlock2 := thenBlock nextTrueBlock.
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock identicalTo: thenBlock nextFalseBlock.
	self assert: nullBlock identicalTo: thenBlock2 nextBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock.
	self assert: nullBlock equals: thenBlock mergeBlock
]

{ #category : 'tests - if' }
FASTPythonCFGTest >> testFunctionWithIfThenInIfThenElse [

	| thenBlock thenBlock2 elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    if i > 3:
	y()
        if i < 5:
            print(i)
    else:
      a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	thenBlock := startBlock nextTrueBlock.
	self assert: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyComparisonOperator).

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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock.
	self assert: nullBlock equals: thenBlock mergeBlock
]

{ #category : 'tests - match' }
FASTPythonCFGTest >> testFunctionWithMatch [

	| case1 case2 defaultCase lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	match day:
		case "Saturday" | "Sunday":
			print(f"{day} is a weekend.")
		case "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday":
			print(f"{day} is a weekday.")
		case _:
			print("That''s not a valid day of the week.")
	b()'.

	self assert: startBlock isConditional.
	self assert: startBlock isSwitch.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 3.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	self assert: ((startBlock patterns at: 1) isOfType: FASTPyUnionPattern).
	case1 := startBlock nextBlocks at: 1.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	self assert: ((startBlock patterns at: 2) isOfType: FASTPyUnionPattern).
	case2 := startBlock nextBlocks at: 2.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	self assert: (startBlock patterns at: 3) isNil.
	defaultCase := startBlock nextBlocks at: 3.
	self assert: defaultCase equals: startBlock defaultCase.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	lastBlock := case1 nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: case2 nextBlock.
	self assert: lastBlock equals: defaultCase nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - match' }
FASTPythonCFGTest >> testFunctionWithMatchWith2IdenticalCase [
	"If two cases have the same pattern, only the first one wins."
	| case1 defaultCase lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	match day:
		case 1:
			a()
		case 1:
			pass
		case _:
			c()
	b()'.

	self assert: startBlock isConditional.
	self assert: startBlock isSwitch.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	self assert: ((startBlock patterns at: 1) isOfType: FASTPyInteger).
	case1 := startBlock nextBlocks at: 1.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	self assert: (startBlock patterns at: 2) isNil.
	defaultCase := startBlock nextBlocks at: 2.
	self assert: defaultCase equals: startBlock defaultCase.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	lastBlock := case1 nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: defaultCase nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - match' }
FASTPythonCFGTest >> testFunctionWithMatchWithCondition [

	| case1 case1Pattern case2 defaultCase lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	match day:
		case 1 if n > 10:
			a()
		case 1:
			b()
		case _:
			c()
	b()'.

	self assert: startBlock isConditional.
	self assert: startBlock isSwitch.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 2.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: (startBlock statements second isOfType: FASTPyIdentifier).
	self assert: startBlock nextBlocks size equals: 3.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	case1Pattern := startBlock patterns at: 1.
	self assert: case1Pattern isCollection.
	self assert: (case1Pattern first isOfType: FASTPyInteger).
	self assert: (case1Pattern second isOfType: FASTPyComparisonOperator).
	case1 := startBlock nextBlocks at: 1.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	self assert: ((startBlock patterns at: 2) isOfType: FASTPyInteger).
	case2 := startBlock nextBlocks at: 2.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	self assert: (startBlock patterns at: 3) isNil.
	defaultCase := startBlock nextBlocks at: 3.
	self assert: defaultCase equals: startBlock defaultCase.
	self deny: case1 isConditional.
	self deny: case1 isFinal.
	self assert: case1 statements size equals: 1.
	self assert: (case1 statements first isOfType: FASTPyCall).

	lastBlock := case1 nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: case2 nextBlock.
	self assert: lastBlock equals: defaultCase nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithOneStatement [

	self buildCFGForFunction: 'def funct():
	print("Hello")'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests' }
FASTPythonCFGTest >> testFunctionWithSimpleReturn [

	self buildCFGForFunction: 'def funct():
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

	self buildCFGForFunction: 'def funct():
	i = 0
	i += 4
	print(i)'.

	self assert: startBlock isStart.
	self assert: startBlock isFinal.
	self assert: startBlock statements size equals: 3.
	self assertEmpty: startBlock nextBlocks
]

{ #category : 'tests - try' }
FASTPythonCFGTest >> testFunctionWithTry [

	| tryBlock exceptBlock lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	try:
		b()
		c()
		d()
	except Exception1:
		e()
	f()'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: startBlock nextBlocks size equals: 1.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	tryBlock := startBlock nextBlock.
	self assert: tryBlock isConditional.
	self assert: tryBlock isTry.
	self deny: tryBlock isFinal.
	self assert: tryBlock statements size equals: 3.
	self assert: (tryBlock statements first isOfType: FASTPyCall).
	self assert: (tryBlock statements second isOfType: FASTPyCall).
	self assert: (tryBlock statements third isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 1) isOfType: FASTPyIdentifier).
	exceptBlock := tryBlock nextBlocks at: 1.
	self deny: exceptBlock isConditional.
	self deny: exceptBlock isFinal.
	self assert: exceptBlock statements size equals: 1.
	self assert: (exceptBlock statements first isOfType: FASTPyCall).

	self assert: (tryBlock patterns at: 2) isNil.
	lastBlock := tryBlock nextBlocks at: 2.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: exceptBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: tryBlock mergeBlock
]

{ #category : 'tests - try' }
FASTPythonCFGTest >> testFunctionWithTryWihtMultipleExcepts [

	| tryBlock exceptBlock exceptBlock2 exceptBlock3 lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	try:
		b()
		c()
		d()
	except Exception1:
		e()
	except Exception2:
		f()
	except Exception3:
		g()
	h()'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: startBlock nextBlocks size equals: 1.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	tryBlock := startBlock nextBlock.
	self assert: tryBlock isConditional.
	self assert: tryBlock isTry.
	self deny: tryBlock isFinal.
	self assert: tryBlock statements size equals: 3.
	self assert: (tryBlock statements first isOfType: FASTPyCall).
	self assert: (tryBlock statements second isOfType: FASTPyCall).
	self assert: (tryBlock statements third isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 1) isOfType: FASTPyIdentifier).
	exceptBlock := tryBlock nextBlocks at: 1.
	self deny: exceptBlock isConditional.
	self deny: exceptBlock isFinal.
	self assert: exceptBlock statements size equals: 1.
	self assert: (exceptBlock statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 2) isOfType: FASTPyIdentifier).
	exceptBlock2 := tryBlock nextBlocks at: 2.
	self deny: exceptBlock2 isConditional.
	self deny: exceptBlock2 isFinal.
	self assert: exceptBlock2 statements size equals: 1.
	self assert: (exceptBlock2 statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 3) isOfType: FASTPyIdentifier).
	exceptBlock3 := tryBlock nextBlocks at: 3.
	self deny: exceptBlock3 isConditional.
	self deny: exceptBlock3 isFinal.
	self assert: exceptBlock3 statements size equals: 1.
	self assert: (exceptBlock3 statements first isOfType: FASTPyCall).

	self assert: (tryBlock patterns at: 4) isNil.
	lastBlock := tryBlock nextBlocks at: 4.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: exceptBlock nextBlock.
	self assert: lastBlock equals: exceptBlock2 nextBlock.
	self assert: lastBlock equals: exceptBlock3 nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: tryBlock mergeBlock
]

{ #category : 'tests - try' }
FASTPythonCFGTest >> testFunctionWithTryWithElse [

	| tryBlock exceptBlock exceptBlock2 exceptBlock3 elseBlock lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	try:
		b()
		c()
		d()
	except Exception1:
		e()
	except Exception2:
		f()
	except Exception3:
		g()
	else: 
		h()
	i()'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: startBlock nextBlocks size equals: 1.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	tryBlock := startBlock nextBlock.
	self assert: tryBlock isConditional.
	self assert: tryBlock isTry.
	self deny: tryBlock isFinal.
	self assert: tryBlock statements size equals: 3.
	self assert: (tryBlock statements first isOfType: FASTPyCall).
	self assert: (tryBlock statements second isOfType: FASTPyCall).
	self assert: (tryBlock statements third isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 1) isOfType: FASTPyIdentifier).
	exceptBlock := tryBlock nextBlocks at: 1.
	self deny: exceptBlock isConditional.
	self deny: exceptBlock isFinal.
	self assert: exceptBlock statements size equals: 1.
	self assert: (exceptBlock statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 2) isOfType: FASTPyIdentifier).
	exceptBlock2 := tryBlock nextBlocks at: 2.
	self deny: exceptBlock2 isConditional.
	self deny: exceptBlock2 isFinal.
	self assert: exceptBlock2 statements size equals: 1.
	self assert: (exceptBlock2 statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 3) isOfType: FASTPyIdentifier).
	exceptBlock3 := tryBlock nextBlocks at: 3.
	self deny: exceptBlock3 isConditional.
	self deny: exceptBlock3 isFinal.
	self assert: exceptBlock3 statements size equals: 1.
	self assert: (exceptBlock3 statements first isOfType: FASTPyCall).


	self assert: (tryBlock patterns at: 4) isNil.
	elseBlock := tryBlock nextBlocks at: 4.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).

	lastBlock := elseBlock nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: exceptBlock nextBlock.
	self assert: lastBlock equals: exceptBlock2 nextBlock.
	self assert: lastBlock equals: exceptBlock3 nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: tryBlock mergeBlock
]

{ #category : 'tests - try' }
FASTPythonCFGTest >> testFunctionWithTryWithElseAndFinally [

	| tryBlock exceptBlock exceptBlock2 exceptBlock3 elseBlock lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	try:
		b()
		c()
		d()
	except Exception1:
		e()
	except Exception2:
		f()
	except Exception3:
		g()
	else: 
		h()
	finally: 
		i()
	j()'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: startBlock nextBlocks size equals: 1.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	tryBlock := startBlock nextBlock.
	self assert: tryBlock isConditional.
	self assert: tryBlock isTry.
	self deny: tryBlock isFinal.
	self assert: tryBlock statements size equals: 3.
	self assert: (tryBlock statements first isOfType: FASTPyCall).
	self assert: (tryBlock statements second isOfType: FASTPyCall).
	self assert: (tryBlock statements third isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 1) isOfType: FASTPyIdentifier).
	exceptBlock := tryBlock nextBlocks at: 1.
	self deny: exceptBlock isConditional.
	self deny: exceptBlock isFinal.
	self assert: exceptBlock statements size equals: 1.
	self assert: (exceptBlock statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 2) isOfType: FASTPyIdentifier).
	exceptBlock2 := tryBlock nextBlocks at: 2.
	self deny: exceptBlock2 isConditional.
	self deny: exceptBlock2 isFinal.
	self assert: exceptBlock2 statements size equals: 1.
	self assert: (exceptBlock2 statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 3) isOfType: FASTPyIdentifier).
	exceptBlock3 := tryBlock nextBlocks at: 3.
	self deny: exceptBlock3 isConditional.
	self deny: exceptBlock3 isFinal.
	self assert: exceptBlock3 statements size equals: 1.
	self assert: (exceptBlock3 statements first isOfType: FASTPyCall).

	self assert: (tryBlock patterns at: 4) isNil.
	elseBlock := tryBlock nextBlocks at: 4.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).

	lastBlock := elseBlock nextBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: exceptBlock nextBlock.
	self assert: lastBlock equals: exceptBlock2 nextBlock.
	self assert: lastBlock equals: exceptBlock3 nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 2.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: (lastBlock statements second isOfType: FASTPyCall).
	self assert: lastBlock equals: tryBlock mergeBlock
]

{ #category : 'tests - try' }
FASTPythonCFGTest >> testFunctionWithTryWithFinally [

	| tryBlock exceptBlock exceptBlock2 exceptBlock3 lastBlock |
	self buildCFGForFunction: 'def f(day):
	a()
	try:
		b()
		c()
		d()
	except Exception1:
		e()
	except Exception2:
		f()
	except Exception3:
		g()
	finally: 
		h()
	i()'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).
	self assert: startBlock nextBlocks size equals: 1.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	tryBlock := startBlock nextBlock.
	self assert: tryBlock isConditional.
	self assert: tryBlock isTry.
	self deny: tryBlock isFinal.
	self assert: tryBlock statements size equals: 3.
	self assert: (tryBlock statements first isOfType: FASTPyCall).
	self assert: (tryBlock statements second isOfType: FASTPyCall).
	self assert: (tryBlock statements third isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 1) isOfType: FASTPyIdentifier).
	exceptBlock := tryBlock nextBlocks at: 1.
	self deny: exceptBlock isConditional.
	self deny: exceptBlock isFinal.
	self assert: exceptBlock statements size equals: 1.
	self assert: (exceptBlock statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 2) isOfType: FASTPyIdentifier).
	exceptBlock2 := tryBlock nextBlocks at: 2.
	self deny: exceptBlock2 isConditional.
	self deny: exceptBlock2 isFinal.
	self assert: exceptBlock2 statements size equals: 1.
	self assert: (exceptBlock2 statements first isOfType: FASTPyCall).

	self assert: ((tryBlock patterns at: 3) isOfType: FASTPyIdentifier).
	exceptBlock3 := tryBlock nextBlocks at: 3.
	self deny: exceptBlock3 isConditional.
	self deny: exceptBlock3 isFinal.
	self assert: exceptBlock3 statements size equals: 1.
	self assert: (exceptBlock3 statements first isOfType: FASTPyCall).

	self assert: (tryBlock patterns at: 4) isNil.
	lastBlock := tryBlock nextBlocks at: 4.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: exceptBlock nextBlock.
	self assert: lastBlock equals: exceptBlock2 nextBlock.
	self assert: lastBlock equals: exceptBlock3 nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 2.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: (lastBlock statements second isOfType: FASTPyCall).
	self assert: lastBlock equals: tryBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhile [

	| whileBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
        i += 1
        print(i)'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileBreakingInWhile [

	| trueWhile whileConditionalBlock2 thenBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		a()
		while i < 2:
			b() 
			break
			c()
		d()
	e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	trueWhile := startBlock nextTrueBlock.
	self deny: trueWhile isConditional.
	self deny: trueWhile isFinal.
	self assert: trueWhile statements size equals: 1.
	self assert: (trueWhile statements first isOfType: FASTPyCall).

	whileConditionalBlock2 := trueWhile nextBlock.
	self assert: whileConditionalBlock2 isConditional.
	self deny: whileConditionalBlock2 isFinal.
	self assert: whileConditionalBlock2 statements size equals: 1.
	self assert: (whileConditionalBlock2 statements first isOfType: FASTPyComparisonOperator).

	thenBlock := whileConditionalBlock2 nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 2.
	self assert: (thenBlock statements first isOfType: FASTPyCall).
	self assert: (thenBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := whileConditionalBlock2 nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock equals: thenBlock nextBlock.
	self assert: elseBlock nextBlock equals: startBlock.
	self assert: elseBlock equals: whileConditionalBlock2 mergeBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileBreakingInWhile2 [

	| whileConditionBlock ifConditionBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		while i < 2:
			if i < 1:
				break
			else:
				a()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	whileConditionBlock := startBlock nextTrueBlock.
	self assert: whileConditionBlock isConditional.
	self deny: whileConditionBlock isFinal.
	self assert: whileConditionBlock statements size equals: 1.
	self assert: (whileConditionBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: whileConditionBlock nextFalseBlock equals: startBlock.

	ifConditionBlock := whileConditionBlock nextTrueBlock.
	self assert: ifConditionBlock isConditional.
	self deny: ifConditionBlock isFinal.
	self assert: ifConditionBlock statements size equals: 1.
	self assert: (ifConditionBlock statements first isOfType: FASTPyComparisonOperator).

	thenBlock := ifConditionBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyBreakStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	elseBlock := ifConditionBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock nextBlock equals: whileConditionBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock.
	self assert: nullBlock equals: whileConditionBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileDoesNotMixWithPreviousStatements [
	"Since the while loop, we should not mix its condition with previous statements. "

	| whileCondition whileBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    y()
    while i < 4:
        i += 1
        print(i)'.

	self deny: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyCall).

	whileCondition := startBlock nextBlock.
	self assert: whileCondition isConditional.
	self deny: whileCondition isFinal.
	self assert: whileCondition statements size equals: 1.
	self assert: (whileCondition statements first isOfType: FASTPyComparisonOperator).
	self assert: whileCondition nextBlocks size equals: 2.
	self assert: (whileCondition nextBlocks select: #isNullBlock) size equals: 1.

	whileBlock := whileCondition nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyAugmentedAssignment).
	self assert: (whileBlock statements second isOfType: FASTPyCall).
	self assert: whileBlock nextBlock equals: whileCondition.

	nullBlock := whileCondition nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: whileCondition mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreak [

	| whileBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      y()
      break
      x()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThen [

	| ifConditionalBlock thenBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        break
        c()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThen2 [

	| ifConditionalBlock thenBlock endOfWhile nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        break
        c()
      d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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

	endOfWhile := ifConditionalBlock nextFalseBlock.
	self deny: endOfWhile isConditional.
	self deny: endOfWhile isFinal.
	self assert: endOfWhile statements size equals: 1.
	self assert: (endOfWhile statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenBreakingAndElse [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenBreakingAndElseBreaking [

	| ifConditionalBlock thenBlock elseblock nullBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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

	elseblock := ifConditionalBlock nextFalseBlock.
	self deny: elseblock isConditional.
	self deny: elseblock isFinal.
	self assert: elseblock statements size equals: 2.
	self assert: (elseblock statements first isOfType: FASTPyCall).
	self assert: (elseblock statements second isOfType: FASTPyBreakStatement).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: thenBlock nextBlock equals: nullBlock.
	self assert: elseblock nextBlock equals: nullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenElifAndElseAllBreaking [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (elseBlock statements second isOfType: FASTPyBreakStatement).

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock nextBlock.
	self assert: lastBlock equals: elifBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakInIfThenElifBreakingAndElse [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithBreakingIfThenElse [

	| ifConditionalBlock thenBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
			break
			c()
		else:
			d()
			break
			e()
		f()
	g()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyBreakStatement).

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock equals: thenBlock nextBlock.
	self assert: lastBlock equals: elseBlock nextBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinue [

	| whileBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      y()
      continue
      x()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assert: (startBlock nextBlocks select: #isNullBlock) size equals: 1.

	whileBlock := startBlock nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyCall).
	self assert: (whileBlock statements second isOfType: FASTPyContinueStatement).
	self assert: whileBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThen [

	| ifConditionalBlock thenBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        continue
        c()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThen2 [

	| ifConditionalBlock thenBlock endOfWhile nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        continue
        c()
      d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	endOfWhile := ifConditionalBlock nextFalseBlock.
	self deny: endOfWhile isConditional.
	self deny: endOfWhile isFinal.
	self assert: endOfWhile statements size equals: 1.
	self assert: (endOfWhile statements first isOfType: FASTPyCall).

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThenContinuingAndElse [

	| ifConditionalBlock thenBlock esleBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        continue
        c()
      else:
        d()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	esleBlock := ifConditionalBlock nextFalseBlock.
	self deny: esleBlock isConditional.
	self deny: esleBlock isFinal.
	self assert: esleBlock statements size equals: 1.
	self assert: (esleBlock statements first isOfType: FASTPyCall).
	self assert: esleBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThenContinuingAndElseContinuing [

	| ifConditionalBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
    while i < 4:
      a()
      if i > 2:
        b() 
        continue
        c()
      else:
        d()
        continue
        e()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	nullBlock := startBlock nextFalseBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThenElifAndElseAllContinuing [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
			continue
			c()
		elif i > 1:
			d()
			continue
			e()
		else:
			f()
			continue
			g()
	h()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
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
	self assert: (elifBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elifBlock nextBlock equals: startBlock.

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinueInIfThenElifContinuingAndElse [

	| ifConditionalBlock thenBlock elifConditionalBlock elifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
		elif i > 1:
			c()
			continue
			d()
		else:
			e()
	f()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (elifBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elifBlock nextBlock equals: startBlock.

	elseBlock := elifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithContinuingIfThenElse [

	| ifConditionalBlock thenBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		a()
		if i > 2:
			b() 
			continue
			c()
		else:
			d()
			continue
			e()
		f()
	g()'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self assert: (thenBlock statements second isOfType: FASTPyContinueStatement).
	self assert: thenBlock nextBlock equals: startBlock.

	elseBlock := ifConditionalBlock nextFalseBlock.
	self deny: elseBlock isConditional.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 2.
	self assert: (elseBlock statements first isOfType: FASTPyCall).
	self assert: (elseBlock statements second isOfType: FASTPyContinueStatement).
	self assert: elseBlock nextBlock equals: startBlock.

	lastBlock := startBlock nextFalseBlock.
	self deny: lastBlock isNullBlock.
	self assert: lastBlock isFinal.
	self assert: lastBlock statements size equals: 1.
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithElseWithBreakInAllBranches [

	| whileBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		print(i)
		break
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	whileBlock := startBlock nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyCall).
	self assert: (whileBlock statements second isOfType: FASTPyBreakStatement).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := elseBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: whileBlock nextBlock.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithElseWithBreakInIf [

	| whileBlock thenBlock elseBlock nullBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		print(i)
		if 1 > 2:
			break
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	whileBlock := startBlock nextTrueBlock.
	self assert: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 2.
	self assert: (whileBlock statements first isOfType: FASTPyCall).
	self assert: (whileBlock statements second isOfType: FASTPyComparisonOperator).
	self assert: whileBlock nextFalseBlock equals: startBlock.

	thenBlock := whileBlock nextTrueBlock.
	self deny: thenBlock isConditional.
	self deny: thenBlock isFinal.
	self assert: thenBlock statements size equals: 1.
	self assert: (thenBlock statements first isOfType: FASTPyBreakStatement).

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self deny: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement).

	nullBlock := elseBlock nextBlock.
	self assert: nullBlock isNullBlock.
	self assert: nullBlock isFinal.
	self assert: nullBlock equals: thenBlock nextBlock.
	self assert: nullBlock equals: startBlock mergeBlock
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithElseWithoutBreak [

	| whileBlock elseBlock |
	self buildCFGForFunction: 'def f(i):
	while i < 4:
		print(i)
	else:
		pass'.

	self assert: startBlock isConditional.
	self deny: startBlock isFinal.
	self assert: startBlock statements size equals: 1.
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
	self assert: startBlock nextBlocks size equals: 2.
	self assertEmpty: (startBlock nextBlocks select: #isNullBlock).

	whileBlock := startBlock nextTrueBlock.
	self deny: whileBlock isConditional.
	self deny: whileBlock isFinal.
	self assert: whileBlock statements size equals: 1.
	self assert: (whileBlock statements first isOfType: FASTPyCall).
	self assert: whileBlock nextBlock equals: startBlock.

	elseBlock := startBlock nextFalseBlock.
	self deny: elseBlock isNullBlock.
	self assert: elseBlock isFinal.
	self assert: elseBlock statements size equals: 1.
	self assert: (elseBlock statements first isOfType: FASTPyPassStatement)
]

{ #category : 'tests - while' }
FASTPythonCFGTest >> testFunctionWithWhileWithIfInElif [

	| ifConditionalBlock thenBlock elifConditionalBlock ifConditionalBlock2 thenBlock2 endOfElifBlock elseBlock lastBlock |
	self buildCFGForFunction: 'def f(i):
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
	self assert: (startBlock statements first isOfType: FASTPyComparisonOperator).
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
	self deny: thenBlock2 isConditional.
	self deny: thenBlock2 isFinal.
	self assert: thenBlock2 statements size equals: 1.
	self assert: (thenBlock2 statements first isOfType: FASTPyBreakStatement).

	endOfElifBlock := ifConditionalBlock2 nextFalseBlock.
	self deny: endOfElifBlock isConditional.
	self deny: endOfElifBlock isFinal.
	self assert: endOfElifBlock statements size equals: 1.
	self assert: (endOfElifBlock statements first isOfType: FASTPyCall).
	self assert: endOfElifBlock nextBlock equals: startBlock.

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
	self assert: (lastBlock statements first isOfType: FASTPyCall).
	self assert: lastBlock equals: startBlock mergeBlock
]
