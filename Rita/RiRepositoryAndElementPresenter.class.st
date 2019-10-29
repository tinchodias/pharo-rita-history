Class {
	#name : #RiRepositoryAndElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'elementPresenter',
		'repositoryPresenter'
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
RiRepositoryAndElementPresenter >> initializePresenters [
	repositoryPresenter := self instantiate: RiRepositoryPresenter.
	elementPresenter := self instantiate: RiElementPresenter.
	
	repositoryPresenter blockForElementSelected: [ :element |
		elementPresenter model: element ]
]

{ #category : #initialization }
RiRepositoryAndElementPresenter >> refreshOnModelUpdate [
	repositoryPresenter model: model
]
