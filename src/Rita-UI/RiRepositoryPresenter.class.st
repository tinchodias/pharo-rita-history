"
I am a presenter to browse a repository.

I'll display a list of commits and a visualization representing the current commit.

It is also possible to toggle an option to have the visualization in full screen in order to browse it better.
"
Class {
	#name : 'RiRepositoryPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'detailPresenter',
		'commitDetailsWidget',
		'repositoryCommitsPresenter'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'initialization' }
RiRepositoryPresenter >> connectPresenters [

	super connectPresenters.
	repositoryCommitsPresenter whenSelectionChangedDo: [ :targetRiElement |
			detailPresenter model: (model
					 at: #element put: targetRiElement;
					 at: #parentDiffModel put: (self parentDiffModelFor: targetRiElement);
					 yourself).

			commitDetailsWidget text: targetRiElement commitText ].
		
	"Bindings are not added before building."
	self whenBuiltDo: [
			self bindKeyCombination: $n meta toAction: [ (model at: #blockForIterateNext) value ].
			self bindKeyCombination: $b meta toAction: [ (model at: #blockForIterateBack) value ] ]
]

{ #category : 'private' }
RiRepositoryPresenter >> currentFullDiffPresenterIfPresent: aBlockClosure [ 
	^ detailPresenter selectedDiffModelIfFound: aBlockClosure
]

{ #category : 'layout' }
RiRepositoryPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: repositoryCommitsPresenter presenterWidthInPercent percent;
		  add: repositoryCommitsPresenter;
		  add: (SpPanedLayout newVertical
				   positionOfSlider: 0.07;
				   add: commitDetailsWidget;
				   add: detailPresenter;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
RiRepositoryPresenter >> initializePresenters [

	super initializePresenters.
	repositoryCommitsPresenter := self instantiate: RiRepositoryCommitsPresenter.
	detailPresenter := self instantiate: RiElementPresenter.
	commitDetailsWidget := self newText
		                       beNotEditable;
		                       yourself
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
