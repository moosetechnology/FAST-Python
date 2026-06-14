"
I am a baseline to define the structure and dependencies of the FASTPython project.
"
Class {
	#name : 'BaselineOfFASTPython',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFASTPython',
	#package : 'BaselineOfFASTPython'
}

{ #category : 'baselines' }
BaselineOfFASTPython >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
			self
				fast: spec;
				treeSitter: spec.

			"Packages"
			spec
				package: 'FAST-Python-Model' with: [ spec requires: #( 'FAST' 'TreeSitter' ) ];
				package: 'FAST-Python-Model-Generator';
				package: 'FAST-Python-Model-Tests' with: [ spec requires: #( 'FAST-Python-Model' ) ];
				package: 'FAST-Python-Tools' with: [ spec requires: #( 'FAST-Python-Model' ) ];
				package: 'FAST-Python-Tools-Tests' with: [ spec requires: #( 'FAST-Python-Tools' ) ].

			"Groups"
			spec
				group: 'Core' with: #( 'FAST-Python-Model' 'FAST-Python-Tools' );
				group: 'Generator' with: #( 'FAST-Python-Model-Generator' );
				group: 'Tests' with: #( 'FAST-Python-Model-Tests' 'FAST-Python-Tools-Tests' ) ]
]

{ #category : 'dependencies' }
BaselineOfFASTPython >> fast: spec [

	spec baseline: 'FAST' with: [
			spec
				loads: #( 'All' );
				repository: 'github://moosetechnology/FAST:v3/src' ]
]

{ #category : 'accessing' }
BaselineOfFASTPython >> projectClass [
	^ MetacelloCypressBaselineProject
]

{ #category : 'dependencies' }
BaselineOfFASTPython >> treeSitter: spec [
	spec
		baseline: 'TreeSitter' with: [ spec repository: 'github://Evref-BL/Pharo-Tree-Sitter:main/src' ]
]
