Class {
	#name : #HiMNavigator,
	#superclass : #Object,
	#instVars : [
		'layout',
		'view',
		'commandHistory',
		'labelStrategy',
		'topLevelNodes',
		'forceAnimation',
		'colorScale'
	],
	#category : #'Rita-Navigator-UI'
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

	| view |
	TSLine delta: 1.	"Note: global effect!"

	HiMPackageDependenciesExample new
		navigator: aHiMNavigator;
		packageNames: {'Hiedra'. 'Hiedra-Tests'. 'Hiedra-Roassal3'. "'Random-Core'"". 'Athens-Cairo'. 'Growl'. 'Iceberg'"};
		build.

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
	someRSElements do: [ :toElement |
		| fromModels |
		fromModels := toElement model allIncomingNodes flatCollect: #withAllParents.
		fromModels do: [ :fromModel |
			"If it is present..."
			(view elementFromModel: fromModel) ifNotNil: [ :fromElement |
				"If it is not already there..."
				(fromElement isDirectlyConnectedTo: toElement) ifFalse: [
					"Add it"
					edges add: (edgeBuilder edgeFrom: fromElement to: toElement).
		] ] ] ].

	layout addEdges: edges.
	edges do: [ :anEdge |
		(layout mockEdgeAt: anEdge) length: (self edgeLengthFor: anEdge) ].
	
	edges do: #pushBack.

]

