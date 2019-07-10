Class {
	#name : #HiMNode,
	#superclass : #Object,
	#instVars : [
		'children',
		'object',
		'outgoingLinks',
		'incomingLinks',
		'parent'
	],
	#category : #'Rita-Navigator-Model'
}

{ #category : #'instance creation' }
HiMNode class >> for: anObject [
	^ self new object: anObject; yourself
]

{ #category : #accessing }
HiMNode >> addChild: aHiMNode [
	aHiMNode basicParent: self.
	children add: aHiMNode.
]

{ #category : #accessing }
HiMNode >> addOutgoingLinkTo: anotherHiMNode [
	
	| link |
	link := HiMLink from: self to: anotherHiMNode.
	self basicAddOutgoingLink: link.
	anotherHiMNode basicAddIncomingLink: link.
	^ link
]

{ #category : #accessing }
HiMNode >> allIncomingLinks [
	^ Array streamContents: [ :stream |
		self withAllChildrenDo: [:each | 
			stream nextPutAll: each incomingLinks ] ]
]

{ #category : #accessing }
HiMNode >> allIncomingNodes [
	^ Array streamContents: [ :stream |
		self withAllChildrenDo: [:each | 
			each incomingLinks do: [ :link |
				stream nextPut: link from ] ] ]
]

{ #category : #accessing }
HiMNode >> allOutgoingLinks [
	^ Array streamContents: [ :stream |
		self withAllChildrenDo: [:each | 
			stream nextPutAll: each outgoingLinks ] ]
]

{ #category : #accessing }
HiMNode >> basicAddIncomingLink: link [
	incomingLinks add: link

]

{ #category : #accessing }
HiMNode >> basicAddOutgoingLink: link [
	outgoingLinks add: link

]

{ #category : #accessing }
HiMNode >> basicParent: anotherHiMNode [
	parent := anotherHiMNode
]

{ #category : #accessing }
HiMNode >> children [
	^ children
]

{ #category : #accessing }
HiMNode >> children: anObject [
	children := anObject
]

{ #category : #accessing }
HiMNode >> incomingLinks [
	^ incomingLinks
]

{ #category : #accessing }
HiMNode >> incomingNodes [
	^ Array streamContents: [ :stream |
		incomingLinks do: [ :link |
			stream nextPut: link from ] ]
]

{ #category : #accessing }
HiMNode >> initialize [
	super initialize.
	
	incomingLinks := OrderedCollection new.
	outgoingLinks := OrderedCollection new.
	children := OrderedCollection new.
]

{ #category : #accessing }
HiMNode >> object [
	^ object
]

{ #category : #accessing }
HiMNode >> object: anObject [
	object := anObject
]

{ #category : #accessing }
HiMNode >> outgoingLinks [
	^ outgoingLinks
]

{ #category : #accessing }
HiMNode >> outgoingNodes [
	^ Array streamContents: [ :stream |
		outgoingLinks do: [ :link |
			stream nextPut: link to ] ]
]

{ #category : #accessing }
HiMNode >> parent [
	^ parent
]

{ #category : #printing }
HiMNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: object;
		nextPut: $)
		
]

{ #category : #accessing }
HiMNode >> topParent [
	^ parent ifNil: [ self ] ifNotNil: [ parent topParent ]
]

{ #category : #enumerating }
HiMNode >> withAllChildrenDo: aBlockClosure [ 
	aBlockClosure value: self.
	children do: [ :each |
		each withAllChildrenDo: aBlockClosure ]
]

{ #category : #accessing }
HiMNode >> withAllParents [
	^ Array streamContents: [:stream | self withAllParentsDo: [ :each | stream nextPut: each ] ]
]

{ #category : #enumerating }
HiMNode >> withAllParentsDo: aBlockClosure [ 
	aBlockClosure value: self.
	parent ifNotNil: [ parent withAllParentsDo: aBlockClosure ]
]
