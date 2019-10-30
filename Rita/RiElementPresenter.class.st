Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'summaryLabel',
		'diffPresenter',
		'lastView',
		'onlyChangedCheckbox',
		'spawnButton'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #summaryLabel withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #onlyChangedCheckbox withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #diffPresenter;
		add: #spawnButton withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #'as yet unclassified' }
RiElementPresenter >> blockForSpawn: aBlock [
	spawnButton action: aBlock
]

{ #category : #initialization }
RiElementPresenter >> fillLastView [

	| query umlBuilder |
	model isUncommited ifTrue: [ ^ self "TODO" ].
	
	query := RiDiffQuery new
		diff: model iceCommit diffToParent;
		onlyConsiderChanged: onlyChangedCheckbox state;
		yourself. 

	umlBuilder := RiDiffUMLClassBuilder forView: lastView.
	umlBuilder
		setLayoutVerticalWithMarkers: false;
		disableSelectors;
		classes: query nodesForBehaviors, query nodesForMethodExtensions;
		build.

]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	summaryLabel := self newLabel.

	spawnButton := self newButton.
	spawnButton icon: (self iconNamed: #smallRemoteOpen).
	
	onlyChangedCheckbox := self newCheckBox.
	onlyChangedCheckbox
		label: 'Only changed';
		state: true;
		whenChangedDo: [ self refreshOnModelUpdate ].
		
	diffPresenter := self instantiate: RoassalPresenter.
	diffPresenter script: [ :newView | 
		lastView := newView.
			model ifNotNil: [ self fillLastView ] ].
]

{ #category : #initialization }
RiElementPresenter >> refreshOnModelUpdate [
	summaryLabel label: 'SHA: ', model shortId.
	diffPresenter refresh.

]
