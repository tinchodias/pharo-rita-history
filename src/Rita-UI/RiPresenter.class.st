"
I'm the abstract superclass of presenters that have a model and a refresh hook.
"
Class {
	#name : 'RiPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model'
	],
	#category : 'Rita-UI-Spec2-Base',
	#package : 'Rita-UI',
	#tag : 'Spec2-Base'
}

{ #category : 'canvas building' }
RiPresenter >> aesthetics [

	^ self application aesthetics
]

{ #category : 'accessing' }
RiPresenter >> model [
	^ model
]

{ #category : 'accessing' }
RiPresenter >> model: anObject [
	model := anObject.
	self refreshOnModelUpdate
]

{ #category : 'updating' }
RiPresenter >> refreshOnModelUpdate [
	"Refresh the presenter after model was (possibly) updated. Assumes widgets are already built."
]

{ #category : 'error handling' }
RiPresenter >> reportWarning: anException [
	self
		traceCrTab: DateAndTime now;
		traceCrTab: self;
		traceCr: anException.
]
