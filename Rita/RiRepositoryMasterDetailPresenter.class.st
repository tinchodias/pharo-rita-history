Class {
	#name : #RiRepositoryMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI'
}

{ #category : #initialization }
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

{ #category : #private }
RiRepositoryMasterDetailPresenter >> currentFullDiffPresenterIfPresent: aBlockClosure [ 
	^ detailPresenter selectedDiffModelIfFound: aBlockClosure
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> detailPresenterClass [
	^ RiElementPresenter
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> initializeKeyBindings [
	self bindKeyCombination: $n meta toAction: [ (model at: #blockForIterateNext) value ].
	self bindKeyCombination: $b meta toAction: [ (model at: #blockForIterateBack) value ].
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> masterPresenterClass [
	^ RiRepositoryPresenter
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> parentDiffModelsFor: targetRiElement [
	"IMPORTANT: As other tools only answer the diff to the first ancestor (potentially ignoring others, in case of merge)."

	^ targetRiElement
		ancestorToDiffIfPresent: [ :ancestor | {
			RiParentDiffModel parentRiElement: ancestor } ]
		ifAbsent: [ #() ]
]

{ #category : #initialization }
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
