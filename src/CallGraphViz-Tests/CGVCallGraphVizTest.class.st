Class {
	#name : 'CGVCallGraphVizTest',
	#superclass : 'TestCase',
	#instVars : [
		'callGraphVisualizer'
	],
	#category : 'CallGraphViz-Tests',
	#package : 'CallGraphViz-Tests'
}

{ #category : 'tests' }
CGVCallGraphVizTest >> setUp [

	super setUp.
	callGraphVisualizer := CallGraphViz new.
]

{ #category : 'tests' }
CGVCallGraphVizTest >> testCallGraphBuildNodes [

	| aCompiledMethod |
	
	aCompiledMethod := CGVMockObjectA >> #methodSender4.
	callGraphVisualizer 
		rootMethod: aCompiledMethod;
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders from: aCompiledMethod;
		add: #graph with: (callGraphVisualizer callGraphLabelProperties: aCompiledMethod).

	self assert: callGraphVisualizer styles size equals: 4.
]
