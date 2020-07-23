Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPresenter',
		'notebook',
		'header'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementPresenter class >> defaultSpec [
	^ SpPanedLayout newVertical
		position: 0.07;
		add: #header;
		add: #notebook;
		yourself
]

{ #category : #private }
RiElementPresenter >> addPageFor: aRiDiffModel to: targetRiCommit [
	| page |
	page := SpNotebookPage
		title: aRiDiffModel title
		icon: aRiDiffModel icon
		provider: [ self diffPresenterFor: aRiDiffModel to: targetRiCommit ].
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
				add: #expandedIceNodes -> (RiVisibleTreeStrategy 
					expandedIceNodesFrom: iceDiff tree children);
				yourself);
			yourself
]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	header := self instantiate: RiElementHeaderPresenter.
	notebook := self newNotebook.

]

{ #category : #accessing }
RiElementPresenter >> refreshOnModelUpdate [
	| element |
	element := model at: #element.
	header model: element.

	notebook removeAll.
	(model at: #parentDiffModels)
		do: [ :each | self addPageFor: each to: element ].
	(model at: #pinDiffModels)
		select: [ :each | each shouldCompareTo: element ]
		thenDo: [ :each | self addPageFor: each to: element ].
	notebook pages ifNotEmpty: [
		notebook selectPage: notebook pages last ]
]
