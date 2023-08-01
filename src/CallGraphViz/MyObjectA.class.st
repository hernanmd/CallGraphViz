Class {
	#name : #MyObjectA,
	#superclass : #Object,
	#category : #CallGraphViz
}

{ #category : #examples }
MyObjectA class >> example1 [

	CallGraphViz callGraphOfMethod: (MyObjectA >> #methodWithOneSender).

]

{ #category : #examples }
MyObjectA class >> example2 [

	CallGraphViz callGraphOfMethod: (MyObjectA >> #methodWithTwoSenders).

]

{ #category : #examples }
MyObjectA class >> example3 [

	CallGraphViz callGraphOfMethod: (MyObjectA >> #methodWithOneSenderNested2).
]

{ #category : #examples }
MyObjectA class >> example4 [

	Smalltalk garbageCollect.
	CallGraphViz callGraphOfMethod: (MyObjectA >> #methodCyclicSender).
]

{ #category : #accessing }
MyObjectA >> methodCyclicSender [

	self methodCyclicSender1
]

{ #category : #accessing }
MyObjectA >> methodCyclicSender1 [

	self methodCyclicSender
]

{ #category : #accessing }
MyObjectA >> methodSender1 [

	self methodWithOneSender.
]

{ #category : #accessing }
MyObjectA >> methodSender2 [

	self methodWithTwoSenders.
]

{ #category : #accessing }
MyObjectA >> methodSender3 [

	self methodWithTwoSenders.
]

{ #category : #accessing }
MyObjectA >> methodSender4 [

	self methodWithOneSenderNested1.
]

{ #category : #accessing }
MyObjectA >> methodWithOneSender [
]

{ #category : #accessing }
MyObjectA >> methodWithOneSenderNested1 [

	self methodWithOneSenderNested2
]

{ #category : #accessing }
MyObjectA >> methodWithOneSenderNested2 [
]

{ #category : #accessing }
MyObjectA >> methodWithTwoSenders [
]

{ #category : #accessing }
MyObjectA >> methodWithoutSenders [
]
