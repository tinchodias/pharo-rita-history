"
self new openWithSpec.
"
Class {
	#name : #HiMSearchPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textInput',
		'resultsLabel',
		'previousButton',
		'nextButton',
		'highlightAllButton',
		'searchModel',
		'lastResultModel',
		'newCurrentResultBlock',
		'newResultsBlock',
		'highlightAllEnabled',
		'toggledHighlightAllBlock'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMSearchPresenter class >> defaultSpec [
	<spec>
	<script: 'self new openWithSpec'>
	
	^ (SpBoxLayout newHorizontal
			add: #textInput
				withConstraints: [ :constraints |
				 	constraints
					fill: true; expand: true;
						width: 200 ];
			add: #resultsLabel
				withConstraints: [ :constraints | 
					constraints
						fill: false];
			add: #previousButton
				withConstraints: [ :constraints | 
					constraints
						width: 60 ];
			add: #nextButton
				withConstraints: [ :constraints | 
					constraints
						width: 60 ];
			add: #highlightAllButton
				withConstraints: [ :constraints | 
					constraints
						width: 90 ];
			yourself)
]

{ #category : #actions }
HiMSearchPresenter >> goToNextResult [
	lastResultModel goToNextResult.
	newCurrentResultBlock value.
	self refresh
]

{ #category : #actions }
HiMSearchPresenter >> goToPreviousResult [
	lastResultModel goToPreviousResult.
	newCurrentResultBlock value.
	self refresh.
]

{ #category : #accessing }
HiMSearchPresenter >> highlightAllEnabled: aBoolean [
	highlightAllEnabled := aBoolean.
	toggledHighlightAllBlock ifNotNil: [
		toggledHighlightAllBlock value ].

]

{ #category : #initialization }
HiMSearchPresenter >> initializeWidgets [
	
	textInput := (self instantiate: SpTextInputFieldPresenter)
"		autoAccept: true;"
		placeholder: 'Search...';
		whenTextChangedDo: [ :newText | self search: newText ];
		yourself.

	resultsLabel := self instantiate: SpLabelPresenter. 

	previousButton := (self instantiate: SpButtonPresenter)
		icon: (self iconNamed: #back);
		label: 'Prev';
		action: [ self goToPreviousResult ];
		yourself.
	
	nextButton := (self instantiate: SpButtonPresenter)
		icon: (self iconNamed: #forward);
		label: 'Next';
		action: [ self goToNextResult ];
		yourself.

	highlightAllButton := (self instantiate: SpToggleButtonPresenter)
		label: 'Highlight all';
		whenChangedDo: [ :newValue | self highlightAllEnabled: newValue ];
		yourself.

	self focusOrder
		add: textInput;
		add: previousButton;
		add: nextButton;
		add: highlightAllButton.

	"Model initialization. TODO: move elsewhere"
	searchModel := HiMSearch new.
	searchModel includeBlock: [ :node :text |
		node isTopParent and: [
		node object includesSubstring: text caseSensitive: true] ].
	lastResultModel := HiMNoResults new.
	highlightAllEnabled := true.

	self refresh.
	

]

{ #category : #accessing }
HiMSearchPresenter >> isHighlightAllEnabled [
	^ highlightAllEnabled
]

{ #category : #accessing }
HiMSearchPresenter >> lastResultModel [
	^ lastResultModel
]

{ #category : #accessing }
HiMSearchPresenter >> newResultIndexBlock: anObject [
	newCurrentResultBlock := anObject
]

{ #category : #accessing }
HiMSearchPresenter >> newResultsBlock: aBlockClosure [ 
	newResultsBlock := aBlockClosure
]

{ #category : #actions }
HiMSearchPresenter >> refresh [
	| hasResults |
	hasResults := lastResultModel notNil and: [ lastResultModel hasResults ].
	previousButton enabled: hasResults.
	nextButton enabled: hasResults.
	highlightAllButton state: self isHighlightAllEnabled.

	resultsLabel label:
		(hasResults
			ifFalse: [ '      ' ]
			ifTrue: [
				' {1}/{2} ' format: {
					lastResultModel currentIndex.
					lastResultModel nodes size } ])
]

{ #category : #actions }
HiMSearchPresenter >> search: newText [
	searchModel text: newText.
	lastResultModel := searchModel execute.
	newResultsBlock value.
	newCurrentResultBlock value.
	self refresh
]

{ #category : #accessing }
HiMSearchPresenter >> searchModel [
	^ searchModel
]

{ #category : #accessing }
HiMSearchPresenter >> toggledHighlightAllBlock: aBlockClosure [ 
	toggledHighlightAllBlock := aBlockClosure
]
