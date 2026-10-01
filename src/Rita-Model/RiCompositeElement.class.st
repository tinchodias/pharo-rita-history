"
A set of RiElement, typically the commits a user selected together in the repository commit list, that can be visualized as a single diff.

A composite collapses to the two endpoints RiceDiff understands: #sourceRiElement, the first ancestor of the oldest member that is not part of the composite, and #targetRiElement, its newest member. Diffing those two is the cumulative effect of the range, so commits between the endpoints that were not selected do contribute to the result.

A composite is not an RiElement: it is a container, never a node of the commit graph.

Preconditions: the collection of elements passed to #of: must be unique and ordered the way the repository lists them (newest first). The caller owns these invariants; the composite does not repair a mis-ordered or non-unique collection. A single selected commit is not a composite.
"
Class {
	#name : 'RiCompositeElement',
	#superclass : 'RiAbstractElement',
	#instVars : [
		'riElements'
	],
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RiCompositeElement class >> of: aCollectionOfRiElement [
	"Answer a composite of the given elements.
	Precondition: the collection must be unique and ordered the way the repository lists them (newest first). A single selected commit is not a composite."

	^ self new
		  riElements: aCollectionOfRiElement;
		  yourself
]

{ #category : 'testing' }
RiCompositeElement >> includesElement: aRiElement [
	^ riElements includes: aRiElement
]

{ #category : 'testing' }
RiCompositeElement >> isComposite [

	^ true
]

{ #category : 'accessing' }
RiCompositeElement >> newestElement [
	"Answer the newest RiElement I am made of. Because I always hold at least two elements, I always answer one."

	^ riElements first
]

{ #category : 'accessing' }
RiCompositeElement >> oldestElement [
	"Answer the oldest RiElement I am made of. Because I always hold at least two elements, I always answer one."

	^ riElements last
]

{ #category : 'accessing' }
RiCompositeElement >> repository [
	"Answer the RiRepository my elements belong to."

	^ self oldestElement repository
]

{ #category : 'accessing' }
RiCompositeElement >> riElements [
	"Answer the RiElement I am made of, ordered the way the repository lists them: newest first."

	^ riElements
]

{ #category : 'private' }
RiCompositeElement >> riElements: aCollectionOfRiElement [
	"Precondition: my elements are unique and ordered the way the repository lists them, newest first.
	I do not repair a wrong collection: a mis-ordered one would silently invert the composite."

	aCollectionOfRiElement size < 2 ifTrue: [ self error: 'A composite is made of at least two elements, I got ' , aCollectionOfRiElement size printString ].
	riElements := aCollectionOfRiElement
]

{ #category : 'accessing' }
RiCompositeElement >> size [

	^ riElements size
]

{ #category : 'accessing' }
RiCompositeElement >> sourceRiElement [
	"Answer the first ancestor of my oldest element that is not part of me: the base of the composite diff.
	Answering nil means there is nothing left to diff from, typically because I cover the whole history."

	^ self oldestElement ancestors
		  detect: [ :each | (self includesElement: each) not ]
		  ifNone: [ nil ]
]

{ #category : 'accessing' }
RiCompositeElement >> targetRiElement [
	"Answer my newest committed RiElement: the tip of the composite diff.
	Answering nil when I hold no commit at all, for example when I only cover the uncommitted working copy."

	^ riElements
		  detect: [ :each | each isUncommited not ]
		  ifNone: [ nil ]
]
