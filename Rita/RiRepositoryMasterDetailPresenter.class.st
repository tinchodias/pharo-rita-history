Class {
	#name : #RiRepositoryMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI'
}

{ #category : #initialization }
RiRepositoryMasterDetailPresenter >> connectMasterToDetail [
	masterPresenter blockForElementSelected: [ :targetRiElement |
		| parentDiffModels |
		"Other tools only show diff to first ancestor"
		parentDiffModels := targetRiElement ancestors 
			ifEmpty: [ #() ]
			ifNotEmpty: [:col | 
				{ RiParentDiffModel parentRiElement: col first } ].
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
