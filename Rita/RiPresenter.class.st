Class {
	#name : #RiPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'model',
		'model'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiPresenter >> model [
	^ model
]

{ #category : #accessing }
RiPresenter >> model: anObject [
	model := anObject.
	self refreshOnModelUpdate
]

{ #category : #accessing }
RiPresenter >> refreshOnModelUpdate [
	"Refresh the presenter after model was (possibly) updated. Assumes widgets are already built."
]
