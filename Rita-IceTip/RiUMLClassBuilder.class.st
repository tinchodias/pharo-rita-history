Class {
	#name : #RiUMLClassBuilder,
	#superclass : #RSUMLClassBuilder,
	#instVars : [
		'environment',
		'packageColoring',
		'packageColorScale'
	],
	#category : #'Rita-IceTip'
}

{ #category : #examples }
RiUMLClassBuilder class >> exampleHiedra [
	self openForRepositoryNamed: 'Hiedra'
]

{ #category : #examples }
RiUMLClassBuilder class >> exampleTorchLikeHiedra [
	self openTorchLikeForRepositoryNamed: 'Hiedra'
]

{ #category : #convenience }
RiUMLClassBuilder class >> openForRepositoryNamed: aString [
	| repo |
	repo := IceRepository registry detect: [ :each| each name = aString ].
	
	^ self new
		iceRepository: repo;
		build;
		open;
		yourself
]

{ #category : #convenience }
RiUMLClassBuilder class >> openTorchLikeForRepositoryNamed: aString [
	| repo |
	repo := IceRepository registry detect: [ :each| each name = aString ].
	
	^ self new
		iceRepository: repo;
		disableSelectors;
		build;
		open;
		yourself
]

{ #category : #hooks }
RiUMLClassBuilder >> addPackageOutlinesTo: aView [
	| packageShapeBuilder packageShapes |
	packageShapeBuilder := RSShapeBuilder box
		noPaint;
		border: [:each | (TSBorder new 
			color: ((self packageColorScale scale: each model package name) mixed: 0.25 with: Smalltalk ui theme backgroundColor) )
			joinMiter;
			width: 20];
		extent: [ :each | each extent + 20 ];
		onMyselfDo: [:each | [ :el |
			each when: TSPositionChangedEvent do: [ el position: each position ]  ] ].
	packageShapes := packageShapeBuilder elementsOn: (aView elements select: [:el | el model package isRingResolved ]).
	aView addAll: packageShapes.
	packageShapes pushBack.

]

{ #category : #initialization }
RiUMLClassBuilder >> applyCurrentUITheme [
	
	| theme |
	theme := Smalltalk ui theme.
	self view color: theme backgroundColor.
	self renderer defaultBorder color: theme textColor.
	self renderer marker shape color: theme backgroundColor.

]

{ #category : #initialization }
RiUMLClassBuilder >> beHorizontal [
	self renderer edgeBuilder: (RSEdgeBuilder orthoHorizontal
		attachPoint: (RSHorizontalAttachPoint new startOffset: 20);
		markerStart: self renderer marker).
	self layout horizontalTree
		verticalGap: 50;
		horizontalGap: 100.
]

{ #category : #initialization }
RiUMLClassBuilder >> beVertical [
	self shouldBeImplemented
]

{ #category : #initialization }
RiUMLClassBuilder >> builderForClassName [

	^ (self builderForLabel: #yourself widthScale: 1)
		bold;
		yourself

]

{ #category : #initialization }
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

{ #category : #initialization }
RiUMLClassBuilder >> builderForMethodName [

	^ (self builderForLabel: #selector widthScale: 0.8)
		if: [:aRGMethod | aRGMethod isExtension or: [aRGMethod isMetaSide ] ] then: [:s | s underline ];
		yourself

]

{ #category : #initialization }
RiUMLClassBuilder >> builderForSlotName [
	^ (self builderForLabel: #name widthScale: 1)
		if: [:m | m isVariableDefinition and: [ m isClassVariable ] ] then: [ :s | s bold ];
		if: [:m | m isVariableDefinition and: [ m isPoolVariable ] ] then: [ :s | s bold; underline ];
		if: [:m | m isVariableDefinition and: [ m isClassInstanceVariable ] ] then: [ :s | self shouldBeImplemented ]
		yourself

]

{ #category : #initialization }
RiUMLClassBuilder >> disablePackageColoring [
	packageColoring := false
]

{ #category : #initialization }
RiUMLClassBuilder >> disableSelectors [
	self renderer: RSTorchUMLClassRenderer new.
	self renderer classShape interactionDo: [ :i | i clear; inspectable ].
	self renderer methodShape: (RSShapeBuilder box 
		width: 10;
		height: [ :met | (met sourceCode lines size * 5) log + 10 ];
		interactionDo: [:i | i popup multiline]).

]

{ #category : #initialization }
RiUMLClassBuilder >> enablePackageColoring [
	packageColoring := true
]

{ #category : #initialization }
RiUMLClassBuilder >> enableSelectors [
	self renderer: RSBasicUMLClassRenderer new.

	self renderer classBoxShape
		noPaint;
		cornerRadius: 3;
		if: [ :each | each package isRingResolved not ]
			then: [:each | each border: (TSBorder new dashArray: #(5 5); color: self foregroundColor; yourself) ].

	self renderer classShape interactionDo: [ :i | i clear; inspectable ].
	self renderer classNameShape: self builderForClassName.
	self renderer methodShape: self builderForMethodName.
	self renderer varShape: self builderForSlotName.

]

{ #category : #convenience }
RiUMLClassBuilder >> environment: aRGEnvironment [

	| all resolved toDraw |
	environment := aRGEnvironment.
	environment clean.
	all := environment ask allClassesAndTraits.
	resolved := all select: [:each | each isRingResolved ].
	toDraw := resolved reject: [ :each | #(Object Metaclass) includes: each name ].
	self classes: toDraw.

]

{ #category : #hooks }
RiUMLClassBuilder >> foregroundColor [
	^ Smalltalk ui theme textColor
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
	
	self enableSelectors.
	self enablePackageColoring.

	
	"TODO: sorted:[ :a :b | a selector < b selector ]"
	self classDescriptor
		instVars: [:cls | cls sharedPools, cls classVariables, cls theMetaClass slots, cls slots ];
		methods: [ :cls | cls theMetaClass methods, cls methods ]
]

{ #category : #initialization }
RiUMLClassBuilder >> maxClassWidth [
	^ 400
]

{ #category : #hooks }
RiUMLClassBuilder >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale google20 ]
]

{ #category : #hooks }
RiUMLClassBuilder >> renderIn: aView [
	self applyCurrentUITheme.

	super renderIn: aView.

	RSHierarchyPacker new applyto: aView.

	packageColoring ifTrue: [ self addPackageOutlinesTo: aView ].



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
