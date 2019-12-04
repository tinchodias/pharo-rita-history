Class {
	#name : #RiTorchDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'spawnButton',
		'roassalPresenter',
		'toolBar',
		'lastCanvas',
		'highlighingController'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiTorchDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #roassalPresenter;
		add: #toolBar withConstraints: [ :constraints | constraints height: self toolbarHeight + 16 ];
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> childrenToShowFor: node withClassName: aClassName [
	^ (node children select: [ :each | each value definition class name = aClassName ])
		sorted: [ :a :b | a value definition class name < b value definition class name ]
]

{ #category : #initialization }
RiTorchDiffPresenter >> fillLastCanvas [

	| query nodesWithClassesTraitsAndExtensions renderer builder |
	query := RiDiffQuery new
		diff: (model at: #iceDiff);
		onlyConsiderChanged: self rootModel considerOnlyChanged;
		yourself.
	nodesWithClassesTraitsAndExtensions := query nodesForBehaviors, query nodesForMethodExtensions.

	renderer := RiTorchUMLClassRenderer new.
	renderer
		blockWhenNodeSelected: (model at: #blockWhenNodeSelected);
		blockWhenNodesHighlighted: (model at: #blockWhenNodesHighlighted);
		isExpanded: self rootModel isExpanded;
		showMethodsLOC: self rootModel showMethodsLOC.

	highlighingController := RiHighlightingController newFor: lastCanvas.
	renderer highlighingController: highlighingController.
	
	renderer aesthetics: (model at: #aesthetics).
	
	builder := RSUMLClassBuilder new
		container: lastCanvas;
		classes: nodesWithClassesTraitsAndExtensions;
		renderer: renderer;
		yourself.

	builder modelDescriptor: (RiIceNodeUMLModelDescriptor new
		classname: [ :node | node value name ];
		classProperties: [ :node | self childrenToShowFor: node withClassName: #IcePropertyDefinition ];
		instVars: [ :node | self childrenToShowFor: node withClassName: #IceVariableDefinition ];
		methods: [ :node | self methodsToShowFor: node ];
		superclass: [ :node |
			(self rootModel connectHierarchies not or: [
				node value definition isExtensionDefinition])
					ifTrue: [ nil ]
					ifFalse: [
						| superclassName |
						superclassName := node value definition asMCDefinition superclassName.
						nodesWithClassesTraitsAndExtensions
							detect: [:each | each value definition name = superclassName ]
							ifNone: [ nil ] ] ]).

	builder build.

]

{ #category : #accessing }
RiTorchDiffPresenter >> highlightIceNode: iceNodeCollection [
	highlighingController ifNil: [ ^ self ].
	highlighingController highlightAsSecondary: iceNodeCollection.

]

{ #category : #initialization }
RiTorchDiffPresenter >> initializePresenters [

	toolBar := self newSettingsToolBar.
		
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
				ifTrue: [ a value definition linesOfCode > b value definition linesOfCode ]
				ifFalse: [ a value class name < b value class name ] ].
	^ methodNodes
]

{ #category : #initialization }
RiTorchDiffPresenter >> newSettingsToolBar [

	| onlyChangedButton isExpandedButton connectHierarchiesButton showMethodsLOCButton |
	spawnButton := (self instantiate: SpToolBarButton)
			label: 'Spawn';
			icon: (self iconNamed: #smallRemoteOpen);
			help: 'Spawn this view in a new notebook page';
			yourself.
	
	onlyChangedButton := (self instantiate: SpToolBarButton)
		label: 'All';
		icon: (self iconNamed: #changeUpdate);
		help: 'Whether show only changed elements or all the elements, to have context.';
		action: [
			self rootModel considerOnlyChanged: self rootModel considerOnlyChanged not.
			self refreshOnModelUpdate ];
		yourself.

	isExpandedButton := (self instantiate: SpToolBarButton)
		label: 'Wide';
		icon: (self iconNamed: #class);
		help: 'Whether use a compact or an expanded representation for classes, traits and extensions.';
		action: [
			self rootModel isExpanded: self rootModel isExpanded not.
			self refreshOnModelUpdate ];
		yourself.

	showMethodsLOCButton := (self instantiate: SpToolBarButton)
		label: 'LOC';
		icon: (self iconNamed: #tinyMenu);
		help: 'Whether use a compact or an expanded representation for methods.';
		action: [
			self rootModel showMethodsLOC: self rootModel showMethodsLOC not.
			self refreshOnModelUpdate ];
		yourself.

	connectHierarchiesButton := SpToolBarButton new
		label: 'Hier';
		icon: (self iconNamed: #class);
		help: 'Whether connect subclasses or leave them free.';
		action: [
			self rootModel connectHierarchies: self rootModel connectHierarchies not.
			self refreshOnModelUpdate ];
		yourself.

	^ self newToolBar
		addItem: onlyChangedButton;
		addItem: isExpandedButton;
		addItem: connectHierarchiesButton;
		addItem: showMethodsLOCButton;
		addItemRight: spawnButton;
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.
	spawnButton action: [ (model at: #blockForSpawn) value: model ]
]

{ #category : #initialization }
RiTorchDiffPresenter >> rootModel [
	^ model at: #root
]

{ #category : #accessing }
RiTorchDiffPresenter >> selectIceNode: anIceNode [
	highlighingController ifNil: [ ^ self ].
	highlighingController highlightAsSelected: anIceNode.

]
