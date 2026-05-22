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
RiRepositoryPresenter >> addPageFor: aRiDiffModel to: targetRiCommit [

	notebook addPage: (SpNotebookPage title: aRiDiffModel title icon: aRiDiffModel icon provider: [ self diffPresenterFor: aRiDiffModel to: targetRiCommit ])
]

{ #category : 'initialization' }
RiRepositoryPresenter >> connectPresenters [

	super connectPresenters.
	repositoryCommitsPresenter whenSelectionChangedDo: [ :targetRiElement | self selectCommit: targetRiElement ].
	
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
RiRepositoryPresenter >> diffPresenterFor: aRiDiffModel to: targetRiCommit [

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

{ #category : 'initialization' }
RiRepositoryPresenter >> parentDiffModelFor: targetRiElement [
	"IMPORTANT: As other tools only answer the diff to the first ancestor (potentially ignoring others, in case of merge)."

	^ targetRiElement ancestorToDiffIfPresent: [ :ancestor | RiParentDiffModel parentRiElement: ancestor ] ifAbsent: [ nil ]
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

{ #category : 'initialization' }
RiRepositoryPresenter >> selectCommit: commit [
	"When we select a commit we reset the notebook and add the pages related to this commit. We also update the commit details widget to display the right info"

	notebook removeAll.
	(self parentDiffModelFor: commit) ifNotNil: [ :diff | self addPageFor: diff to: commit ].

	(model at: #pinDiffModels)
		select: [ :each | each shouldCompareTo: commit ]
		thenDo: [ :each | self addPageFor: each to: commit ].

	notebook pages ifNotEmpty: [ notebook selectPage: notebook pages first ].

	commitDetailsWidget text: commit commitText
]
