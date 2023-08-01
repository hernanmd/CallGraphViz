Class {
	#name : #CallGraphViz,
	#superclass : #GraphViz,
	#instVars : [
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

{ #category : #'call-graph' }
CallGraphViz class >> callGraphOfMethod: aCompiledMethod levels: maxLevelsNumber [
	" Open a call graph using aCompiledMethod as root node and up to maxLevelsNumber in the sender chain "

	^ self new
		rootMethod: aCompiledMethod;
		openCallGraphView: maxLevelsNumber
]

{ #category : #accessing }
CallGraphViz class >> colors [

	^ colorsByName 
		ifNil: [ 	colorsByName := self defaultColorsByName ]
]

{ #category : #accessing }
CallGraphViz class >> defaultColorsByName [

	| colorList |

	colorList := ''.
	colorsByName := Dictionary new.
	colorList linesDo: [ : each | 
		| tokens |
		tokens := each findTokens: ';'.
		colorsByName 
			at: tokens first asSymbol 
			put: (Color fromString: tokens second) ].
	^ colorsByName
]

{ #category : #'instance creation' }
CallGraphViz class >> example [

	self callGraphOfMethod: (SpurMemoryManager >> #addFreeSubTree:).
]

{ #category : #'instance creation' }
CallGraphViz class >> exampleWithLevels [

	self 
		callGraphOfMethod: (SpurMemoryManager >> #addFreeSubTree:)
		levels: 3.
]

{ #category : #filtering }
CallGraphViz >> applyFilter: aCollectionOfCompiledMethod scope: scopeBlock [

	^ aCollectionOfCompiledMethod select: scopeBlock
]

{ #category : #accessing }
CallGraphViz >> callGraphArrowProperties [

	^ { 
		#arrowtail -> #normal . 
		#arrowsize -> 0.5 
	}
]

{ #category : #accessing }
CallGraphViz >> callGraphLabelProperties: aCompiledMethod [

	^ {
			#label -> ('Call Graph of ', aCompiledMethod name). 
			#fontsize -> 20 
		}
]

{ #category : #accessing }
CallGraphViz >> callGraphOfMethod: aCompiledMethod [
	
	self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders from: aCompiledMethod;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod);
		openInWindow
]

{ #category : #accessing }
CallGraphViz >> callGraphOfMethod: aCompiledMethod levels: maxLevelsNumber [
	
	self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders
			from: aCompiledMethod
			levels: maxLevelsNumber;
		add: #graph with: (self callGraphLabelProperties: aCompiledMethod);
		openInWindow
]

{ #category : #colors }
CallGraphViz >> colorFor: aNumber [

	self halt.
	self class colors.
	^ self green1 at: (aNumber / 1000 * 7 + 1) rounded 
]

{ #category : #accessing }
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
				#fillcolor -> #khaki 
				};
		add: #edge 		with: {
				#len -> 0.75
				}.
]

{ #category : #filtering }
CallGraphViz >> defaultExcludedTags [

	^ #(#Plugins  #'Plugins-Surface')
]

{ #category : #filtering }
CallGraphViz >> defaultScopeBlock [

	^ [ : cm | 
			(self scopedPackages includes: cm package)
				and: [ (self excludedTags includes: cm methodClass packageTag) not
					and: [ (cm selector beginsWithAnyOf: #(#setUp #primitive #test)) not ] ] ]
]

{ #category : #filtering }
CallGraphViz >> excludedTags [

	^ excludedTags
		ifNil: [ excludedTags := self defaultExcludedTags ]
]

{ #category : #colors }
CallGraphViz >> green1 [
	" 
	| scp |
	scp := RSSequentialColorPalette new.
	RSSequentialColorPalette methods 
		select: [ : cm | (scp perform: cm selector) range size > 7 ]
		thenCollect: [ : cm | cm selector -> (scp perform: cm selector) range ]	
	"
	^ (Array new: 8) at: 1 put: (Color r: 0.967741935483871 g: 0.9872922776148583 b: 0.9599217986314761 alpha: 1.0); at: 2 put: (Color r: 0.8973607038123167 g: 0.9599217986314761 b: 0.8778103616813294 alpha: 1.0); at: 3 put: (Color r: 0.7800586510263929 g: 0.9130009775171065 b: 0.7526881720430108 alpha: 1.0); at: 4 put: (Color r: 0.6304985337243402 g: 0.8504398826979472 b: 0.6070381231671554 alpha: 1.0); at: 5 put: (Color r: 0.45454545454545453 g: 0.7683284457478006 b: 0.46236559139784944 alpha: 1.0); at: 6 put: (Color r: 0.2541544477028348 g: 0.6705767350928641 b: 0.364613880742913 alpha: 1.0); at: 7 put: (Color r: 0.13685239491691104 g: 0.544477028347996 b: 0.2697947214076246 alpha: 1.0); at: 8 put: (Color r: 0.0 g: 0.35288367546432065 b: 0.19550342130987292 alpha: 1.0); yourself
]

{ #category : #iterating }
CallGraphViz >> iterateCallGraph: aCollectionOfCompiledMethod from: compiledMethod [

	(self applyFilter: aCollectionOfCompiledMethod scope: self scopeBlock) 
		do: [ : cm |
			(self nodeNamed: cm name)
				ifNil: [ 
					"self add: cm name with: #label -> cm name."
					self add: cm name -> compiledMethod name with: self callGraphArrowProperties.
					self iterateCallGraph: cm senders from: cm ] ]
		displayingProgress: [ : each | 'Collecting senders of ' , each name ]
]

{ #category : #iterating }
CallGraphViz >> iterateCallGraph: aCollectionOfCompiledMethod from: compiledMethod levels: maxLevelsNumber [

	maxLevelsNumber <= 0
		ifTrue: [ ^ self ].
	(self applyFilter: aCollectionOfCompiledMethod scope: self scopeBlock) 
		do: [ : cm |
			(self nodeNamed: cm name)
				ifNil: [ 
					"self add: cm name with: #label -> cm name."
					cm senders 
						ifEmpty: [ self add: #node with: { #fillcolor -> #green } ]
						ifNotEmpty: [: cmSenders |  self add: #node with: { #fillcolor -> (self colorFor: cmSenders size) } ].
					self add: cm name -> compiledMethod name with: self callGraphArrowProperties.
					self iterateCallGraph: cm senders from: cm levels: maxLevelsNumber - 1] ]
		displayingProgress: [ : each | 'Collecting senders of ' , each name ]
]

{ #category : #opening }
CallGraphViz >> openCallGraphView [

	self 
		callGraphOfMethod: self rootMethod
]

{ #category : #opening }
CallGraphViz >> openCallGraphView: maxLevelsNumber [
	" Open a call graph view starting analysis from the receiver's root method and follow the sender chain up to maxLevelsNumber <Number> "

	self 
		callGraphOfMethod: self rootMethod
		levels: maxLevelsNumber
]

{ #category : #accessing }
CallGraphViz >> rootMethod [

	^ rootMethod
]

{ #category : #accessing }
CallGraphViz >> rootMethod: anObject [

	rootMethod := anObject
]

{ #category : #filtering }
CallGraphViz >> scopeBlock [
	" Answer a <BlockClosure> used to filter the graph output "

	^ scopeBlock
		ifNil: [ scopeBlock := self defaultScopeBlock ]
]

{ #category : #filtering }
CallGraphViz >> scopedPackages [

	^ scopedPackages
		ifNil: [ scopedPackages := { self rootMethod package } ]
]

{ #category : #filtering }
CallGraphViz >> scopedPackages: anObject [

	scopedPackages := anObject
]

{ #category : #colors }
CallGraphViz >> yellow1 [

	^ (Array new: 8) at: 1 put: (Color r: 1.0 g: 1.0 b: 0.8973607038123167 alpha: 1.0); at: 2 put: (Color r: 1.0 g: 0.967741935483871 b: 0.7370478983382209 alpha: 1.0); at: 3 put: (Color r: 0.9951124144672532 g: 0.8895405669599218 b: 0.5679374389051809 alpha: 1.0); at: 4 put: (Color r: 0.9951124144672532 g: 0.7683284457478006 b: 0.3088954056695992 alpha: 1.0); at: 5 put: (Color r: 0.9951124144672532 g: 0.5992179863147605 b: 0.1603128054740958 alpha: 1.0); at: 6 put: (Color r: 0.9247311827956989 g: 0.4389051808406647 b: 0.07820136852394917 alpha: 1.0); at: 7 put: (Color r: 0.7996089931573802 g: 0.29716520039100686 b: 0.007820136852394917 alpha: 1.0); at: 8 put: (Color r: 0.5483870967741935 g: 0.17595307917888564 b: 0.015640273704789834 alpha: 1.0); yourself
]
