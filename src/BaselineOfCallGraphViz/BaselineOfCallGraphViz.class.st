Class {
	#name : #BaselineOfCallGraphViz,
	#superclass : #BaselineOf,
	#category : #BaselineOfCallGraphViz
}

{ #category : #baselines }
BaselineOfCallGraphViz >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			spec
				baseline: 'GraphViz'           with: [ spec repository: 'github://hernanmd/GraphViz/' ].
			spec 
				package: 'CallGraphViz'        with: [ spec requires: #(GraphViz) ];
				package: 'CallGraphViz-Tests'	with: [ spec requires: #(CallGraphViz) ].
			spec 
				group: 'Core' 						with: #('CallGraphViz');
				group: 'Tests' 						with: #('CallGraphViz' 'CallGraphViz-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]
