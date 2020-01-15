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
	query := model at: #diffQuery.

	shapes := self classShapesFor: query nodesForBehaviors, query nodesForMethodExtensions.
	shapes := shapes, (self fileShapesFor: query nodesForFiles).
	lastCanvas addAll: shapes.
	
	self canvasLayout on: shapes.

	lastCanvas
		addInteraction: self zoomingInteraction;
		addInteraction: self packInteraction;
		when: RSMouseClick do: [
			lastHighlighingController highlightAsSelected: nil ].

	lastCanvas color: self aesthetics backgroundColor.

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> canvasLayout [
	^ RSTreeLayout new
		verticalGap: self aesthetics gapFromClassToSubclass;
		horizontalGap: self aesthetics gapFromSubclassToSibling;
		yourself
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> childrenToShowFor: node withClassName: aClassName [
	^ (node children
		select: [ :each | each value definition class name = aClassName ])
		sorted: [ :a :b | a value definition class name < b value definition class name ]
]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> classShapesFor: iceNodes [

	| renderer shapes |
	renderer := RiTorchUMLClassRenderer newWith: model.
	renderer highlighingController: lastHighlighingController.
	renderer modelDescriptor: (RiIceNodeUMLModelDescriptor new
		classname: [ :node | node value name ];
		classProperties: [ :node | self childrenToShowFor: node withClassName: #IcePropertyDefinition ];
		instVars: [ :node | self childrenToShowFor: node withClassName: #IceVariableDefinition ];
		methods: [ :node | self methodsToShowFor: node ];
		yourself).

	shapes := iceNodes collect: [ :each | renderer shapeFor: each ].

	self rootModel connectHierarchies ifTrue: [
		renderer edgeBuilder
			canvas: lastCanvas;
			shapes: shapes;
			connectFrom: [ :node |
				node value definition isExtensionDefinition
					ifTrue: [ nil ]
					ifFalse: [
						| superclassName |
						superclassName := node value definition asMCDefinition superclassName.
						iceNodes
							detect: [:each | each value definition name = superclassName ]
							ifNone: [ nil ] ] ] ].

	^ shapes

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> fileShapesFor: iceNodes [
	^ iceNodes collect: [ :each | 
			RSBox new
				noPaint;
				size: self aesthetics scaleForMethods * 2;
				model: each;
				border: self aesthetics tinyBoxBorder;
				addInteraction: (RSPopup text: [ :node | node path pathString ]);
				yourself ]
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

{ #category : #'canvas building' }
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
			model ifNotNil: [ self buildCanvas ] ];
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

{ #category : #'canvas building' }
RiTorchDiffPresenter >> packInteraction [
	"Interaction to pack hierarachies."

	| packer |
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: self aesthetics gapBetweenHierarchies.
	^ packer

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
	lastHighlighingController ifNil: [ ^ self ].
	lastHighlighingController highlightAsSelected: anIceNode.

]

{ #category : #'canvas building' }
RiTorchDiffPresenter >> zoomingInteraction [
	"Interaction for zooming."

	| controls |
	controls := RSCanvasController new.
	controls configuration
		useBasicZoom;
		maxScale: 1.
	^ controls

]
