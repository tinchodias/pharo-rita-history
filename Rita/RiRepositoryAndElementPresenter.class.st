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
		position: 30 percent;
		add: #repositoryPresenter;
		add: #elementPresenter;
		yourself
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
		| parentDiffModels diffModels |
		parentDiffModels := targetRiElement ancestors collect: [:each | 
			RiParentDiffModel parentRiElement: each ].
		diffModels := (parentDiffModels, pinDiffModels) select: [:each |
			each shouldCompareTo: targetRiElement ].
		elementPresenter model: 
			(model copy 
				add: #element -> targetRiElement;
				add: #diffModels -> diffModels;
				yourself) ].
	
	repositoryPresenter blockForPinToCompareFrom: [ :sourceRiElement |
		pinDiffModels add: (RiPinDiffModel sourceRiCommit: sourceRiElement).
		
		"Refresh only table to show the pin: the detail will refresh on next table selection."
		repositoryPresenter refreshOnModelUpdate ]

]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> model: aDictionary [
	pinDiffModels := OrderedCollection new.
	repositoryPresenter model: 
		(aDictionary copy
			add: #pinDiffModels -> pinDiffModels;
			yourself).

	super model: aDictionary
]
