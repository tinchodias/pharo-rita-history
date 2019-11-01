Class {
	#name : #RiElementDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'lastView',
		'onlyChangedCheckbox',
		'spawnButton',
		'roassalPresenter'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #onlyChangedCheckbox withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #roassalPresenter;
		add: #spawnButton withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #initialization }
RiElementDiffPresenter >> blockForSpawn: aBlock [
	spawnButton action: aBlock
]

{ #category : #initialization }
RiElementDiffPresenter >> fillLastView [

	| query umlBuilder |
	query := RiDiffQuery new
		diff: model;
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
RiElementDiffPresenter >> initializePresenters [
	spawnButton := self newButton.
	spawnButton icon: (self iconNamed: #smallRemoteOpen).
	
	onlyChangedCheckbox := self newCheckBox.
	onlyChangedCheckbox
		label: 'Only changed';
		state: true;
		whenChangedDo: [ self refreshOnModelUpdate ].
		
	roassalPresenter := self instantiate: RoassalPresenter.
	roassalPresenter script: [ :newView | 
		lastView := newView.
		model ifNotNil: [ self fillLastView ] ].
]

{ #category : #initialization }
RiElementDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.

]
