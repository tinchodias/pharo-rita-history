Class {
	#name : #RiTorchDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'spawnButton',
		'roassalPresenter',
		'toolBar',
		'lastCanvas',
		'lastHighlighingController'
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

	renderer := RiTorchUMLClassRenderer newWith: model.
	renderer highlighingController: lastHighlighingController.
	
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
	lastHighlighingController ifNil: [ ^ self ].
	lastHighlighingController highlightAsSecondary: iceNodeCollection.

]

{ #category : #initialization }
RiTorchDiffPresenter >> initializePresenters [
	toolBar := self newSettingsToolBar.
	roassalPresenter := self newRoassalPresenter.
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
RiTorchDiffPresenter >> newRoassalPresenter [
	^ (self instantiate: SpRoassalPresenter)
		script: [ :newCanvas | 
			lastCanvas := newCanvas.
			lastHighlighingController := RiHighlightingController newFor: lastCanvas.
			model ifNotNil: [ self fillLastCanvas ] ];
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> newRootModelToggleButtonFor: aSymbol label: label icon: iconSymbol help: help [

	^ (self instantiate: SpToolBarButton)
		label: label;
		help: help;
		icon: (self iconNamed: iconSymbol);
		action: [ 
			self rootModel toggle: aSymbol.
			self refreshOnModelUpdate ];
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> newSettingsToolBar [

	| onlyChangedButton isExpandedButton connectHierarchiesButton showMethodsLOCButton flyDiffButton |
	spawnButton := (self instantiate: SpToolBarButton)
			label: 'Spawn';
			icon: (self iconNamed: #smallRemoteOpen);
			help: 'Spawn this view in a new notebook page';
			yourself.
	
	onlyChangedButton := self
		newRootModelToggleButtonFor: #considerOnlyChanged
		label: 'All'
		icon: #changeUpdate
		help: 'Whether show only changed elements or all the elements, to have context.'.

	isExpandedButton := self
		newRootModelToggleButtonFor: #isExpanded
		label: 'Wide'
		icon: #class
		help: 'Whether use a compact or an expanded representation for classes, traits and extensions.'.

	showMethodsLOCButton := self
		newRootModelToggleButtonFor: #showMethodsLOC
		label: 'LOC'
		icon: #tinyMenu
		help: 'Whether use a compact or an expanded representation for methods.'.

	connectHierarchiesButton := self
		newRootModelToggleButtonFor: #connectHierarchies
		label: 'Hier'
		icon: #hierarchy
		help: 'Whether connect subclasses or leave them free.'.

	flyDiffButton := self 
		newRootModelToggleButtonFor: #flyDiff
		label: 'FlyDiff'
		icon: #announcement
		help: 'Whether show a fly diff.'.

	^ self newToolBar
		addItem: onlyChangedButton;
		addItem: isExpandedButton;
		addItem: connectHierarchiesButton;
		addItem: showMethodsLOCButton;
		addItem: flyDiffButton;
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
	lastHighlighingController ifNil: [ ^ self ].
	lastHighlighingController highlightAsSelected: anIceNode.

]
