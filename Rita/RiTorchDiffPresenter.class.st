Class {
	#name : #RiTorchDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'lastView',
		'spawnButton',
		'roassalPresenter',
		'toolBar',
		'onlyChangedButton'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiTorchDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar withConstraints: [ :constraints | constraints height: self toolbarHeight + 16 ];
		add: #roassalPresenter;
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> fillLastView [

	| query umlBuilder |
	query := RiDiffQuery new
		diff: (model at: #iceDiff);
		onlyConsiderChanged: (model at: #root) considerOnlyChanged;
		yourself.

	umlBuilder := RiDiffUMLClassBuilder forView: lastView.
	umlBuilder
		setLayoutVerticalWithMarkers: false;
		disableSelectors;
		classes: query nodesForBehaviors, query nodesForMethodExtensions;
		build.

]

{ #category : #initialization }
RiTorchDiffPresenter >> initializePresenters [
	spawnButton := SpToolBarButton new
			label: 'Spawn';
			icon: (self iconNamed: #smallRemoteOpen);
			help: 'Spawn this view in a new notebook page';
			yourself.
	
	onlyChangedButton := SpToolBarButton new
		label: 'All';
		icon: (self iconNamed: #changeUpdate);
		help: 'Whether show only changed elements or all the elements, to have context.';
		action: [
			(model at: #root) considerOnlyChanged: (model at: #root) considerOnlyChanged not.
			self refreshOnModelUpdate ];
		yourself.

	toolBar := self newToolBar
		addItem: onlyChangedButton;
		addItem: spawnButton;
		yourself.
		
	roassalPresenter := self instantiate: RoassalPresenter.
	roassalPresenter script: [ :newView | 
		lastView := newView.
		model ifNotNil: [ self fillLastView ] ].
]

{ #category : #initialization }
RiTorchDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.
	spawnButton action: [ (model at: #blockForSpawn) value: model ]
]
