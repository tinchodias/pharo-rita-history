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
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiTorchDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #roassalPresenter;
		add: #toolBar withConstraints: [ :constraints | constraints height: self toolbarHeight + 16 ];
		yourself
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> aesthetics [
	^ model at: #aesthetics
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildCanvas [

	| query shapes |
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

	canvas color: self aesthetics backgroundColor.

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildClassesTraitsExtensionsAndConnections [

	| query classShapes classIceNodes |
	query := model at: #diffQuery.	

	"First, add classes (and traits)."
	classIceNodes := query nodesForBehaviors.
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

	"Add method extensions"
	canvas addAll: (query nodesForMethodExtensions
		collect: [ :each | renderer shapeForClass: each ]).

	"Add packages"
	self rootModel showPackages ifTrue: [
		| packageShapes |
		packageShapes := query nodesForPackages
			collect: [ :each | renderer shapeForPackage: each ].
		RSEdgeBuilder line
			border: self aesthetics innerBorder;
			canvas: canvas;
			shapes: packageShapes;
			connectFrom: [ :node | node children ].
		canvas addAll: packageShapes ].

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> buildFileStructureAndConnections [
	| query iceNodes shapes |
	query := model at: #diffQuery.
	iceNodes := query nodesForFiles.
	shapes := iceNodes
		collect: [ :each | 
			RSBox new
				noPaint;
				size: self aesthetics widthForMethod * 2;
				model: each;
				border: self aesthetics tinyBoxBorder;
				addInteraction: (RSPopup text: [ :node | node path pathString ]);
				yourself ].
	canvas addAll: shapes
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

	| onlyChangedButton isExpandedButton connectHierarchiesButton showMethodsLOCButton flyDiffButton |
	spawnButton := (self instantiate: SpToolbarButtonPresenter)
			label: 'Expand';
			icon: (self iconNamed: #smallRemoteOpen);
			help: 'Expand this view in a new notebook page.';
			yourself.
	
"	onlyChangedButton := self
		newRootModelToggleButtonFor: #considerOnlyChanged
		label: 'Unchnged'
		icon: #changeUpdate
		help: 'Whether show only changed elements or all the elements, to have context.'.

	isExpandedButton := self
		newRootModelToggleButtonFor: #isExpanded
		label: 'Wide'
		icon: #class
		help: 'Whether use a compact or an expanded representation for classes, traits and extensions.'.
"
"	showMethodsLOCButton := self
		newRootModelToggleButtonFor: #showMethodsLOC
		label: 'LOC'
		icon: #tinyMenu
		help: 'Whether use a compact or an expanded representation for methods.'."

	connectHierarchiesButton := self
		newRootModelToggleButtonFor: #connectHierarchies
		label: 'Hier'
		icon: #hierarchy
		help: 'Whether connect subclasses or leave them free.'.

	showPackagesButton := self
		newRootModelToggleButtonFor: #showPackages
		label: 'Pkgs'
		icon: #package
		help: 'Whether group classes in packages or leave them free.'.

"	flyDiffButton := self 
		newRootModelToggleButtonFor: #flyDiff
		label: 'FlyDiff'
		icon: #announcement
		help: 'Whether show a fly diff.'.
"
	^ self newToolbar
"		addItem: onlyChangedButton;
		addItem: isExpandedButton;
"		addItem: connectHierarchiesButton;
		addItem: showPackagesButton;
"		addItem: showMethodsLOCButton;"
"		addItem: flyDiffButton;"
		addItemRight: spawnButton;
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

	| controls |
	controls := RSCanvasController new.
	controls configuration
		useBasicZoom;
		maxScale: 2.0.
	^ controls

]
