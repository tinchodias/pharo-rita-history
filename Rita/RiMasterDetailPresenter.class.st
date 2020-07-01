Class {
	#name : #RiMasterDetailPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'masterPresenter',
		'detailPresenter'
	],
	#category : #'Rita-UI'
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

{ #category : #initialization }
RiMasterDetailPresenter >> detailPresenterClass [
	^ self subclassResponsibility
]

{ #category : #initialization }
RiMasterDetailPresenter >> initializePresenters [
	masterPresenter := self instantiate: self masterPresenterClass.
	detailPresenter := self instantiate: self detailPresenterClass
]

{ #category : #initialization }
RiMasterDetailPresenter >> masterPresenterClass [
	^ self subclassResponsibility
]
