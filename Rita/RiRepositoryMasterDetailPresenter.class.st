Class {
	#name : #RiRepositoryMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> connectMasterToDetail [
	masterPresenter blockForElementSelected: [ :targetRiElement |
		| parentDiffModels |
		parentDiffModels := targetRiElement ancestors collect: [:each | 
			RiParentDiffModel parentRiElement: each ].
		detailPresenter model: 
			(model
				at: #element put: targetRiElement;
				at: #parentDiffModels put: parentDiffModels;
				yourself) ]
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> detailPresenterClass [
	^ RiElementPresenter
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> masterPresenterClass [
	^ RiRepositoryPresenter
]

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> refreshOnModelUpdate [
	model at: #pinDiffModels put: OrderedCollection new.
	
	model at: #blockWhenPinsChanged put: [
		"Refresh only table to show the pin: the detail will refresh on next table selection."
		masterPresenter refreshOnPinsUpdate ].

	masterPresenter model: model.

]