{ #category : #visualization }
HiMNavigator >> addElementsFor: someHiMNodes [

	| shapeBuilder elements |
	shapeBuilder := RSShapeBuilder composite
		interactionDo: [ :interactionBuilder | 
			interactionBuilder 
				popupText: #object; 
				addInteraction: (RSDraggableForce new layout: layout; yourself);
				addInteraction: self highlightableForShapes ];
		color: [ :each | self colorFor: each ];
		size: [ :each | self sizeFor: each ];
		onElement;
		when: TSMouseDragStart do: [:each | [:evt | self startForceAnimationInfinitely ]];
		when: TSMouseDragEnd do: [:each | [:evt | self startForceAnimationFinitely ]];
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
HiMNavigator >> addNestedEdgesFor: someRSElements [

	| edgeBuilder |
	edgeBuilder := RSEdgeBuilder line
		view: view;
		color: (self currentTheme caretColor alpha: 0.15);
		width: 0.5;
		interactionDo: [ :interactionBuilder |
			interactionBuilder
				popupText: [:model | model key model object asString, '->', model value model object asString ] ];
		yourself.

	"Dependencies"
	someRSElements do: [ :toElement |
		| fromModels |
		fromModels := toElement model incomingNodes.
		fromModels do: [ :fromModel |
			"If it is present..."
			((view elementFromModel: fromModel topParent) ifNotNil: [ :topLevelElement |
				topLevelElement elementFromModel: fromModel ])
					ifNotNil: [ :fromElement |
					"If it is not already there..."
					(fromElement isDirectlyConnectedTo: toElement) ifFalse: [
						"Add it"
						edgeBuilder edgeFrom: fromElement to: toElement.
			] ] ] ].

]

{ #category : #accessing }
HiMNavigator >> build [
	self addElementsFor: topLevelNodes.
	self startForceAnimationFinitely.
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> collapse: aRSElement [ 
	| endSize |
	endSize := self sizeFor: aRSElement model.

	self startForceAnimationFinitely.

	aRSElement newAnimation
		duration: self expandDuration;
		from: 1@1;
		to: endSize/aRSElement extent;
		onStepDo: [ :t | self expand: aRSElement step: t ];
		when: TSAnimationEndEvent do: [ | position |
			aRSElement children copy do: [ :each |
				each connectedEdges copy do: #remove.
				each remove ].
			position := aRSElement position.
			aRSElement matrix
				loadIdentity;
				translation: position.
			aRSElement size: endSize ].

	self mark: aRSElement asExpanded: false.
]

{ #category : #visualization }
HiMNavigator >> colorFor: aHiMNode [
	^ self colorScale scale: aHiMNode topParent
]

{ #category : #accessing }
HiMNavigator >> colorScale [
	^ colorScale ifNil: [ colorScale := TSScale category20 ]
]

{ #category : #accessing }
HiMNavigator >> colorScale: aColorScale [
	colorScale := aColorScale.
]

{ #category : #accessing }
HiMNavigator >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #visualization }
HiMNavigator >> edgeLengthFor: anEdge [
	^ (anEdge from encompassingRectangle halfPerimeter
		+ anEdge to encompassingRectangle halfPerimeter) / 2
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
	| nestedElements |
	nestedElements := self newNestedElementsForAll: aRSElement model children.

	RSRectanglePackLayout new
		gap: 0.09;
		preferredAngle: (25@10) angle;
		on: nestedElements.
		
	aRSElement
		shapes: nestedElements;
		padding: 1;
		pushFront.
	
	self addNestedEdgesFor: nestedElements.

	self startForceAnimationFinitely.

	aRSElement newAnimation
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
		layout edges
			detect: [ :each | each realEdge == anEdge ]
			ifFound: [ :mockEdge |
				mockEdge length: (self edgeLengthFor: anEdge) ]
		 ]
]

{ #category : #'expanding-collapsing' }
HiMNavigator >> expandDuration [
	^ 150 milliSeconds
]

{ #category : #animations }
HiMNavigator >> forceAlphaRangeAsArray [
	^ #(0 0.1)
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

	view := aRSView.
	view color: self currentTheme backgroundColor.

	layout := RSRectangleForceLayout new
		start;
		charge: -60;
		friction: 0.25;
		gravity: 0.1;
		enclosingForce: 1;
		enclosingThreshold: 20;
		yourself.

	"Apply forces from the window borders to the elements."
	view
		when: TSExtentChangedEvent
		do: [ :evt | 
			| camera origin corner |
			camera := view canvas camera.
			origin := camera fromPixelToSpace: 0 @ 0.
			corner := camera fromPixelToSpace: view canvas extent.
			layout enclosingRectangle: (origin corner: corner).
			self startForceAnimationFinitely ].
	
	view
		when: TSKeyDown
		do: [ :evt | self processKeyDown: evt ].
		
"	view addInteraction: RSActivityMonitorView."
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

{ #category : #visualization }
HiMNavigator >> newNestedElementsForAll: someHiMNodes [

	| builder renderer color |
	builder := RSUMLClassBuilder new.
	renderer := builder renderer.
	color := self currentTheme textColor.
	renderer defaultBorder color: color.
	renderer methodShape color: color.
	renderer classNameShape color: color.
		
	builder classDescriptor
		classname: #object;
		instVars: #();
		methods: [ :aHiMNode |


			"TODO: refactor!"
			| limit methods |
			limit := 5.
			methods := aHiMNode children collect: [:each | each object value ].
			methods size < limit ifFalse: [
				methods := (methods first: limit) copyWith: '...' ].
			methods

			
			];
		methodSelector: #asString.
	builder shape: (RSShapeBuilder composite 
		interactionDo: [ :i | i popupText: #object];
		shapes: [ :m | builder createShapesFor: m ]).
	builder shape scaleBy: 0.08.
	builder renderer classBoxShape
		color: [ :node | self currentTheme backgroundColor alpha: 0.9 ];
		cornerRadius: 3.

	^ builder shape elementsOn: someHiMNodes
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
	^ (10 * (aHiMNode children size + 1)) sqrt
]

{ #category : #animations }
HiMNavigator >> startForceAnimationFinitely [
	
	self stopForceAnimation.

	forceAnimation := view newAnimation
		easing: TSEasing cubicInOut;
		range: self forceAlphaRangeAsArray reversed;
		duration: 2 seconds;
		onStepDo: [ :t | layout alpha: t; step ];
		yourself
]

{ #category : #animations }
HiMNavigator >> startForceAnimationInfinitely [
	
	self stopForceAnimation.
	
	"Composed animation"
	forceAnimation :=  view animationFrom: {

		"Start smoothly"
		view tAnimation
			easing: TSEasing cubicOut;
			duration: 500 milliSeconds;
			range: self forceAlphaRangeAsArray;
			onStepDo: [ :t | layout alpha: t; step ].

		"Continue on max alpha undefinitely"
		view tAnimation
			repeat;
			onStepDo: [ :t | layout step ] }.

]

{ #category : #animations }
HiMNavigator >> stopForceAnimation [
	forceAnimation ifNotNil: #stop
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
