Class {
	#name : #RiRepositorySearchPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'notebook'
	],
	#category : #'Rita-UI-Search'
}

{ #category : #specs }
RiRepositorySearchPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #notebook;
"		add: #applyButton
			withConstraints: [ :constraints | constraints height: self buttonHeight ];"
		yourself
]

{ #category : #accessing }
RiRepositorySearchPresenter >> checkIfInvalid: aBlockClosure [ 
	^ notebook selectedPage activePresenter checkIfInvalid: aBlockClosure
]

{ #category : #initialization }
RiRepositorySearchPresenter >> initializePageTitle: aString pageClass: aRiSearchPageClass [
	notebook addPage: (SpNotebookPage
		title: aString
		provider: [ self instantiate: aRiSearchPageClass ])
]

{ #category : #initialization }
RiRepositorySearchPresenter >> initializePresenters [
	notebook := self newNotebook.
	self initializePageTitle: 'Path' pageClass: RiPathSearchPage.
	self initializePageTitle: 'Package' pageClass: RiPackageSearchPage.
	self initializePageTitle: 'Class' pageClass: RiClassSearchPage.
	self initializePageTitle: 'Method' pageClass: RiMethodSearchPage.

]

{ #category : #accessing }
RiRepositorySearchPresenter >> searchResults [
	^ notebook selectedPage activePresenter searchResultsIn: (model at: #repository)
]
