"
It uses `GraphViz` to provide a call graph visualization object. Useful to help you analyze and understand the flow of method calls within your codebase. The idea is to quickly view method sends to uncover dependencies and relationships with ease. You can also easily distinguish between different types of methods sends with color-coded nodes. 

This visual cue aids in quickly identifying key methods and understanding their roles in the overall system.

This class is the main entry point for the package and contains two protocols of interest for the end-user:

- Accessing to the call graph `GraphViz` object.
- Opening a window to visualize the call graph.

See the class side examples.

"
Class {
	#name : 'CallGraphViz',
	#superclass : 'GraphViz',
	#instVars : [
		'rootMethod',
		'scopeBlock',
		'excludedTags',
		'packages',
		'excludedMethods',
		'excludedSelectors'
	],
	#category : 'CallGraphViz-Core',
	#package : 'CallGraphViz',
	#tag : 'Core'
}

{ #category : 'call-graph' }
CallGraphViz class >> callGraphOfMethod: aCompiledMethod [

	^ self new
		rootMethod: aCompiledMethod;
		callGraphView;
		yourself
]

{ #category : 'call-graph' }
CallGraphViz class >> callGraphOfMethod: aCompiledMethod packages: aPackagesCollection [

	^ self new
		rootMethod: aCompiledMethod;
		packages: aPackagesCollection;
		openCallGraphView
]

{ #category : 'call-graph' }
CallGraphViz class >> callGraphOfMethod: aCompiledMethod packages: aPackagesCollection levels: maxLevelsNumber [

	^ self new
		rootMethod: aCompiledMethod;
		packages: aPackagesCollection;
		openCallGraphView: maxLevelsNumber
]

{ #category : 'instance creation' }
CallGraphViz class >> example [

	self new
		rootMethod:  (SortedCollection >> #sortBlock);
		openCallGraphView: 2.
]

{ #category : 'instance creation' }
CallGraphViz class >> exampleWithLevels [

	(Smalltalk hasClassNamed: #SpurMemoryManager)
		ifTrue: [ self openCallGraphOfMethod: ((Smalltalk at: #SpurMemoryManager) >> #addFreeSubTree:) levels: 5 ]
		ifFalse: [ self openCallGraphOfMethod: (String >> #asDate) levels: 5 ]
		.
]

{ #category : 'instance creation' }
CallGraphViz class >> exampleWithLevelsAndExclusions [

	self
		openCallGraphOfMethod: (Array >> #asArray)
		levels: 8
		excludeMethods: { 
			(Array2D class >> #new:) .
			(Heap >> #=) .
			(Interval >> #=) .
			(Array2D >> #=) }		.
]

{ #category : 'call-graph' }
CallGraphViz class >> openCallGraphOfMethod: aCompiledMethod [

	^ self new
		rootMethod: aCompiledMethod;
		openCallGraphView
]

{ #category : 'call-graph' }
CallGraphViz class >> openCallGraphOfMethod: aCompiledMethod levels: maxLevelsNumber [
	" Open a call graph using aCompiledMethod as root node and up to maxLevelsNumber in the sender chain "

	^ self new
		rootMethod: aCompiledMethod;
		openCallGraphView: maxLevelsNumber
]

{ #category : 'call-graph' }
CallGraphViz class >> openCallGraphOfMethod: aCompiledMethod levels: maxLevelsNumber excludeMethods: compiledMethods [
	" Open a call graph using aCompiledMethod as root node and up to maxLevelsNumber in the sender chain "

	^ self new
		rootMethod: aCompiledMethod;
		excludedMethods: compiledMethods;
		openCallGraphView: maxLevelsNumber
]

{ #category : 'iterating' }
CallGraphViz >> buildNodeLabel: cm [
	"Set the receiver's node name using information from aCompiledMethod"

	self nodeNamed: (String streamContents: [ : stream |
		stream 
			<< cm name;
			<< ' (';
			<< cm senders size asString;
			<< ')' ])
]

{ #category : 'accessing' }
CallGraphViz >> callGraphArrowProperties [

	^ { 
		#arrowtail -> #normal . 
		#arrowsize -> 0.5 
	}
]

{ #category : 'accessing' }
CallGraphViz >> callGraphLabelProperties: aCompiledMethod [

	^ {
			#label -> ('Call Graph of ', aCompiledMethod name). 
			#fontsize -> 20 
		}
]

{ #category : 'accessing - call graph' }
CallGraphViz >> callGraphOfMethod: aCompiledMethod [
	
	^ self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders from: aCompiledMethod;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod);
		yourself
]

{ #category : 'accessing - call graph' }
CallGraphViz >> callGraphOfMethod: aCompiledMethod levels: maxLevelsNumber [
	
	^ self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders
			from: aCompiledMethod
			levels: maxLevelsNumber;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod)
]

{ #category : 'accessing - call graph' }
CallGraphViz >> callGraphView [
	"Answer the receiver call graph using the rootMethod as tree's root"

	^ self 
		callGraphOfMethod: self rootMethod
]

{ #category : 'accessing - call graph' }
CallGraphViz >> callGraphView: maxLevelsNumber [
	" Answer the receiver starting analysis from the receiver's root method and follow the sender chain up to maxLevelsNumber <Number> "

	^ self 
		callGraphOfMethod: self rootMethod
		levels: maxLevelsNumber
]

{ #category : 'colors' }
CallGraphViz >> colorFor: aNumber [
	"Refer to GraphViz Bewer color schemes"

	^ (6 min: aNumber) asString

]

{ #category : 'accessing' }
CallGraphViz >> configureCallGraphAttributes [

	self
		beDirected;
		add: #graph 		with: {
				#overlap -> #box . 
				#start -> #rand . 
				#splines -> #true 
				};
		add: #node 		with: { 
				#fontsize -> 10 . 
				#height -> 0.25 . 
				#shape -> #box . 
				#style -> #filled . 
				#colorscheme -> #oranges9
				};
		add: #edge 		with: {
				#len -> 0.75
				}.
]

{ #category : 'iterating' }
CallGraphViz >> configureNodeProperties: fromCompiledMethod to: toCompiledMethod [

	fromCompiledMethod senders 
		ifEmpty: [ self add: #node with: self emptyNodeProperties ]
		ifNotEmpty: [: cmSenders | 
			self 
				add: #node 
				with: { 
					#fontcolor -> #black . 
					#fillcolor -> (self colorFor: fromCompiledMethod senders size) } ].
	self 
		add: fromCompiledMethod name -> toCompiledMethod name 
		with: self callGraphArrowProperties.
]

{ #category : 'filtering' }
CallGraphViz >> defaultExcludedMethods [

	^ #()
]

{ #category : 'filtering' }
CallGraphViz >> defaultExcludedSelectors [
	"Answer a <Collection> of <Symbol> representing default selectors which won't be analyzed"
	
	^ #(#setUp #primitive #test)
]

{ #category : 'filtering' }
CallGraphViz >> defaultExcludedTags [

	^ #(#Plugins  #'Plugins-Surface')
]

{ #category : 'filtering' }
CallGraphViz >> defaultScopeBlock [
	"Answer a <BlockClosure> used to narrow call graph selections"

	^ [ : cm | 
			(self packages includes: cm package)
				and: [ 
					(self excludedTags includes: cm methodClass packageTag) not
						and: [ 
							(self excludedMethods includes: cm) not 
								and: [ (cm selector beginsWithAnyOf: self excludedSelectors) not ] ] ] ]
]

{ #category : 'colors' }
CallGraphViz >> emptyNodeProperties [

	^ { #fontcolor -> #white . #fillcolor -> 9 }
]

{ #category : 'filtering' }
CallGraphViz >> excludedMethods [
	"Answer a <Collection> of <CompiledMethod> which won't be analyzed"
	
	^ excludedMethods
		ifNil: [ excludedMethods := self defaultExcludedMethods ]
]

{ #category : 'accessing' }
CallGraphViz >> excludedMethods: anObject [

	excludedMethods := anObject
]

{ #category : 'filtering' }
CallGraphViz >> excludedSelectors [
	"Answer a <Collection> of <Symbol> representing selectors which won't be analyzed"

	^ excludedSelectors
		ifNil: [ excludedSelectors := self defaultExcludedSelectors ]
]

{ #category : 'accessing' }
CallGraphViz >> excludedSelectors: anObject [

	excludedSelectors := anObject
]

{ #category : 'filtering' }
CallGraphViz >> excludedTags [

	^ excludedTags
		ifNil: [ excludedTags := self defaultExcludedTags ]
]

{ #category : 'accessing' }
CallGraphViz >> excludedTags: anObject [

	excludedTags := anObject
]

{ #category : 'iterating' }
CallGraphViz >> iterateCallGraph: aCollectionOfCompiledMethod from: compiledMethod [

	(aCollectionOfCompiledMethod select: self scopeBlock)
		do: [ : cm |
			(self nodeNamed: cm name)
				ifNil: [ 
					self configureNodeProperties: cm to: compiledMethod. 
					self iterateCallGraph: cm senders from: cm ] ]
		displayingProgress: [ : each | 'Collecting senders of ' , each name ]
]

{ #category : 'iterating' }
CallGraphViz >> iterateCallGraph: aCollectionOfCompiledMethod from: compiledMethod levels: maxLevelsNumber [

	maxLevelsNumber <= 0
		ifTrue: [ ^ self ].
	(aCollectionOfCompiledMethod select: self scopeBlock)
		do: [ : cm |
			(self nodeNamed: cm name)
				ifNil: [ 
					self configureNodeProperties: cm to: compiledMethod. 
					self iterateCallGraph: cm senders from: cm levels: maxLevelsNumber - 1] ]
		displayingProgress: [ : each | 'Collecting senders of ' , each name ]
]

{ #category : 'opening' }
CallGraphViz >> openCallGraphOfMethod: aCompiledMethod [
	
	self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders from: aCompiledMethod;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod);
		openInWindow
]

{ #category : 'opening' }
CallGraphViz >> openCallGraphOfMethod: aCompiledMethod levels: maxLevelsNumber [
	
	self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders
			from: aCompiledMethod
			levels: maxLevelsNumber;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod);
		openInWindow
]

{ #category : 'opening' }
CallGraphViz >> openCallGraphView [

	self 
		openCallGraphOfMethod: self rootMethod
]

{ #category : 'opening' }
CallGraphViz >> openCallGraphView: maxLevelsNumber [
	" Open a call graph view starting analysis from the receiver's root method and follow the sender chain up to maxLevelsNumber <Number> "

	self 
		openCallGraphOfMethod: self rootMethod
		levels: maxLevelsNumber
]

{ #category : 'filtering' }
CallGraphViz >> packages [

	^ packages
		ifNil: [ packages := { self rootMethod package } ]
]

{ #category : 'filtering' }
CallGraphViz >> packages: anObject [

	packages := anObject
]

{ #category : 'accessing' }
CallGraphViz >> rootMethod [

	^ rootMethod
]

{ #category : 'accessing' }
CallGraphViz >> rootMethod: anObject [

	rootMethod := anObject
]

{ #category : 'filtering' }
CallGraphViz >> scopeBlock [
	" Answer a <BlockClosure> used to filter the graph output "

	^ scopeBlock
		ifNil: [ scopeBlock := self defaultScopeBlock ]
]

{ #category : 'accessing' }
CallGraphViz >> scopeBlock: anObject [

	scopeBlock := anObject
]
