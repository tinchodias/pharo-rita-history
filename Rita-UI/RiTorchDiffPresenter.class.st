Class {
	#name : #RiTorchDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'spawnButton',
		'roassalPresenter',
		'toolBar',
		'highlighingController',
		'canvas',
		'renderer',
		'showPackagesButton'
	],
	#category : #'Rita-UI-Spec2-Diff'
}

{ #category : #specs }
RiTorchDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #toolBar withConstraints: [ :constraints | constraints height: self toolbarHeight + 8];
		add: #roassalPresenter;
		yourself
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> aesthetics [
	^ model at: #aesthetics
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildCanvas [

	canvas color: self aesthetics backgroundColor.

	highlighingController := RiHighlightingController
		canvas: canvas
		aesthetics: self aesthetics.
	renderer := RiTorchRenderer model: model highlighingController: highlighingController.

	self buildClassesTraitsExtensionsAndConnections.
	self buildFileStructureAndConnections.
	
	self canvasLayout on: canvas nodes.

	canvas
		addInteraction: self zoomingInteraction;
		addInteraction: self packInteraction;
		when: RSMouseClick do: [
			highlighingController setPrimaryOutlineTo: nil ].

	self buildHelpIcon.
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildClassesTraitsExtensionsAndConnections [

	| query classShapes classIceNodes packageShapes |
	query := model at: #diffQuery.	

	"First, add classes (and traits) with expanded parents."
	classIceNodes := query nodesForBehaviors
		select: [ :each | renderer areAllParentsExpanded: each ].
	classShapes := classIceNodes collect: [ :each | renderer shapeForClass: each ].

	self rootModel connectHierarchies ifTrue: [
		renderer edgeBuilder
			canvas: canvas;
			shapes: classShapes;
			connectFrom: [ :node |
				| superclassName |
				superclassName := node value definition asMCDefinition superclassName.
				classIceNodes
					detect: [:each | each value definition name = superclassName ]
					ifNone: [ nil ] ] ].
	canvas addAll: classShapes.

	"Add method extensions with expanded parents"
	canvas addAll: (query nodesForMethodExtensions
		select: [ :each | renderer areAllParentsExpanded: each ]
		thenCollect: [ :each | renderer shapeForClass: each ]).

	"Add packages (only if those collapsed)"
	packageShapes := query nodesForPackages
		select: [ :each | (renderer isExpanded: each) not ]
		thenCollect: [ :each | renderer shapeForPackage: each ].
	canvas addAll: packageShapes.

"	self rootModel showPackages ifTrue: [
		| packageShapes |
		packageShapes := query nodesForPackages
			collect: [ :each | renderer shapeForPackage: each ].
		RSEdgeBuilder line
			border: self aesthetics innerBorder;
			canvas: canvas;
			shapes: packageShapes;
			connectFromAll: [ :node | node children ].
		canvas addAll: packageShapes ].
"
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildFileStructureAndConnections [
	| query iceNodes |
	query := model at: #diffQuery.

	iceNodes := query nodesForFiles
		select: [ :each | renderer areAllParentsExpanded: each ].

	iceNodes ifNotEmpty: [
		canvas add: (renderer shapeForFilesBox: iceNodes) ]
	
	
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildHelpIcon [

	self flag: #todo. "Hacky: Update help icon"
	(canvas fixedShapes detect: [ :each | each class = RSLabel ])
		text: '?'";
		fontSize: 10."
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> canvasLayout [
	^ RSTreeLayout new
		verticalGap: self aesthetics gapFromClassToSubclass;
		horizontalGap: self aesthetics gapFromSubclassToSibling;
		yourself
]

{ #category : #accessing }
RiTorchDiffPresenter >> ensureAddShadowLayerOverAll: iceNodeCollection [
	highlighingController ifNil: [ ^ self ].
	highlighingController ensureAddShadowLayerOverAll: iceNodeCollection

]

{ #category : #accessing }
RiTorchDiffPresenter >> ensureRemoveShadowLayerFromAll: iceNodeCollection [
	highlighingController ifNil: [ ^ self ].
	highlighingController ensureRemoveShadowLayerFromAll: iceNodeCollection

]

{ #category : #accessing }
RiTorchDiffPresenter >> highlightIceNode: iceNodeCollection [
	highlighingController ifNil: [ ^ self ].
	highlighingController setSecondaryOutlineToAll: iceNodeCollection.

]

{ #category : #initialization }
RiTorchDiffPresenter >> initializePresenters [

	toolBar := self newSettingsToolBar.
	roassalPresenter := self newRoassalPresenter.
]

{ #category : #initialization }
RiTorchDiffPresenter >> newRoassalPresenter [
	^ (self instantiate: SpRoassalPresenter)
		script: [ :newCanvas | 
			model ifNotNil: [
				canvas := newCanvas.
				self buildCanvas ] ];
		yourself
]

{ #category : #initialization }
RiTorchDiffPresenter >> newRootModelToggleButtonFor: aSymbol label: label icon: iconSymbol help: help [

	^ (self instantiate: SpToolbarToggleButtonPresenter)
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

	| connectHierarchiesButton iterateNextButton iterateBackButton |
	spawnButton := (self instantiate: SpToolbarButtonPresenter)
			label: 'Maximize';
			icon: (self iconNamed: #smallRemoteOpen);
			help: 'Open this diff view in a new notebook page.';
			yourself.
	connectHierarchiesButton := self
		newRootModelToggleButtonFor: #connectHierarchies
		label: 'Hchy'
		icon: #hierarchy
		help: 'Whether connect subclasses or leave them free.'.
	iterateNextButton := (self instantiate: SpToolbarButtonPresenter)
			label: 'Next';
			icon: (self iconNamed: #forward);
			help: 'Select next leaf in the tree';
			action: [ (model at: #blockForIterateNext) value ];
			yourself.
	iterateBackButton := (self instantiate: SpToolbarButtonPresenter)
			label: 'Back';
			icon: (self iconNamed: #back);
			help: 'Select previous leaf in the tree';
			action: [ (model at: #blockForIterateBack) value ];
			yourself.

	^ self newToolbar
		addItem: connectHierarchiesButton;
"		addItemRight: iterateNextButton;
		addItemRight: iterateBackButton;
"		addItem: spawnButton;
		yourself
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> packInteraction [
	"Interaction to pack hierarachies."

	| packer |
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: self aesthetics gapBetweenHierarchies.
	^ packer

]

{ #category : #accessing }
RiTorchDiffPresenter >> refreshOnCheckedIceNodesChanged [
	highlighingController
		setShadowedIceNodes: (model at: #shadowedIceNodes)
]

{ #category : #accessing }
RiTorchDiffPresenter >> refreshOnModelUpdate [
	roassalPresenter refresh.
	spawnButton action: [ (model at: #blockForSpawn) value: model ]
]

{ #category : #accessing }
RiTorchDiffPresenter >> rootModel [
	^ model at: #root
]

{ #category : #accessing }
RiTorchDiffPresenter >> selectIceNode: anIceNode [
	highlighingController ifNil: [ ^ self ].
	highlighingController setPrimaryOutlineTo: anIceNode.

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> zoomingInteraction [
	"Interaction for zooming."

	| anInteraction |
	anInteraction := RSCanvasController new.
	anInteraction configuration
		useBasicZoom;
		maxScale: 3.0.
	^ anInteraction

]
