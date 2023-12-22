Class {
	#name : 'CGVMockObjectA',
	#superclass : 'Object',
	#category : 'CallGraphViz',
	#package : 'CallGraphViz'
}

{ #category : 'examples' }
CGVMockObjectA class >> example1 [

	CallGraphViz callGraphOfMethod: (CGVMockObjectA >> #methodWithOneSender).

]

{ #category : 'examples' }
CGVMockObjectA class >> example2 [

	CallGraphViz callGraphOfMethod: (CGVMockObjectA >> #methodWithTwoSenders).

]

{ #category : 'examples' }
CGVMockObjectA class >> example3 [

	CallGraphViz callGraphOfMethod: (CGVMockObjectA >> #methodWithOneSenderNested2).
]

{ #category : 'examples' }
CGVMockObjectA class >> example4 [

	Smalltalk garbageCollect.
	CallGraphViz callGraphOfMethod: (CGVMockObjectA >> #methodCyclicSender).
]

{ #category : 'accessing' }
CGVMockObjectA >> methodCyclicSender [

	self methodCyclicSender1
]

{ #category : 'accessing' }
CGVMockObjectA >> methodCyclicSender1 [

	self methodCyclicSender
]

{ #category : 'accessing' }
CGVMockObjectA >> methodSender1 [

	self methodWithOneSender.
]

{ #category : 'accessing' }
CGVMockObjectA >> methodSender2 [

	self methodWithTwoSenders.
]

{ #category : 'accessing' }
CGVMockObjectA >> methodSender3 [

	self methodWithTwoSenders.
]

{ #category : 'accessing' }
CGVMockObjectA >> methodSender4 [

	self methodWithOneSenderNested1.
]

{ #category : 'accessing' }
CGVMockObjectA >> methodWithOneSender [
]

{ #category : 'accessing' }
CGVMockObjectA >> methodWithOneSenderNested1 [

	self methodWithOneSenderNested2
]

{ #category : 'accessing' }
CGVMockObjectA >> methodWithOneSenderNested2 [
]

{ #category : 'accessing' }
CGVMockObjectA >> methodWithTwoSenders [
]

{ #category : 'accessing' }
CGVMockObjectA >> methodWithoutSenders [
]
