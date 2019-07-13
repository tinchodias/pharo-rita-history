Class {
	#name : #HiMSearchResults,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'currentIndex'
	],
	#category : #'Rita-Navigator-Model'
}

{ #category : #'instance creation' }
HiMSearchResults class >> newWith: someNodes [
	^ self basicNew
		initializeWith: someNodes;
		yourself
]

{ #category : #accessing }
HiMSearchResults >> currentIndex [
	^ currentIndex
]

{ #category : #accessing }
HiMSearchResults >> currentNode [
	^ nodes at: currentIndex
]

{ #category : #accessing }
HiMSearchResults >> goToNextResult [
	currentIndex := (currentIndex \\ nodes size) + 1
]

{ #category : #accessing }
HiMSearchResults >> goToPreviousResult [
	"currentIndex := currentIndex % nodes size"
	currentIndex := currentIndex - 1.
	currentIndex < 1 ifTrue: [ currentIndex := nodes size ].
]

{ #category : #testing }
HiMSearchResults >> hasResults [
	^ nodes notEmpty
]

{ #category : #initialization }
HiMSearchResults >> initializeWith: someNodes [
	self initialize.
	
	nodes := someNodes.
	currentIndex := 1 min: nodes size.
]

{ #category : #accessing }
HiMSearchResults >> nodes [
	^ nodes
]
