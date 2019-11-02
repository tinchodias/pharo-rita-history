Class {
	#name : #RiIceDiffPresenter,
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
RiIceDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #onlyChangedCheckbox withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #roassalPresenter;
		add: #spawnButton withConstraints: [ :constraints | constraints height: self buttonHeight ];
		yourself
]

{ #category : #initialization }
RiIceDiffPresenter >> blockForSpawn: aBlock [
	spawnButton action: aBlock
]

{ #category : #initialization }
RiIceDiffPresenter >> fillLastView [

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
RiIceDiffPresenter >> initializePresenters [
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
RiIceDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.

]