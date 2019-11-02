Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'summaryLabel',
		'diffPresenter',
		'notebook',
		'blockForSpawn'
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
			RiIceDiffPresenter new
				model: (aRiDiffModel iceDiffTo: targetRiCommit);
				blockForSpawn: blockForSpawn;
				yourself ].

	notebook addPage: page
]

{ #category : #initialization }
RiElementPresenter >> blockForSpawn: aBlock [
	blockForSpawn := aBlock 
]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	summaryLabel := self newLabel.
	notebook := self newNotebook
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
