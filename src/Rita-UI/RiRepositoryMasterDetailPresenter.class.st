Class {
	#name : 'RiRepositoryMasterDetailPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'detailPresenter',
		'repositoryCommitsPresenter'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> connectPresenters [

	repositoryCommitsPresenter whenSelectionChangedDo: [ :targetRiElement |
			detailPresenter model: (model
					 at: #element put: targetRiElement;
					 at: #parentDiffModels put: (self parentDiffModelsFor: targetRiElement);
					 yourself) ].
	
	"Bindings are not added before building."
	self whenBuiltDo: [
			self bindKeyCombination: $n meta toAction: [ (model at: #blockForIterateNext) value ].
			self bindKeyCombination: $b meta toAction: [ (model at: #blockForIterateBack) value ] ]
]

{ #category : 'private' }
RiRepositoryMasterDetailPresenter >> currentFullDiffPresenterIfPresent: aBlockClosure [ 
	^ detailPresenter selectedDiffModelIfFound: aBlockClosure
]

{ #category : 'layout' }
RiRepositoryMasterDetailPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: 20 percent;
		  add: repositoryCommitsPresenter;
		  add: detailPresenter;
		  yourself
]

{ #category : 'accessing' }
RiRepositoryMasterDetailPresenter >> detailPresenter [

	^ detailPresenter
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> initializePresenters [

	repositoryCommitsPresenter := self instantiate: RiRepositoryCommitsPresenter.
	detailPresenter := self instantiate: RiElementPresenter
]

{ #category : 'testing' }
RiRepositoryMasterDetailPresenter >> isForRepository: aRiRepository [

	^ aRiRepository = self repository
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> parentDiffModelsFor: targetRiElement [
	"IMPORTANT: As other tools only answer the diff to the first ancestor (potentially ignoring others, in case of merge)."

	^ targetRiElement
		ancestorToDiffIfPresent: [ :ancestor | {
			RiParentDiffModel parentRiElement: ancestor } ]
		ifAbsent: [ #() ]
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> refreshOnModelUpdate [
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
RiRepositoryMasterDetailPresenter >> repository [

	^ self model at: #repository
]
