Class {
	#name : #RiRepositoryAndElementPresenter,
	#superclass : #RiMasterDetailPresenter,
	#instVars : [
		'pinDiffModels'
	],
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiRepositoryAndElementPresenter >> connectMasterToDetail [
	masterPresenter blockForElementSelected: [ :targetRiElement |
		| parentDiffModels diffModels |
		parentDiffModels := targetRiElement ancestors collect: [:each | 
			RiParentDiffModel parentRiElement: each ].
		diffModels := (parentDiffModels, pinDiffModels) select: [:each |
			each shouldCompareTo: targetRiElement ].
		detailPresenter model: 
			(model copy 
				add: #element -> targetRiElement;
				add: #diffModels -> diffModels;
				yourself) ].
	
	masterPresenter blockForPinToCompareFrom: [ :sourceRiElement |
		pinDiffModels add: (RiPinDiffModel sourceRiCommit: sourceRiElement).
		
		"Refresh only table to show the pin: the detail will refresh on next table selection."
		masterPresenter refreshOnModelUpdate ]

]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> detailPresenterClass [
	^ RiElementPresenter
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> masterPresenterClass [
	^ RiRepositoryPresenter
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> model: aDictionary [
	pinDiffModels := OrderedCollection new.
	masterPresenter model: 
		(aDictionary copy
			add: #pinDiffModels -> pinDiffModels;
			yourself).

	super model: aDictionary
]
