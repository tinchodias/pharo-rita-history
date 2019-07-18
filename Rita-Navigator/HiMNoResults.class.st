Class {
	#name : #HiMNoResults,
	#superclass : #HiMAbstractSearchResults,
	#category : #'Rita-Navigator-Model'
}

{ #category : #accessing }
HiMNoResults >> currentIndex [
	^ self error
]

{ #category : #accessing }
HiMNoResults >> currentNode [
	^ self error
]

{ #category : #accessing }
HiMNoResults >> goToNextResult [
	^ self error
]

{ #category : #accessing }
HiMNoResults >> goToPreviousResult [
	^ self error
]

{ #category : #accessing }
HiMNoResults >> hasResults [
	^ false
]

{ #category : #accessing }
HiMNoResults >> nodes [
	^ #()

]
