"
Provides a menu item in the method contextual menu, accessed when a method is selected in the Calypso browser.

"
Class {
	#name : 'CGVOpenCallGraphVizCommand',
	#superclass : 'SycMethodCommand',
	#classTraits : '{} + TraitedClass',
	#category : 'CallGraphViz-Commands',
	#package : 'CallGraphViz',
	#tag : 'Commands'
}

{ #category : 'accessing' }
CGVOpenCallGraphVizCommand class >> methodMenuActivation [
	<classAnnotation>

	^ CmdContextMenuActivation byRootGroupItemOrder: 10312 for: ClyMethod asCalypsoItemContext
]

{ #category : 'accessing' }
CGVOpenCallGraphVizCommand >> defaultMenuIconName [

	^ #objects
]

{ #category : 'accessing' }
CGVOpenCallGraphVizCommand >> defaultMenuItemName [

	^'Call Graph Visualization'  
]

{ #category : 'accessing' }
CGVOpenCallGraphVizCommand >> description [
	^'Open a Call graph visualization on the selected method'
]

{ #category : 'execution' }
CGVOpenCallGraphVizCommand >> execute [

	methods do: [ :aMethod | CallGraphViz openCallGraphOfMethod: aMethod ].


]
