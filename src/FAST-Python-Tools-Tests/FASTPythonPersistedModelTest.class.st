"
All tests cases subclassing `FASTPythonAbstractTestCase` are parametric and run on an imported model, and also on the same model that has been exported and imported again. 

I am here to hold some tests specific to the export and import. When bugs are discovered in the import/export but the tests in the other classes are too complex to find easily the problem, a minimal version producing the problem is added to me. 
"
Class {
	#name : 'FASTPythonPersistedModelTest',
	#superclass : 'FASTPythonAbstractTestCase',
	#category : 'FAST-Python-Tools-Tests-Importer',
	#package : 'FAST-Python-Tools-Tests',
	#tag : 'Importer'
}
