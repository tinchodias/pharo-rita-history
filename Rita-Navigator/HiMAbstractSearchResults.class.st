Class {
	#name : #HiMAbstractSearchResults,
	#superclass : #Object,
	#category : #'Rita-Navigator-Model'
}

{ #category : #accessing }
HiMAbstractSearchResults >> currentIndex [
	^ self subclassResponsibility

]

{ #category : #accessing }
HiMAbstractSearchResults >> currentNode [
	^ self subclassResponsibility

]

{ #category : #accessing }
HiMAbstractSearchResults >> goToNextResult [
	^ self subclassResponsibility

]

{ #category : #accessing }
HiMAbstractSearchResults >> goToPreviousResult [
	^ self subclassResponsibility

]

{ #category : #accessing }
HiMAbstractSearchResults >> hasResults [
	^ self subclassResponsibility

]

{ #category : #accessing }
HiMAbstractSearchResults >> nodes [
	^ self subclassResponsibility

]
