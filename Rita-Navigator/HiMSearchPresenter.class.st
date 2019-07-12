"
self new openWithSpec.
"
Class {
	#name : #HiMSearchPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'textInput',
		'resultsLabel',
		'previousButton',
		'nextButton'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMSearchPresenter class >> defaultSpec [
	^SpBoxLayout newVertical
		add: #textInput;
		add: #resultsLabel;
		add: #previousButton;
		add: #nextButton;
		yourself
]

{ #category : #initialization }
HiMSearchPresenter >> initializeWidgets [
	
	textInput := self instantiate: SpTextInputFieldPresenter.
	textInput
		placeholder: 'Search...';
		whenTextChangedDo: [:e | e halt ].

	resultsLabel := self instantiate: SpLabelPresenter. 

	previousButton := self instantiate: SpButtonPresenter. 
	previousButton icon: (self iconNamed: #arrowUp).
	
	nextButton := self instantiate: SpButtonPresenter.
	nextButton icon: (self iconNamed: #nextUp).

]
