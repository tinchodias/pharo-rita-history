Class {
	#name : #RiMasterDetailPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'masterPresenter',
		'detailPresenter'
	],
	#category : #'Rita-UI-Spec2-Base'
}

{ #category : #specs }
RiMasterDetailPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add: #masterPresenter;
		add: #detailPresenter;
		yourself
]

{ #category : #initialization }
RiMasterDetailPresenter >> connectMasterToDetail [
	self subclassResponsibility
]

{ #category : #initialization }
RiMasterDetailPresenter >> connectPresenters [
	self connectMasterToDetail
]

{ #category : #accessing }
RiMasterDetailPresenter >> detailPresenter [

	^ detailPresenter
]

{ #category : #initialization }
RiMasterDetailPresenter >> detailPresenterClass [
	^ self subclassResponsibility
]

{ #category : #initialization }
RiMasterDetailPresenter >> initializeDetailPresenter [
	detailPresenter := self instantiate: self detailPresenterClass
]

{ #category : #initialization }
RiMasterDetailPresenter >> initializeMasterPresenter [
	masterPresenter := self instantiate: self masterPresenterClass
]

{ #category : #initialization }
RiMasterDetailPresenter >> initializePresenters [
	self initializeMasterPresenter.
	self initializeDetailPresenter
]

{ #category : #accessing }
RiMasterDetailPresenter >> masterPresenter [

	^ masterPresenter
]

{ #category : #initialization }
RiMasterDetailPresenter >> masterPresenterClass [
	^ self subclassResponsibility
]
