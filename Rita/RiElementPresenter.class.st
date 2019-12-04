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
	
	^ [
		(self instantiate: RiFullDiffPresenter)
			model: (model copy
				add: #iceDiff -> (aRiDiffModel iceDiffTo: targetRiCommit);
				yourself);
			yourself
		]
		on: Error do: [:e |
			self reportWarning: e.
			self newLabel
				label: 'Failed to calculate diff';
				yourself ].

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
	| element |
	element := model at: #element.

	summaryLabel label: ('SHA: {1}, author: {2}, committer: {3}' format: {
		element shortId. element authorEmail. element committerEmail }).

	(model at: #diffModels) do: [ :each |
		self addPageFor: each to: (model at: #element) ]
]
