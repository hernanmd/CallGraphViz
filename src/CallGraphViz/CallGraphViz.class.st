Class {
	#name : 'CallGraphViz',
	#superclass : 'GraphViz',
	#instVars : [
		'rootMethod',
		'scopeBlock',
		'excludedTags',
		'packages'
	],
	#category : 'CallGraphViz',
	#package : 'CallGraphViz'
}

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

	(Smalltalk hasClassNamed: #SpurMemoryManager)
		ifTrue: [ self openCallGraphOfMethod: ((Smalltalk at: #SpurMemoryManager) >> #addFreeSubTree:) ]
		ifFalse: [ self openCallGraphOfMethod: (SortedCollection >> #sortBlock) ].
]

{ #category : 'instance creation' }
CallGraphViz class >> exampleWithLevels [

	(Smalltalk hasClassNamed: #SpurMemoryManager)
		ifTrue: [ self openCallGraphOfMethod: ((Smalltalk at: #SpurMemoryManager) >> #addFreeSubTree:) levels: 5 ]
		ifFalse: [ self openCallGraphOfMethod: (String >> #asDate) levels: 5 ]
		.
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
CallGraphViz >> defaultExcludedTags [

	^ #(#Plugins  #'Plugins-Surface')
]

{ #category : 'filtering' }
CallGraphViz >> defaultScopeBlock [
	"Answer a <BlockClosure> used to narrow call graph selections"

	^ [ : cm | 
			(self packages includes: cm package)
				and: [ (self excludedTags includes: cm methodClass packageTag) not
					and: [ (cm selector beginsWithAnyOf: #(#setUp #primitive #test)) not ] ] ]
]

{ #category : 'colors' }
CallGraphViz >> emptyNodeProperties [

	^ { #fontcolor -> #white . #fillcolor -> 9 }
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
