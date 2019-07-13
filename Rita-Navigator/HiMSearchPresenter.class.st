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
		'searchModel',
		'lastResultModel',
		'newCurrentResultBlock'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #specs }
HiMSearchPresenter class >> defaultSpec [
	<spec>
	<script: 'self new openWithSpec'>
	
	^ SpBoxLayout newVertical 
		add: (SpBoxLayout newHorizontal
			add: #textInput withConstraints: [ :constraints | 
	"			constraints
					fill: true" ];
			add: #resultsLabel
				withConstraints: [ :constraints | 
				constraints
					width: 50;
					padding: 2;
					expand: false ];

			add: #previousButton
				withConstraints: [ :constraints | 
				constraints
					width: 24;
					padding: 2 ];
			add: #nextButton
				withConstraints: [ :constraints | 
				constraints
					width: 24;
					padding: 2 ];
			yourself
		) withConstraints: [ :constraints | 
				constraints height: self toolbarHeight];
		yourself.
				
]

{ #category : #initialization }
HiMSearchPresenter >> initializeWidgets [
	
	searchModel := HiMSearch new.
		
	textInput := self instantiate: SpTextInputFieldPresenter.
	textInput
		placeholder: 'Search...';
		whenTextChangedDo: [ :newText |
			searchModel text: newText.
			lastResultModel := searchModel execute.
			newCurrentResultBlock value.
			self refresh ].

	resultsLabel := self instantiate: SpLabelPresenter. 

	previousButton := self instantiate: SpButtonPresenter.
	previousButton
		icon: (self iconNamed: #arrowUp);
		action: [
			lastResultModel goToPreviousResult.
			newCurrentResultBlock value.
			self refresh. ].
	
	nextButton := self instantiate: SpButtonPresenter.
	nextButton
		icon: (self iconNamed: #arrowDown);
		action: [
			lastResultModel goToNextResult.
			newCurrentResultBlock value.
			self refresh. ].

]

{ #category : #accessing }
HiMSearchPresenter >> lastResultModel [
	^ lastResultModel
]

{ #category : #accessing }
HiMSearchPresenter >> newResultIndexBlock: anObject [
	newCurrentResultBlock := anObject
]

{ #category : #initialization }
HiMSearchPresenter >> refresh [
	resultsLabel label:
		(lastResultModel
			ifNil: [ 'Not found' ]
			ifNotNil: [
				'{1}/{2}' format: {
					lastResultModel currentIndex.
					lastResultModel nodes size } ])
]

{ #category : #accessing }
HiMSearchPresenter >> searchModel [
	^ searchModel
]
