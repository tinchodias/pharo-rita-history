Class {
	#name : #HiMSearchResults,
	#superclass : #HiMAbstractSearchResults,
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
	currentIndex := currentIndex - 1.
	currentIndex < 1 ifTrue: [ currentIndex := nodes size ].
]

{ #category : #testing }
HiMSearchResults >> hasResults [
	^ true
]

{ #category : #initialization }
HiMSearchResults >> initializeWith: aNonEmptyCollection [
	self initialize.
	
	nodes := aNonEmptyCollection.
	currentIndex := 1.
]

{ #category : #accessing }
HiMSearchResults >> nodes [
	^ nodes
]
