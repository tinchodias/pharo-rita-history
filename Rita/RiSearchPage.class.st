Class {
	#name : #RiSearchPage,
	#superclass : #RiPresenter,
	#category : #'Rita-UI-Search'
}

{ #category : #'as yet unclassified' }
RiSearchPage class >> labelledInputHeight [
	^ self inputTextHeight * 1.5
]

{ #category : #accessing }
RiSearchPage >> checkIfInvalid: aBlockClosure [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiSearchPage >> pathIn: aRiRepository [
	^ self subclassResponsibility
]

{ #category : #searching }
RiSearchPage >> searchResultsIn: aRiRepository [
	^ aRiRepository
		selectLibgitCommitsWithChangesAt: (self pathIn: aRiRepository iceRepository)
]
