Class {
	#name : 'RiRepositoryMasterDetailPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'detailPresenter',
		'masterPresenter'
	],
	#category : 'Rita-UI-Spec2-Repository',
	#package : 'Rita-UI',
	#tag : 'Spec2-Repository'
}

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> connectMasterToDetail [
	masterPresenter blockForElementSelected: [ :targetRiElement |
		detailPresenter model: 
			(model
				at: #element put: targetRiElement;
				at: #parentDiffModels put: (self parentDiffModelsFor: targetRiElement);
				yourself) ].
	
	"Bindings are not added before building."
	self whenBuiltDo: [ self initializeKeyBindings ]
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> connectPresenters [
	self connectMasterToDetail
]

{ #category : 'private' }
RiRepositoryMasterDetailPresenter >> currentFullDiffPresenterIfPresent: aBlockClosure [ 
	^ detailPresenter selectedDiffModelIfFound: aBlockClosure
]

{ #category : 'layout' }
RiRepositoryMasterDetailPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: 30 percent;
		  add: masterPresenter;
		  add: detailPresenter;
		  yourself
]

{ #category : 'accessing' }
RiRepositoryMasterDetailPresenter >> detailPresenter [

	^ detailPresenter
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> detailPresenterClass [
	^ RiElementPresenter
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> initializeDetailPresenter [
	detailPresenter := self instantiate: self detailPresenterClass
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> initializeKeyBindings [
	self bindKeyCombination: $n meta toAction: [ (model at: #blockForIterateNext) value ].
	self bindKeyCombination: $b meta toAction: [ (model at: #blockForIterateBack) value ].
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> initializeMasterPresenter [
	masterPresenter := self instantiate: self masterPresenterClass
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> initializePresenters [
	self initializeMasterPresenter.
	self initializeDetailPresenter
]

{ #category : 'testing' }
RiRepositoryMasterDetailPresenter >> isForRepository: aRiRepository [

	^ aRiRepository = self repository
]

{ #category : 'accessing' }
RiRepositoryMasterDetailPresenter >> masterPresenter [

	^ masterPresenter
]

{ #category : 'initialization' }
RiRepositoryMasterDetailPresenter >> masterPresenterClass [
	^ RiRepositoryPresenter
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
		masterPresenter refreshOnPinsUpdate ].

	model at: #blockForIterateNext put: [
		self currentFullDiffPresenterIfPresent: [ :p |
			p selectNextIceNode ] ].
	model at: #blockForIterateBack put: [
		self currentFullDiffPresenterIfPresent: [ :p |
			p selectBackIceNode ] ].

	masterPresenter model: model.

]

{ #category : 'accessing' }
RiRepositoryMasterDetailPresenter >> repository [

	^ self model at: #repository
]
