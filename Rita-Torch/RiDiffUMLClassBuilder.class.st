Class {
	#name : #RiDiffUMLClassBuilder,
	#superclass : #RSUMLClassBuilder,
	#instVars : [
		'packageColoring',
		'packageColorScale'
	],
	#category : #'Rita-Torch-Diff'
}

{ #category : #convenience }
RiDiffUMLClassBuilder class >> forView: aRSView [
	^ self basicNew
		initializeWith: aRSView;
		yourself
]

{ #category : #convenience }
RiDiffUMLClassBuilder class >> new [ 
	^ self forView: nil
]

{ #category : #private }
RiDiffUMLClassBuilder >> addPackInteraction [
	"Interaction to pack hierarachies."

	| packer |
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: self gapBetweenHierarchies.
	self view addInteraction: packer.

]

{ #category : #private }
RiDiffUMLClassBuilder >> addPackageOutlines [
	| packageShapeBuilder packageElements |
	packageShapeBuilder := RSShapeBuilder box
		border: [:behaviorElement |
			TSBorder new 
				joinMiter;
				color: (self colorForPackage: behaviorElement model package);
				width: self outlineSize ];
		noPaint;
		extent: [ :behaviorElement | behaviorElement extent + self outlineSize ];
		onMyselfDo: [:behaviorElement | [ :me |
			behaviorElement
				when: TSPositionChangedEvent
				do: [ me position: behaviorElement position ] ] ].

	packageElements := packageShapeBuilder elementsOn: self behaviorElementsToOutline.
	self view addAll: packageElements.
	packageElements pushBack.

]

{ #category : #private }
RiDiffUMLClassBuilder >> addZoomingInteraction [
	"Interaction for zooming."

	| controls |
	controls := RSControlsView new.
	controls configuration
		useBasicZoom;
		maxScale: 1.
	self view addInteraction: controls.

]

{ #category : #settings }
RiDiffUMLClassBuilder >> backgroundColor [
	^ self currentTheme backgroundColor
]

{ #category : #settings }
RiDiffUMLClassBuilder >> backgroundColorFor: node [
	^ node value ritaColor
		alphaMixed: 0.25
		with: self backgroundColor
]

{ #category : #private }
RiDiffUMLClassBuilder >> behaviorElementsToOutline [
	^ self view elements
		reject:
			[ :aRSElement | aRSElement model value definition isExtensionDefinition ]
]

{ #category : #private }
RiDiffUMLClassBuilder >> builderForClassName [
	| builderForName builderForStereotype theLayout |
	builderForName := self builderForLabel: [:node | node value definition name ] widthScale: "WAS: 1" 0.9.
	
	builderForStereotype := self builderForStereotype.
	theLayout := RSVerticalLineLayout new gapSize: -1; center; yourself.

	^ RSShapeBuilder composite shapes: [ :aBehavior | 
		| group |
		group := TSGroup new.
		self
			stereotypeFor: aBehavior
			ifPresent: [:stereotype |
				group add: (builderForStereotype elementOn: stereotype) ].

		group add: (builderForName elementOn: aBehavior).
		theLayout on: group.
		group ].
]

{ #category : #private }
RiDiffUMLClassBuilder >> builderForLabel: textBlock widthScale: widthScale [

	^ RSShapeBuilder label
		color: self foregroundColor;
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: (textBlock cull: e model) asString
			font: e font
			maxSize: self maxClassWidth * (1/widthScale)  ];
		scaleBy: widthScale@1;
		onModel;
		yourself

]

{ #category : #private }
RiDiffUMLClassBuilder >> builderForMethodName [

	^ (self builderForLabel: [:node | node value definition selector ] widthScale: self widthScaleForNarrowFontStyle)
		if: [:node | node value definition classIsMeta ] then: [:s | s underline ];
		yourself

]

{ #category : #private }
RiDiffUMLClassBuilder >> builderForSlotName [
	^ (self builderForLabel:[:node | node value definition name ] widthScale: self widthScaleForNarrowFontStyle)
"		if: [:m | m isVariableDefinition and: [ m isClassVariable ] ] then: [ :s | s underline ];"
"		if: [:m | m isVariableDefinition and: [ m isPoolVariable ] ] then: [ :s | s underline ];
		if: [:m | m isVariableDefinition and: [ m isClassInstanceVariable ] ] then: [ :s | s underline ];"
		yourself

]

{ #category : #private }
RiDiffUMLClassBuilder >> builderForStereotype [

	| widthScale |
	widthScale := self widthScaleForNarrowFontStyle.
	
	^ RSShapeBuilder label
		color: self stereotypeColor;
		italic;
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: '« ', e model, ' »'
			font: e font
			maxSize: self maxClassWidth * (1/widthScale) ];
		scaleBy: widthScale;
		onModel;
		yourself
]

{ #category : #private }
RiDiffUMLClassBuilder >> colorForPackage: aRGPackage [
	^ (self packageColorScale scale: aRGPackage name)
		mixed: 0.25
		with: self backgroundColor
]

{ #category : #settings }
RiDiffUMLClassBuilder >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #options }
RiDiffUMLClassBuilder >> disablePackageColoring [
	packageColoring := false
]

{ #category : #options }
RiDiffUMLClassBuilder >> disableSelectors [

	| tmpRenderer |
	tmpRenderer := RSTorchUMLClassRenderer new.
	tmpRenderer modelDescriptor: self renderer modelDescriptor.

	tmpRenderer classNameShape color: [ :node | self backgroundColorFor: node ].
	tmpRenderer classShape interactionDo: [ :i | i clear; inspectable ].

	tmpRenderer methodShape: (RSShapeBuilder box 
		color: [ :node | self foregroundColorFor: node ];
		width: self scaleForMethods;
		height: [ :node | 2 + (node value ritaChangeSize * self scaleForMethods) ];
		interactionDo: [:i | i popup multiline ]).

	tmpRenderer varShape: (RSShapeBuilder triangle
		size: self scaleForMethods * 1.3; 
		color: [ :node | self foregroundColorFor: node ];
		yourself).
	tmpRenderer varsShape padding: (self scaleForMethods / 2) asMargin.

	#(classShape varShape varsShape methodsShape methodShape) do: [ :each |
		self renderer
			perform: each asMutator
			with: (tmpRenderer perform: each) ].

]

{ #category : #options }
RiDiffUMLClassBuilder >> enablePackageColoring [
	packageColoring := true
]

{ #category : #options }
RiDiffUMLClassBuilder >> enableSelectors [
	self renderer: RSBasicUMLClassRenderer new.

	self renderer classBoxShape
		noPaint;
		cornerRadius: 3;
		border: [ :node | TSBorder new color: (self foregroundColorFor: node); yourself ].

"	self renderer classShape interactionDo: [ :i | i clear; inspectable ]."
	self renderer 
		classBoxPadding: 5@5;
		classNameShape: self builderForClassName;
		methodShape: self builderForMethodName;
		varShape: self builderForSlotName.

]

{ #category : #settings }
RiDiffUMLClassBuilder >> foregroundColor [
	^ self currentTheme textColor
]

{ #category : #settings }
RiDiffUMLClassBuilder >> foregroundColorFor: node [
	^ node value ritaColor
		mixed: 0.8
		with: self foregroundColor
]

{ #category : #settings }
RiDiffUMLClassBuilder >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.3
]

{ #category : #settings }
RiDiffUMLClassBuilder >> gapBetweenMethods [
	^ 5
]

{ #category : #settings }
RiDiffUMLClassBuilder >> gapFromClassToSubclass [
	^ 30
]

{ #category : #settings }
RiDiffUMLClassBuilder >> gapFromSubclassToSibling [
	^ self gapFromClassToSubclass / 2
]

{ #category : #initialization }
RiDiffUMLClassBuilder >> initialize [
	super initialize.

	self modelDescriptor
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

	self setLayoutVerticalWithMarkers: true.
	self enableSelectors.
	self disablePackageColoring.

	self renderer marker shape color: self backgroundColor.
	self renderer marker shape size: self gapFromClassToSubclass / 3.
	self renderer marker offset: self gapFromClassToSubclass / 6.
	self renderer border color: self foregroundColor.


]

{ #category : #initialization }
RiDiffUMLClassBuilder >> initializeWith: aView [
	container := aView.

	self initialize.

]

{ #category : #settings }
RiDiffUMLClassBuilder >> maxClassWidth [
	^ 200
]

{ #category : #private }
RiDiffUMLClassBuilder >> methodsToShowFor: iceNodeWithBehavior [
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

{ #category : #settings }
RiDiffUMLClassBuilder >> outlineSize [
	^ self gapFromSubclassToSibling / 2
]

{ #category : #settings }
RiDiffUMLClassBuilder >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale google20 ]
]

{ #category : #settings }
RiDiffUMLClassBuilder >> packageColorScale: aTSScale [
	packageColorScale := aTSScale

]

{ #category : #hooks }
RiDiffUMLClassBuilder >> renderIn: aView [
	super renderIn: aView.

"	self addZoomingInteraction."
	self addPackInteraction.

	aView color: self backgroundColor.

	packageColoring ifTrue: [ self addPackageOutlines ].

]

{ #category : #settings }
RiDiffUMLClassBuilder >> scaleForMethods [
	^ 8
]

{ #category : #options }
RiDiffUMLClassBuilder >> setLayoutHorizontalWithMarkers: useMarkers [
	| hierarchyEdgeBuilder |
	hierarchyEdgeBuilder := RSEdgeBuilder orthoHorizontal
		attachPoint: RSHorizontalAttachPoint new;
		border: self renderer border;
		yourself.

	useMarkers ifTrue: [
		hierarchyEdgeBuilder markerStart: self renderer marker ].
				
	self renderer edgeBuilder: hierarchyEdgeBuilder.

	self layout horizontalTree
		horizontalGap: self gapFromClassToSubclass;
		verticalGap: self gapFromSubclassToSibling.
]

{ #category : #options }
RiDiffUMLClassBuilder >> setLayoutVerticalWithMarkers: useMarkers [
	| hierarchyEdgeBuilder |
	hierarchyEdgeBuilder := RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: self renderer border;
		yourself.

	useMarkers ifTrue: [
		hierarchyEdgeBuilder markerStart: self renderer marker ].
				
	self renderer edgeBuilder: hierarchyEdgeBuilder.

	self layout tree
		verticalGap: self gapFromClassToSubclass;
		horizontalGap: self gapFromSubclassToSibling.

]

{ #category : #settings }
RiDiffUMLClassBuilder >> stereotypeColor [
	^ self currentTheme caretColor
]

{ #category : #private }
RiDiffUMLClassBuilder >> stereotypeFor: aBehavior ifPresent: aBlock [
	aBehavior isTrait
		ifTrue: [ ^ aBlock cull: 'trait' ].
	(aBehavior isRingResolved not and: [aBehavior hasMethodExtensions])
		ifTrue: [ ^ aBlock cull: 'extension' ]
]

{ #category : #settings }
RiDiffUMLClassBuilder >> widthScaleForNarrowFontStyle [
	^ 0.8
]
