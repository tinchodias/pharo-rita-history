Class {
	#name : #RiUMLClassBuilder,
	#superclass : #RSUMLClassBuilder,
	#instVars : [
		'environment',
		'packageColoring',
		'packageColorScale'
	],
	#category : #'Rita-IceTip-UMLBuilder'
}

{ #category : #examples }
RiUMLClassBuilder class >> exampleHiedra [
	(self forRepositoryNamed: 'Hiedra')
		build;
		open
]

{ #category : #examples }
RiUMLClassBuilder class >> exampleHiedraHorizontal [
	(self forRepositoryNamed: 'Hiedra')
		setLayoutHorizontalWithMarkers: false;
		build;
		open
]

{ #category : #examples }
RiUMLClassBuilder class >> exampleHiedraTorchLike [
	(self forRepositoryNamed: 'Hiedra')
		setLayoutVerticalWithMarkers: false;
		disableSelectors;
		build;
		open
]

{ #category : #examples }
RiUMLClassBuilder class >> exampleRoassal3 [
	(self forRepositoryNamed: 'Roassal3')
		disableSelectors;
		build;
		open
]

{ #category : #convenience }
RiUMLClassBuilder class >> forRepositoryNamed: aString [
	| repo |
	repo := IceRepository registry detect: [ :each| each name = aString ].
	
	^ self new
		iceRepository: repo;
		yourself
]

{ #category : #private }
RiUMLClassBuilder >> addPackageOutlines [
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

{ #category : #settings }
RiUMLClassBuilder >> backgroundColor [
	^ self currentTheme backgroundColor
]

{ #category : #private }
RiUMLClassBuilder >> behaviorElementsToOutline [
	^ self view elements select: [:aRSElement | aRSElement model package isRingResolved ]
]

{ #category : #private }
RiUMLClassBuilder >> builderForClassName [
	| builderForName builderForStereotype theLayout |
	builderForName := self builderForLabel: #yourself widthScale: 1.
	builderForStereotype := self builderForStereotype.
	theLayout := RSVerticalLineLayout new gapSize: -1; center.

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
RiUMLClassBuilder >> builderForLabel: textBlock widthScale: widthScale [

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
RiUMLClassBuilder >> builderForMethodName [

	^ (self builderForLabel: #selector widthScale: self widthScaleForNarrowFontStyle)
		if: [:aRGMethod | aRGMethod isMetaSide ] then: [:s | s underline ];
		yourself

]

{ #category : #private }
RiUMLClassBuilder >> builderForSlotName [
	^ (self builderForLabel: #name widthScale: self widthScaleForNarrowFontStyle)
"		if: [:m | m isVariableDefinition and: [ m isClassVariable ] ] then: [ :s | s underline ];"
		if: [:m | m isVariableDefinition and: [ m isPoolVariable ] ] then: [ :s | s underline ];
		if: [:m | m isVariableDefinition and: [ m isClassInstanceVariable ] ] then: [ :s | s underline ];
		yourself

]

{ #category : #private }
RiUMLClassBuilder >> builderForStereotype [

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
RiUMLClassBuilder >> colorForPackage: aRGPackage [
	^ (self packageColorScale scale: aRGPackage name)
		mixed: 0.25
		with: self backgroundColor
]

{ #category : #settings }
RiUMLClassBuilder >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #options }
RiUMLClassBuilder >> disablePackageColoring [
	packageColoring := false
]

{ #category : #options }
RiUMLClassBuilder >> disableSelectors [
	| tmpRenderer |
	tmpRenderer := RSTorchUMLClassRenderer new.
	tmpRenderer classShape interactionDo: [ :i | i clear; inspectable ].
	tmpRenderer modelDescriptor: self renderer modelDescriptor.
	tmpRenderer methodShape: (RSShapeBuilder box 
		width: 10;
		height: [ :met | (met sourceCode lines size * 10) sqrt + 10 ] ";
		interactionDo: [:i | i popup multiline ]").

	#(classShape varShape varsShape methodsShape methodShape) do: [ :each |
		self renderer perform: (each asMutator) with: (tmpRenderer perform: each) ].

]

{ #category : #options }
RiUMLClassBuilder >> enablePackageColoring [
	packageColoring := true
]

{ #category : #options }
RiUMLClassBuilder >> enableSelectors [
	self renderer: RSBasicUMLClassRenderer new.

	self renderer classBoxShape
		noPaint;
		cornerRadius: 3;
		if: [ :each | each package isRingResolved not ]
			then: [:each | each border: (TSBorder new dashArray: #(5 5); color: self foregroundColor; yourself) ].

	self renderer classShape interactionDo: [ :i | i clear; inspectable ].
	self renderer 
		classBoxPadding: 5@5;
		classNameShape: self builderForClassName;
		methodShape: self builderForMethodName;
		varShape: self builderForSlotName.

]

{ #category : #convenience }
RiUMLClassBuilder >> environment: aRGEnvironment [

	| all resolved toDraw |
	environment := aRGEnvironment.
	environment clean.
	all := environment ask allClassesAndTraits.
	resolved := all select: [:each | each isRingResolved ].
	toDraw := resolved reject: [ :each | #(Object Metaclass Trait ClassTrait) includes: each name ].
	self classes: toDraw.

]

{ #category : #settings }
RiUMLClassBuilder >> foregroundColor [
	^ self currentTheme textColor
]

{ #category : #settings }
RiUMLClassBuilder >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.1
]

{ #category : #settings }
RiUMLClassBuilder >> gapFromClassToSubclass [
	^ 30
]

{ #category : #settings }
RiUMLClassBuilder >> gapFromSubclassToSibling [
	^ self gapFromClassToSubclass / 2
]

{ #category : #convenience }
RiUMLClassBuilder >> iceCommit: anIceCommit [
	"Import an environment from an commit: Iceberg + Ring2/Monticello"

	| aRGEnvironment |
	aRGEnvironment := RGEnvironment new.
	anIceCommit packages do: [ :each | 
	(IceSavedPackageVersion
		fromCommit: anIceCommit
		package: each) mcSnapshot
			importInto: aRGEnvironment
			asPackageNamed: each name ].
	self environment: aRGEnvironment.
]

{ #category : #convenience }
RiUMLClassBuilder >> iceRepository: anIceRepository [
	self iceCommit: anIceRepository head commit
]

{ #category : #initialization }
RiUMLClassBuilder >> initialize [
	super initialize.

	self setLayoutVerticalWithMarkers: true.
	self enableSelectors.
	self enablePackageColoring.

	self renderer marker shape color: self backgroundColor.
	self renderer marker shape size: self gapFromClassToSubclass / 3.
	self renderer marker offset: self gapFromClassToSubclass / 6.
	self renderer border color: self foregroundColor.

	"TODO: sorted:[ :a :b | a selector < b selector ]"
	self modelDescriptor
		instVars: [ :cls | 
			cls sharedPools, (cls isTrait
				ifTrue: [ #() ]
				ifFalse: [ cls classVariables, cls theMetaClass slots, cls slots ]) ];
		methods: [ :cls | cls theMetaClass methods, cls methods ]

]

{ #category : #settings }
RiUMLClassBuilder >> maxClassWidth [
	^ 400
]

{ #category : #settings }
RiUMLClassBuilder >> outlineSize [
	^ self gapFromSubclassToSibling / 2
]

{ #category : #settings }
RiUMLClassBuilder >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale google20 ]
]

{ #category : #hooks }
RiUMLClassBuilder >> renderIn: aView [
	| interaction |
	super renderIn: aView.

	aView color: self backgroundColor.

	interaction := RSHierarchyPacker new.
	interaction rectanglePackLayout gap: self gapBetweenHierarchies.
	aView addInteraction: interaction.

	packageColoring ifTrue: [ self addPackageOutlines ].

]

{ #category : #options }
RiUMLClassBuilder >> setLayoutHorizontalWithMarkers: useMarkers [
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
RiUMLClassBuilder >> setLayoutVerticalWithMarkers: useMarkers [
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
RiUMLClassBuilder >> stereotypeColor [
	^ self currentTheme caretColor
]

{ #category : #private }
RiUMLClassBuilder >> stereotypeFor: aBehavior ifPresent: aBlock [
	aBehavior isTrait
		ifTrue: [ ^ aBlock cull: 'trait' ].
	(aBehavior methods isNotEmpty
		and: [ aBehavior methods anyOne isExtension ])
		ifTrue: [ ^ aBlock cull: 'extension' ]
]

{ #category : #hooks }
RiUMLClassBuilder >> view [
	^ container ifNil: [
		| controlsView |
		container := RSView new.

		controlsView := RSControlsView new.
		controlsView configuration
			useBasicZoom;
			maxScale: 1.
		container addInteraction: controlsView.

		container ]
]

{ #category : #settings }
RiUMLClassBuilder >> widthScaleForNarrowFontStyle [
	^ 0.8
]
