Extension { #name : #GraphViz }

{ #category : #'*CallGraphViz' }
GraphViz >> applyFilter: aCollectionOfCompiledMethod scope: scopeBlock [

	^ aCollectionOfCompiledMethod select: scopeBlock
]

{ #category : #'*CallGraphViz' }
GraphViz >> callGraphOfMethod: aCompiledMethod scope: scopeBlock [
	
	self
		name: #callGraphOf , aCompiledMethod selector;
		configureCallGraphAttributes;
		iterateCallGraph: aCompiledMethod senders
		 	scope: scopeBlock
			from: aCompiledMethod;
		add: #graph 
		with: {
			#label -> ('Call Graph of ', aCompiledMethod name). 
			#fontsize -> 20 
		};
		openInWindow
]

{ #category : #'*CallGraphViz' }
GraphViz >> configureCallGraphAttributes [

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

{ #category : #'*CallGraphViz' }
GraphViz >> iterateCallGraph: aCollectionOfCompiledMethod scope: scopeBlock from: compiledMethod [

	(self applyFilter: aCollectionOfCompiledMethod scope: scopeBlock) 
		do: [ : cm |
			(self nodeNamed: cm name)
				ifNil: [ 
					"self add: cm name with: #label -> cm name."
					self add: cm name -> compiledMethod name with: { #arrowtail -> #normal . #arrowsize -> 0.5 }.
					self iterateCallGraph: cm senders scope: scopeBlock from: cm ] ]
		displayingProgress: [ : each | 'Collecting senders of ' , each name ]
]
