Class {
	#name : #HiMNavigator,
	#superclass : #Object,
	#instVars : [
		'colors',
		'layout',
		'view',
		'commandHistory',
		'labelStrategy',
		'topLevelNodes'
	],
	#category : #'Rita-Navigator'
}

{ #category : #examples }
HiMNavigator class >> exampleFloatingLabels [

	^ self openExampleWith: self new
]

{ #category : #examples }
HiMNavigator class >> exampleTopLabels [

	^ self openExampleWith: (self new labelStrategy: HiMTopLabelStrategy new; yourself)
]

{ #category : #examples }
HiMNavigator class >> new [
	^ self newOn: RSView new
]

{ #category : #examples }
HiMNavigator class >> newOn: aRSView [
	^ self basicNew
		initializeOn: aRSView;
		yourself
]

{ #category : #examples }
HiMNavigator class >> openExampleWith: aHiMNavigator [

	| nodes view |
	TSLine delta: 1.	"Note: global effect!"

	nodes := HiMPackageDependenciesExample new
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. 'Random-Core'". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build;
		topLevelNodes.

	aHiMNavigator topLevelNodes: nodes; build.

	view := aHiMNavigator view.
	view camera scale: 6.
	view open.

]

{ #category : #visualization }
HiMNavigator >> addEdgesFor: someRSElements [

	| edgeBuilder edges |
	edgeBuilder := RSEdgeBuilder line
		view: view;
		color: (self currentTheme caretColor alpha: 0.25);
		interactionDo: [ :interactionBuilder |
			interactionBuilder
				popupText: [:model | model key model object asString, '->', model value model object asString ];
				addInteraction: self highlightableForEdges ];
		onElement;
		when: TSMouseDoubleClick do: [ :each | [:evt | self toggleEdge: each ] ];
		yourself.

	"Dependencies"
	edges := OrderedCollection new.
	someRSElements do: [ :targetElement |
		| sourceNodes |
		sourceNodes := targetElement model allIncomingNodes flatCollect: #withAllParents.
		sourceNodes do: [ :incomingModel |
			"If it is present..."
			(view elementFromModel: incomingModel) ifNotNil: [ :incomingElement |
				"If it is not already there..."
				(incomingElement isDirectlyConnectedTo: targetElement) ifFalse: [
					"Add it"
					edges add: (edgeBuilder edgeFrom: incomingElement to: targetElement).
		] ] ] ].

	layout addEdges: edges.
	edges do: #pushBack.

]

{ #category : #visualization }
HiMNavigator >> addElementsFor: someHiMNodes [

	| shapeBuilder elements |
	shapeBuilder := RSShapeBuilder composite
		interactionDo: [ :interactionBuilder | 
			interactionBuilder 
				draggable; 
				popupText: #object; 
				addInteraction: self highlightableForShapes ];
		color: [ :each | self colorFor: each ];
		size: [ :each | self sizeFor: each ];
		onElement;
		when: TSMouseDragging do: [ :each | [:evt | 
			layout fix: each at: evt position - (each extent / 2) ]];
		when: TSMouseDragEnd do: [:each | [:evt |
			layout removeFix: each ]];
		when: TSMouseDoubleClick do: [ :each | [:evt | self toggleNode: each ] ];
		yourself.
		
	labelStrategy applyBeforeCreatingElementsWith: shapeBuilder.
	
	elements := shapeBuilder elementsOn: someHiMNodes.

	view addAll: elements.
	layout addNodes: elements.
	
	self addEdgesFor: elements.
	
	labelStrategy applyAfterAddingElements: elements.
]

{ #category : #visualization }
HiMNavigator >> addNestedElementsFor: aRSElement [

	| elements builder |
	builder := RSUMLClassBuilder new.
	builder classDescriptor
		classname: #object;
		instVars: #();
		methods: #children;
		methodSelector: #object.
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i popupText: #object];
		shapes: [ :m | builder createShapesFor: m ]).
	builder shape scaleBy: 0.08.
	builder renderer classBoxShape
		color: [ :node | (self currentTheme backgroundColor) alpha: 0.8 ].
	builder renderer classBoxShape cornerRadius: 3.

	elements := builder shape elementsOn: aRSElement model children.

	RSRectanglePackLayout on: elements. 

	aRSElement addAll: elements.

]

{ #category : #accessing }
HiMNavigator >> build [
	self addElementsFor: topLevelNodes.

]

{ #category : #'expanding-collapsing' }
HiMNavigator >> collapse: aRSElement [ 
	| endSize |
	endSize := self sizeFor: aRSElement model.
	aRSElement animation
		duration: self expandDuration;
		from: 1@1;
		to: endSize/aRSElement extent;
		onStepDo: [ :t | self expand: aRSElement step: t ];
		when: TSAnimationEndEvent do: [ | position |
			aRSElement shapes copy do: #remove.
			position := aRSElement position.
			aRSElement matrix
				loadIdentity;
				translation: position.
			aRSElement size: endSize.
			
		aRSElement connectedEdges do: [ :anEdge |
			layout removeLengthAt: anEdge ] ].

	self mark: aRSElement asExpanded: false.
]

{ #category : #visualization }
HiMNavigator >> colorFor: aHiMNode [
	^ colors scale: aHiMNode topParent
]

{ #category : #accessing }
HiMNavigator >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #commands }
HiMNavigator >> executeAndRegisterCollapseIfPossible: aRSElement [
	| aCommand |
	(self isMarkedAsExpanded: aRSElement) ifFalse: [ ^self ].

	aCommand := HiMCollapse new
		navigator: self;
		node: aRSElement;
		yourself.
	commandHistory executeAndRegister: aCommand.
]

{ #category : #commands }
HiMNavigator >> executeAndRegisterExpandIfPossible: aRSElement [
	| aCommand |
	(self isMarkedAsExpanded: aRSElement) ifTrue: [ ^self ].

	aCommand := HiMExpand new
		navigator: self;
		node: aRSElement;
		yourself.
	commandHistory executeAndRegister: aCommand.
]

{ #category : #commands }
HiMNavigator >> executeRedoIfPossible [
	commandHistory canRedo ifTrue: [ commandHistory redo ]
]

{ #category : #commands }
HiMNavigator >> executeUndoIfPossible [
	commandHistory canUndo ifTrue: [ commandHistory undo ]
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> expand: aRSElement [
	| initialPosition |
	initialPosition := aRSElement position.
	self addNestedElementsFor: aRSElement.
	aRSElement adjustToChildren.
	aRSElement translateTo: initialPosition.
	aRSElement padding: 1.
	aRSElement animation
		duration: self expandDuration;
		from: (self sizeFor: aRSElement model) / aRSElement extent;
		to: 1@1;
		onStepDo: [ :t | self expand: aRSElement step: t ].

	self mark: aRSElement asExpanded: true.
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> expand: aRSElement step: t [
	
	| position |
	position := aRSElement position.
	aRSElement matrix
		loadIdentity;
		translation: position;
		scaleBy: t.
	aRSElement resetBBox.
	aRSElement connectedEdges do: [ :anEdge |
		| newLength |
		newLength := (anEdge from width max: anEdge from height) + (anEdge to width max: anEdge to height).
		layout set: anEdge length: newLength ]
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> expandDuration [
	^ 150 milliSeconds
]

{ #category : #visualization }
HiMNavigator >> highlightableForEdges [
	| aHighlightable |
	aHighlightable := RSHighlightable new.
	aHighlightable highlightShape
		color: self currentTheme caretColor.
	^ aHighlightable 
]

{ #category : #visualization }
HiMNavigator >> highlightableForShapes [
	| aHighlightable |
	aHighlightable := RSHighlightable new.
	aHighlightable highlightShape
		onElement;
		color: [ :e | e color adjustBrightness: 0.16 ];
		border: [ :e | 
			TSBorder new
				color: self currentTheme textColor;
				width: 0.1 ].
	^ aHighlightable
]

{ #category : #initialization }
HiMNavigator >> initializeOn: aRSView [
	self initialize.
	
	commandHistory := HiMCommandHistory new.
	self labelStrategy: HiMFloatingLabelStrategy new.

	
	colors := TSScale category20.
	view := aRSView.
	view color: self currentTheme backgroundColor.

	layout := RSRectangleForceLayout new
		start: #();
		friction: 0.25;
"		charge: -20;
		strength: 0.3;
		gravity: 0.05;"
		enclosingForce: 0.1;
		enclosingThreshold: 20;
		yourself.
	view animation repeat onStepDo: [ :t | layout step ].

	"Apply forces from the window borders to the elements."
	view
		when: TSExtentChangedEvent
		do: [ :evt | 
			| camera origin corner |
			camera := view canvas camera.
			origin := camera fromPixelToSpace: 0 @ 0.
			corner := camera fromPixelToSpace: view canvas extent.
			layout enclosingRectangle: (origin corner: corner) ].
	
	view
		when: TSKeyDown
		do: [ :evt | self processKeyDown: evt ].
		
	view addInteraction: RSActivityMonitorView.
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> isMarkedAsExpanded: aRSElement [
	^ aRSElement attributeAt: #expanded ifAbsentPut: [ false ]
]

{ #category : #accessing }
HiMNavigator >> labelStrategy [
	^ labelStrategy
]

{ #category : #accessing }
HiMNavigator >> labelStrategy: aHiMLabelStrategy [
	labelStrategy := aHiMLabelStrategy.
	aHiMLabelStrategy navigator: self.
]

{ #category : #accessing }
HiMNavigator >> layout [
	^ layout
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> mark: aRSElement asExpanded: aBoolean [
	^ aRSElement attributeAt: #expanded put: aBoolean
]

{ #category : #commands }
HiMNavigator >> processKeyDown: evt [

	($z meta matchesCompletely: evt keyCombination) ifTrue: [ 
		^ self executeUndoIfPossible ].

	($z shift meta matchesCompletely: evt keyCombination) ifTrue: [ 
		^ self executeRedoIfPossible ].

]

{ #category : #visualization }
HiMNavigator >> sizeFor: aHiMNode [
	^ (8 * (aHiMNode children size + 1)) sqrt
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> toggleEdge: aRSEdge [
	| isFromExpanded isToExpanded |
	isFromExpanded := self isMarkedAsExpanded: aRSEdge from.
	isToExpanded := self isMarkedAsExpanded: aRSEdge to.
	
	isFromExpanded & isToExpanded
		ifTrue: [
			self
				executeAndRegisterCollapseIfPossible: aRSEdge from;
				executeAndRegisterCollapseIfPossible: aRSEdge to ]
		ifFalse: [ 
			self
				executeAndRegisterExpandIfPossible: aRSEdge from;
				executeAndRegisterExpandIfPossible: aRSEdge to ]
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> toggleNode: aRSElement [
	(self isMarkedAsExpanded: aRSElement)
		ifTrue: [ self executeAndRegisterCollapseIfPossible: aRSElement ]
		ifFalse: [ self executeAndRegisterExpandIfPossible: aRSElement ]
]

{ #category : #accessing }
HiMNavigator >> topLevelNodes: someHiMNodes [
	topLevelNodes := someHiMNodes.

]

{ #category : #accessing }
HiMNavigator >> view [
	^ view
]
