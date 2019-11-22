Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'summaryLabel',
		'diffPresenter',
		'notebook'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #summaryLabel withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #notebook;
		yourself
]

{ #category : #initialization }
RiElementPresenter >> addPageFor: aRiDiffModel to: targetRiCommit [

	| page |
	page := SpNotebookPage
		title: aRiDiffModel title
		icon: (self iconNamed: #diff)
		provider: [
			self diffPresenterFor: aRiDiffModel to: targetRiCommit ].

	notebook addPage: page
]

{ #category : #initialization }
RiElementPresenter >> diffPresenterFor: aRiDiffModel to: targetRiCommit [
	
	| iceDiff |
	[ 	iceDiff := aRiDiffModel iceDiffTo: targetRiCommit ]
		on: Error do: [:e |
			self reportWarning: e.
			^ self newLabel
				label: 'Failed to calculate diff';
				yourself ].

	^ RiFullDiffPresenter new
		model: (model copy
			add: #iceDiff -> iceDiff;
			yourself);
		yourself
]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	summaryLabel := self newLabel.
	notebook := self newNotebook.
]

{ #category : #initialization }
RiElementPresenter >> model: anObject [
	notebook removeAll.
	super model: anObject.
	notebook pages
		ifNotEmpty: [ notebook selectPage: notebook pages last ]
]

{ #category : #initialization }
RiElementPresenter >> refreshOnModelUpdate [
	summaryLabel label: 'SHA: ', (model at: #element) shortId.

	(model at: #diffModels) do: [ :each |
		self addPageFor: each to: (model at: #element) ]
]
