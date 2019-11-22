Class {
	#name : #RiTorchDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'spawnButton',
		'roassalPresenter',
		'toolBar',
		'onlyChangedButton',
		'lastCanvas'
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
RiTorchDiffPresenter >> fillLastCanvas [

	| query classes renderer builder |
	query := RiDiffQuery new
		diff: (model at: #iceDiff);
		onlyConsiderChanged: (model at: #root) considerOnlyChanged;
		yourself.
	classes := query nodesForBehaviors, query nodesForMethodExtensions.

	renderer := RiTorchUMLClassRenderer new.
	renderer blockWhenNodeSelected: [ :anIceNode |
		(model at: #blockWhenNodeSelected) value: anIceNode ].
	
	builder := RSUMLClassBuilder new
		container: lastCanvas;
		classes: classes;
		renderer: renderer;
		yourself.

	builder modelDescriptor
		classname: [ :node | node value name ];
		instVars: [ :cls | 
			cls children select: [ :each | each value definition isKindOf: IceVariableDefinition ] ];
		methods: [ :node | self methodsToShowFor: node ];
		superclass: [ :node |
			node value definition isExtensionDefinition
				ifTrue: [ nil ]
				ifFalse: [
					| superclassName |
					superclassName := node value definition asMCDefinition superclassName.
					classes detect: [:each | each value definition name = superclassName ] ifNone: [ nil ]] ].

	builder build.

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
		
	roassalPresenter := self instantiate: SpRoassalPresenter.
	roassalPresenter script: [ :newCanvas | 
		lastCanvas := newCanvas.
		model ifNotNil: [ self fillLastCanvas ] ].
]

{ #category : #initialization }
RiTorchDiffPresenter >> methodsToShowFor: iceNodeWithBehavior [
	| methodNodes |
	methodNodes := iceNodeWithBehavior children
		select: [ :each | each value definition isMethodDefinition ].
	methodNodes := methodNodes
		sorted: [ :a :b | 
			a value class = b value class
				ifTrue: [ a value ritaChangeSize > b value ritaChangeSize ]
				ifFalse: [ a value class name < b value class name ] ].
	^ methodNodes
]

{ #category : #initialization }
RiTorchDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.
	spawnButton action: [ (model at: #blockForSpawn) value: model ]
]
