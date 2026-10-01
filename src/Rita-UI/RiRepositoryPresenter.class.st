"
I am a presenter to browse a repository.

I'll display the list of commits of the project (including a virtual commit of uncommited changes), info on the selected commit and a visualization to see the diff of this commit (to its parent or to some pinned commits).


"
Class {
	#name : 'RiRepositoryPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'commitDetailsWidget',
		'repositoryCommitsPresenter',
		'notebook'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'private' }
RiRepositoryPresenter >> addPageFor: aRiDiffModel to: targetRiElement [

	notebook addPage: (SpNotebookPage title: aRiDiffModel title icon: aRiDiffModel icon provider: [ self diffPresenterFor: aRiDiffModel to: targetRiElement ])
]

{ #category : 'initialization' }
RiRepositoryPresenter >> connectPresenters [

	super connectPresenters.
	repositoryCommitsPresenter whenSelectionChangedDo: [ :selectedRiElements | self selectElements: selectedRiElements ].

	"Bindings are not added before building."
	self whenBuiltDo: [
			self bindKeyCombination: $n meta toAction: [ (model at: #blockForIterateNext) value ].
			self bindKeyCombination: $b meta toAction: [ (model at: #blockForIterateBack) value ] ]
]

{ #category : 'private' }
RiRepositoryPresenter >> currentFullDiffPresenterIfPresent: aBlockClosure [

	^ aBlockClosure value: notebook selectedPage activePresenter
]

{ #category : 'layout' }
RiRepositoryPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: repositoryCommitsPresenter presenterWidthInPercent percent;
		  add: repositoryCommitsPresenter;
		  add: (SpPanedLayout newVertical
				   positionOfSlider: 0.07;
				   add: commitDetailsWidget;
				   add: notebook;
				   yourself);
		  yourself
]

{ #category : 'private' }
RiRepositoryPresenter >> diffPresenterFor: aRiDiffModel to: targetRiElement [

	| iceDiff expandedNodes |
	iceDiff := aRiDiffModel iceDiffFrom: targetRiElement.
	expandedNodes := OrderedCollection streamContents: [ :stream | iceDiff tree withAllChildrenDo: [ :each | stream nextPut: each ] ].

	^ (self instantiate: RiFullDiffPresenter)
		  model: (model copy
				   add: #iceDiff -> iceDiff;
				   add: #shadowedIceNodes -> IdentitySet new;
				   add: #expandedIceNodes -> expandedNodes;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
RiRepositoryPresenter >> initializePresenters [

	super initializePresenters.
	repositoryCommitsPresenter := self instantiate: RiRepositoryCommitsPresenter.
	commitDetailsWidget := self newText
		                       beNotEditable;
		                       yourself.
	notebook := self newNotebook
]

{ #category : 'testing' }
RiRepositoryPresenter >> isForRepository: aRiRepository [

	^ aRiRepository = self repository
]

{ #category : 'updating' }
RiRepositoryPresenter >> refreshOnModelUpdate [
	model at: #pinDiffModels put: OrderedCollection new.
	
	model at: #blockWhenPinsChanged put: [
		"Refresh only table to show the pin: the detail will refresh on next table selection."
		repositoryCommitsPresenter refreshOnPinsUpdate ].

	model at: #blockForIterateNext put: [
		self currentFullDiffPresenterIfPresent: [ :p |
			p selectNextIceNode ] ].
	model at: #blockForIterateBack put: [
		self currentFullDiffPresenterIfPresent: [ :p |
			p selectBackIceNode ] ].

	repositoryCommitsPresenter model: model.

]

{ #category : 'accessing' }
RiRepositoryPresenter >> repository [

	^ self model at: #repository
]

{ #category : 'private' }
RiRepositoryPresenter >> riElementFor: aCollectionOfRiElement [
	"One selected element stays itself, several of them become a composite."

	^ aCollectionOfRiElement size = 1
		  ifTrue: [ aCollectionOfRiElement first ]
		  ifFalse: [ RiCompositeElement of: aCollectionOfRiElement ]
]

{ #category : 'initialization' }
RiRepositoryPresenter >> selectElements: aCollectionOfRiElement [
	"When the selection changes I reset the notebook and add the pages related to the selection: a single element gets its parent and pin pages, a range of elements gets one single cumulative page. I also update the commit details widget to display the right info"

	| selectedRiAbstractElement |
	aCollectionOfRiElement ifEmpty: [ ^ self ].
	selectedRiAbstractElement := self riElementFor: (self selectionInRepositoryOrder: aCollectionOfRiElement).
	notebook removeAll.
	(selectedRiAbstractElement diffModelsWithPins: (model at: #pinDiffModels)) do: [ :diffModel | self addPageFor: diffModel to: selectedRiAbstractElement ].
	notebook pages ifNotEmpty: [ notebook selectPage: notebook pages first ].
	commitDetailsWidget text: selectedRiAbstractElement commitText
]

{ #category : 'private' }
RiRepositoryPresenter >> selectionInRepositoryOrder: aCollectionOfRiElement [
	"Answer the selected elements ordered the way the repository lists them (newest first). The table delivers the selection in click order, but a composite trusts the caller to pass it in repository order."

	^ self repository elements select: [ :element | aCollectionOfRiElement includes: element ]
]
