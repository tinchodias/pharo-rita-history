Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPresenter',
		'notebook',
		'summary'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementPresenter class >> defaultSpec [
	^ SpPanedLayout newVertical
		position: 0.15;
		add: #summary;
		add: #notebook;
		yourself
]

{ #category : #private }
RiElementPresenter >> addPageFor: aRiDiffModel to: targetRiCommit [

	| page |
	page := SpNotebookPage
		title: aRiDiffModel title
		icon: (self iconNamed: #diff)
		provider: [
			self diffPresenterFor: aRiDiffModel to: targetRiCommit ].

	notebook addPage: page
]

{ #category : #private }
RiElementPresenter >> diffPresenterFor: aRiDiffModel to: targetRiCommit [
	| iceDiff |
	iceDiff := aRiDiffModel iceDiffTo: targetRiCommit.
	^ (self instantiate: RiFullDiffPresenter)
			model: (model copy
				add: #iceDiff -> iceDiff;
				add: #shadowedIceNodes -> IdentitySet new;
				yourself);
			yourself
]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	summary := self instantiate: RiCommitSummaryPresenter.
	notebook := self newNotebook.

]

{ #category : #accessing }
RiElementPresenter >> model: anObject [
	notebook removeAll.
	super model: anObject.
	notebook pages
		ifNotEmpty: [ notebook selectPage: notebook pages last ]
]

{ #category : #accessing }
RiElementPresenter >> refreshOnModelUpdate [
	| element |
	element := model at: #element.

	summary model: element.

	(model at: #diffModels) do: [ :each |
		self addPageFor: each to: element ]
]
