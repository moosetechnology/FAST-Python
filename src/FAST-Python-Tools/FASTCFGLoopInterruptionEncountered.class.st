"
I am an exception raised when a Break of Continue statement are encountered during the visit of a FAST model. I should be caught in the visit of the statement block and my use is mostly to skip the rest of the statement block containing me.
"
Class {
	#name : 'FASTCFGLoopInterruptionEncountered',
	#superclass : 'Exception',
	#category : 'FAST-Python-Tools-CFG/DataFlow',
	#package : 'FAST-Python-Tools',
	#tag : 'CFG/DataFlow'
}
