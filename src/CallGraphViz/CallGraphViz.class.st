Class {
	#name : #CallGraphViz,
	#superclass : #Object,
	#instVars : [
		'graphViz',
		'scopedPackages',
		'rootMethod',
		'scopeBlock',
		'excludedTags'
	],
	#category : #CallGraphViz
}

{ #category : #'call-graph' }
CallGraphViz class >> callGraphOfMethod: aCompiledMethod [

	^ self new
		rootMethod: aCompiledMethod;
		openCallGraphView
]

{ #category : #examples }
CallGraphViz class >> example [

	self callGraphOfMethod: (SpurMemoryManager >> #addFreeSubTree:).
]

{ #category : #accessing }
CallGraphViz >> defaultExcludedTags [

	^ #(#Plugins  #'Plugins-Surface')
]

{ #category : #accessing }
CallGraphViz >> defaultScopeBlock [

	^ [ : cm | 
			(self scopedPackages includes: cm package)
				and: [ (self excludedTags includes: cm methodClass packageTag) not
					and: [ (cm selector beginsWithAnyOf: #(#setUp #primitive #test)) not ] ] ]
]

{ #category : #accessing }
CallGraphViz >> excludedTags [

	^ excludedTags
		ifNil: [ excludedTags := self defaultExcludedTags ]
]

{ #category : #accessing }
CallGraphViz >> graphViz [

	^ graphViz
		ifNil: [ graphViz := GraphViz new ]
]

{ #category : #accessing }
CallGraphViz >> graphViz: anObject [

	graphViz := anObject
]

{ #category : #opening }
CallGraphViz >> openCallGraphView [

	self graphViz 
		callGraphOfMethod: self rootMethod
		scope: self scopeBlock
]

{ #category : #accessing }
CallGraphViz >> rootMethod [

	^ rootMethod
]

{ #category : #accessing }
CallGraphViz >> rootMethod: anObject [

	rootMethod := anObject
]

{ #category : #accessing }
CallGraphViz >> scopeBlock [
	" Answer a <BlockClosure> used to filter the graph output "

	^ scopeBlock
		ifNil: [ scopeBlock := self defaultScopeBlock ]
]

{ #category : #accessing }
CallGraphViz >> scopedPackages [

	^ scopedPackages
		ifNil: [ scopedPackages := { self rootMethod package } ]
]

{ #category : #accessing }
CallGraphViz >> scopedPackages: anObject [

	scopedPackages := anObject
]
