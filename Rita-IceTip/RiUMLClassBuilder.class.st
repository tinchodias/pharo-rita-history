Class {
	#name : #RiUMLClassBuilder,
	#superclass : #RSUMLClassBuilder,
	#instVars : [
		'environment',
		'packageColoring',
		'packageColorScale',
		'extensions',
		'mustGroupExtensions',
		'limitForMethodCount'
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

{ #category : #examples }
RiUMLClassBuilder class >> exampleRoassal3Horizontal [
	(self forRepositoryNamed: 'Roassal3')
		disableSelectors;
		setLayoutHorizontalWithMarkers: false;		
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

{ #category : #convenience }
RiUMLClassBuilder class >> forView: aRSView [
	^ self basicNew
		initializeWith: aRSView;
		yourself
]

{ #category : #convenience }
RiUMLClassBuilder class >> new [ 
	^ self forView: nil
]

{ #category : #private }
RiUMLClassBuilder >> addPackInteraction [
	"Interaction to pack hierarachies."

	| packer |
	self mustGroupExtensions ifTrue: [ self groupExtensions ].
	
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: self gapBetweenHierarchies.
	self view addInteraction: packer.

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

{ #category : #private }
RiUMLClassBuilder >> addZoomingInteraction [
	"Interaction for zooming."

	| controls |
	controls := RSControlsView new.
	controls configuration
		useBasicZoom;
		maxScale: 1.
	self view addInteraction: controls.

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
		width: self scaleForMethods;
		height: [ :met | self scaleForMethods + (met sourceCode lines size * self scaleForMethods) sqrt ] ";
		interactionDo: [:i | i popup multiline ]").
	tmpRenderer varShape: (RSShapeBuilder triangle size: self scaleForMethods * 1.3; yourself).
	tmpRenderer varsShape padding: (self scaleForMethods / 2) asMargin.

	#(classShape varShape varsShape methodsShape methodShape) do: [ :each |
		self renderer
			perform: each asMutator
			with: (tmpRenderer perform: each) ].

	self limitForMethodCount: SmallInteger maxVal.
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

	self limitForMethodCount: 20.
]

{ #category : #convenience }
RiUMLClassBuilder >> environment: aRGEnvironment [

	| all resolved toDraw |
	environment := aRGEnvironment.
	environment clean.
	all := environment ask allClassesAndTraits.
	resolved := all select: [:each | each isRingResolved ].
	toDraw := resolved reject: [ :each |
		#(Object Metaclass Trait ClassTrait) includes: each name ].
	extensions := toDraw select: [ :each |
		each hasMethodExtensions or: [ each theMetaClass hasMethodExtensions ] ].
	
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

{ #category : #private }
RiUMLClassBuilder >> groupExtensions [

	| fakeEdgeBuilder extensionElements |
	extensionElements := self view elementsFromModels: extensions.
	fakeEdgeBuilder := RSEdgeBuilder line border: nil.
	fakeEdgeBuilder linkElements: extensionElements.
	
	RSGridLayout on: extensionElements.

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

	"TODO: sorted:[ :a :b | a selector < b selector ]?"
	self modelDescriptor
		instVars: [ :cls | 
			cls sharedPools, (cls isTrait
				ifTrue: [ #() ]
				ifFalse: [ cls classVariables, cls theMetaClass slots, cls slots ]) ];
		methods: [ :cls | self methodsToShowFor: cls ].


	self setLayoutVerticalWithMarkers: true.
	self enableSelectors.
	self enablePackageColoring.

	self renderer marker shape color: self backgroundColor.
	self renderer marker shape size: self gapFromClassToSubclass / 3.
	self renderer marker offset: self gapFromClassToSubclass / 6.
	self renderer border color: self foregroundColor.


]

{ #category : #initialization }
RiUMLClassBuilder >> initializeWith: aView [
	container := aView.

	self initialize.

]

{ #category : #settings }
RiUMLClassBuilder >> limitForMethodCount [
	^ limitForMethodCount ifNil: [ ^ SmallInteger maxVal ]
]

{ #category : #settings }
RiUMLClassBuilder >> limitForMethodCount: anInteger [
	limitForMethodCount := anInteger
]

{ #category : #settings }
RiUMLClassBuilder >> maxClassWidth [
	^ 200
]

{ #category : #private }
RiUMLClassBuilder >> methodsToShowFor: aBehavior [

	| limit methods mockAbbrMethod |
	limit := self limitForMethodCount.
	methods := aBehavior theMetaClass methods, aBehavior methods.
	methods size < limit ifFalse: [
		self flag: #todo.
		mockAbbrMethod := RGMethod named: ((methods size - limit) asString, ' more...') parent: aBehavior.
		methods := (methods first: limit) copyWith: mockAbbrMethod ].
	^ methods

]

{ #category : #options }
RiUMLClassBuilder >> mustGroupExtensions [
	^ false
]

{ #category : #settings }
RiUMLClassBuilder >> outlineSize [
	^ self gapFromSubclassToSibling / 2
]

{ #category : #settings }
RiUMLClassBuilder >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale google20 ]
]

{ #category : #settings }
RiUMLClassBuilder >> packageColorScale: aTSScale [
	packageColorScale := aTSScale

]

{ #category : #hooks }
RiUMLClassBuilder >> renderIn: aView [
	super renderIn: aView.

	self addZoomingInteraction.
	self addPackInteraction.

	aView color: self backgroundColor.

	packageColoring ifTrue: [ self addPackageOutlines ].

]

{ #category : #settings }
RiUMLClassBuilder >> scaleForMethods [
	^ 8
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
	(aBehavior isRingResolved not and: [aBehavior hasMethodExtensions])
		ifTrue: [ ^ aBlock cull: 'extension' ]
]

{ #category : #settings }
RiUMLClassBuilder >> widthScaleForNarrowFontStyle [
	^ 0.8
]
