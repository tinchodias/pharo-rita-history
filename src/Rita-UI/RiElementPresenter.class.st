Class {
	#name : 'RiElementPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'diffPresenter',
		'notebook'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'private' }
RiElementPresenter >> addPageFor: aRiDiffModel to: targetRiCommit [

	notebook addPage: (SpNotebookPage title: aRiDiffModel title icon: aRiDiffModel icon provider: [ self diffPresenterFor: aRiDiffModel to: targetRiCommit ])
]

{ #category : 'layout' }
RiElementPresenter >> defaultLayout [

	^ SpBoxLayout newVertical
		  add: notebook;
		  yourself
]

{ #category : 'private' }
RiElementPresenter >> diffPresenterFor: aRiDiffModel to: targetRiCommit [

	| iceDiff expandedNodes |
	iceDiff := aRiDiffModel iceDiffFrom: targetRiCommit.
	expandedNodes := OrderedCollection streamContents: [ :stream |
		iceDiff tree withAllChildrenDo: [ :each | stream nextPut: each ] ].

	^ (self instantiate: RiFullDiffPresenter)
			model: (model copy
				add: #iceDiff -> iceDiff;
				add: #shadowedIceNodes -> IdentitySet new;
				add: #expandedIceNodes -> expandedNodes;
				yourself);
			yourself
]

{ #category : 'initialization' }
RiElementPresenter >> initializePresenters [

	notebook := self newNotebook
]

{ #category : 'accessing' }
RiElementPresenter >> refreshOnModelUpdate [

	| element |
	element := model at: #element.
	notebook removeAll.
	(model at: #parentDiffModels) do: [ :each | self addPageFor: each to: element ].
	(model at: #pinDiffModels)
		select: [ :each | each shouldCompareTo: element ]
		thenDo: [ :each | self addPageFor: each to: element ].
	notebook pages ifNotEmpty: [ notebook selectPage: notebook pages first ]
]

{ #category : 'private' }
RiElementPresenter >> selectedDiffModelIfFound: aBlockClosure [ 
	^ aBlockClosure value: notebook selectedPage activePresenter 
]
