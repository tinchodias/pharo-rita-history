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
		elementPresenter model: {
			#element -> targetRiElement. 
			#diffModels -> ({ RiParentDiffModel new }, pinDiffModels) asOrderedCollection
			} asDictionary ].
	
	repositoryPresenter blockForPinToCompareFrom: [ :sourceRiElement |
		pinDiffModels add: (RiPinDiffModel new sourceIceCommit: sourceRiElement iceCommit; yourself).
		
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
