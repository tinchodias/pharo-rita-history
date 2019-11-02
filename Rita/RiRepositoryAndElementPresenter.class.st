Class {
	#name : #RiRepositoryAndElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'elementPresenter',
		'repositoryPresenter',
		'pinDiffModels'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiRepositoryAndElementPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		add: #repositoryPresenter;
		add: #elementPresenter;
		yourself
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> blockForSpawn: aBlock [
	elementPresenter blockForSpawn: [ aBlock cull: elementPresenter model ]
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> initializePresenters [
	repositoryPresenter := self instantiate: RiRepositoryPresenter.
	elementPresenter := self instantiate: RiElementPresenter.
	self initializeRepositoryPresenter
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> initializeRepositoryPresenter [

	repositoryPresenter blockForElementSelected: [ :targetRiElement |
		| parentDiffModels |
		parentDiffModels := targetRiElement ancestors collect: [:each | 
			RiParentDiffModel parentRiElement: each ].
		elementPresenter model: {
			#element -> targetRiElement. 
			#diffModels -> (parentDiffModels, pinDiffModels) asOrderedCollection
			} asDictionary ].
	
	repositoryPresenter blockForPinToCompareFrom: [ :sourceRiElement |
		pinDiffModels add: (RiPinDiffModel sourceRiCommit: sourceRiElement).
		
		"Refresh only table to show the pin: the detail will refresh on next table selection."
		repositoryPresenter refreshOnModelUpdate ]

]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> model: anObject [
	pinDiffModels := OrderedCollection new.
	repositoryPresenter model: {
		(#repository -> anObject).
		(#pinDiffModels -> pinDiffModels)
	} asDictionary.

	super model: anObject
]
