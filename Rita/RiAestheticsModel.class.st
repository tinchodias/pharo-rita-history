Class {
	#name : #RiAestheticsModel,
	#superclass : #Object,
	#instVars : [
		'innerBorder',
		'innerBorderLowImpact',
		'tinyBoxBorder',
		'colorMap',
		'inlinecolorMap'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiAestheticsModel >> backgroundColor [
	^ self currentTheme backgroundColor
]

{ #category : #accessing }
RiAestheticsModel >> backgroundColorFor: node [
	^ node value ritaColor
		alphaMixed: 0.1
		with: self backgroundColor
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> columnMorphWithAll: someMorphs [

	^ PanelMorph new
		changeTableLayout;
		vResizing: #shrinkWrap;
		hResizing: #spaceFill;
		listDirection: #topToBottom;
		cellPositioning: #topLeft;
		cellInset: 0;
		addAllMorphs: someMorphs;
		yourself
]

{ #category : #accessing }
RiAestheticsModel >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> diffMorphFor: iceNode [

	| textArea |
	textArea := RubEditingArea new
		beReadOnly;
		font: StandardFonts codeFont;
		yourself.

	self 
		setUpUnifiedDiffFrom: (iceNode value rightContents)
		to: (iceNode value leftContents)
		on: textArea.

	^ textArea
]

{ #category : #accessing }
RiAestheticsModel >> fillColorFor: node [
	| color |
	color := node value ritaColor.
	^ color isTransparent
		ifTrue: [ color ]
		ifFalse: [ color mixed: 0.8 with: self foregroundColor ]
]

{ #category : #accessing }
RiAestheticsModel >> foregroundColor [
	^ self currentTheme textColor
]

{ #category : #accessing }
RiAestheticsModel >> foregroundColorFor: iceNode [
	^ self foregroundColorMixedWith: iceNode value ritaColor
]

{ #category : #accessing }
RiAestheticsModel >> foregroundColorMixedWith: aColor [
	^ aColor
		mixed: 0.8
		with: self foregroundColor
]

{ #category : #accessing }
RiAestheticsModel >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.2
]

{ #category : #accessing }
RiAestheticsModel >> gapBetweenMethods [
	^ 4

]

{ #category : #accessing }
RiAestheticsModel >> gapFromClassToSubclass [
	^ 15
]

{ #category : #accessing }
RiAestheticsModel >> gapFromSubclassToSibling [
	^ self gapFromClassToSubclass / 2
]

{ #category : #accessing }
RiAestheticsModel >> iconForChange: iceNode [
	^ iceNode icon
]

{ #category : #accessing }
RiAestheticsModel >> iconForClassPropertyDefinition: iceDefinition [
	^ RiIconGenerator new
		extent: 12 asPoint;
		foregroundColor: self foregroundColor;
		backgroundColor: self backgroundColor;
		bordered: RSShapeFactory square
			with: (self iconTitleForClassPropertyDefinition: iceDefinition);
		newForm
]

{ #category : #accessing }
RiAestheticsModel >> iconForClassVariableDefinition: iceDefinition [
	^ RiIconGenerator new
		extent: 10 asPoint;
		foregroundColor: self foregroundColor;
		backgroundColor: self backgroundColor;
		bordered: RSShapeFactory circle
			with: (self iconTitleForClassVariableDefinition: iceDefinition);
		newForm

]

{ #category : #accessing }
RiAestheticsModel >> iconForDefinition: iceDefinition [
	(iceDefinition isKindOf: IcePropertyDefinition)
		ifTrue: [ ^ self iconForClassPropertyDefinition: iceDefinition ].

	(iceDefinition isKindOf: IceVariableDefinition)
		ifTrue: [ ^ self iconForClassVariableDefinition: iceDefinition ].

	^ iceDefinition icon
]

{ #category : #accessing }
RiAestheticsModel >> iconTitleForClassPropertyDefinition: iceDefinition [

	| mapping |
	mapping := {
		#source -> '>'.
		#superclassName -> 'S'.
		#category -> 'P'.
		#type -> 'K'.
		#comment -> 'C'.
		#traitComposition -> 'T'.
		#classTraitComposition -> 'T.' 
		} asDictionary.

	^ mapping 
		at: iceDefinition propertyName
		ifAbsent: [ iceDefinition propertyName first: 1 ]
]

{ #category : #accessing }
RiAestheticsModel >> iconTitleForClassVariableDefinition: iceDefinition [

	| mapping |
	mapping := {
		#instance -> 'i'.
		#class -> 'c'.
		#classInstance -> 'i.'.
		#pool -> 'p'.
		} asDictionary.

	^ mapping at: iceDefinition typeToShow
]

{ #category : #initialization }
RiAestheticsModel >> initialize [
	super initialize.

	innerBorder := RSBorder new color: self foregroundColor; width: 0.75; yourself.
	innerBorderLowImpact := innerBorder copy dashArray: #(2); yourself.

	tinyBoxBorder := RSBorder new
		width: 1;
		color: self foregroundColor;
		joinMiter;
		dashArray: #(1); 
		yourself.

	colorMap := {
		#insert -> self currentTheme diffAdditionalLineBackgroundColor.
		#remove -> self currentTheme diffRemovedLinesBackgroundColor.
		} asDictionary.
	
	inlinecolorMap := {
		#insert -> self currentTheme diffAdditionalTextInLineBackgroundColor.
		#remove -> self currentTheme diffRemovalHighlightColor.
		} asDictionary 
]

{ #category : #accessing }
RiAestheticsModel >> innerBorder [
	^ innerBorder
]

{ #category : #accessing }
RiAestheticsModel >> innerBorderFor: iceNode [
	^ iceNode value isOnlyLowImpact
		ifTrue: [ innerBorderLowImpact ]
		ifFalse: [ innerBorder ]
]

{ #category : #accessing }
RiAestheticsModel >> innerBorderLowImpact [
	^ innerBorderLowImpact
]

{ #category : #accessing }
RiAestheticsModel >> insertColor [
	^ self foregroundColorMixedWith: Color green
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> pathMorphWith: segments [

	| separator |
	separator := 
		' / ' asText 
			addAttribute: (TextColor color: Smalltalk ui theme caretColor); 
			addAttribute: TextEmphasis bold;
			yourself.
	
	^ (separator join: (segments collect: [ :each | each asString asText ])) 
		asMorph
		lock: true;
		yourself
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> popupDiffMorphFor: iceNode [

	^ "self columnMorphWithAll: {
			self pathMorphWith: iceNode allPathSegments.
			"(self diffMorphFor: iceNode)
				font: (LogicalFont 
					familyName: StandardFonts codeFont familyName
					pointSize: 7);
				yourself
		
]

{ #category : #accessing }
RiAestheticsModel >> removeColor [
	^ self foregroundColorMixedWith: Color red
]

{ #category : #accessing }
RiAestheticsModel >> rowForChange: iceNode [
	^ iceNode ritaKey asMorph
]

{ #category : #accessing }
RiAestheticsModel >> scaleForMethods [
	^ 10
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> setUpUnifiedDiffFrom: from to: to on: textArea [

	| diff |
	diff := RiUnifiedStringDiff new
		oldString: from;
		newString: to;
		build;
		yourself.

	textArea removeAllSegments.

	textArea updateTextWith: diff unifiedString.

	diff lineJoins do: [:each |
		colorMap at: each rawkind ifPresent: [ :color |
			textArea addSegment: ((RubPlainSegmentMorph from: each rawfrom to: each rawto)
				color: color;
				yourself).
		] ].

	diff inlineJoins do: [:each |
		inlinecolorMap at: each rawkind ifPresent: [ :color |
			textArea addSegment: ((RubPlainSegmentMorph from: each rawfrom to: each rawto)
				color: color;
				yourself).
		] ].
	

]

{ #category : #accessing }
RiAestheticsModel >> shapeForClassProperty: iceNode [
	^ self
		shapeForClassPropertyDefinition: iceNode value definition
		color: (self fillColorFor: iceNode)
		border: (self innerBorderFor: iceNode)
]

{ #category : #accessing }
RiAestheticsModel >> shapeForClassPropertyDefinition: iceDefinition color: aColor border: aBorder [

	^ RiIconGenerator new
		extent: self scaleForMethods * 1.3 asPoint;
		foregroundColor: aColor;
		backgroundColor: self backgroundColor;
		border: aBorder;
		filled: RSShapeFactory square
			with: (self iconTitleForClassPropertyDefinition: iceDefinition);
		newRSComposite

]

{ #category : #accessing }
RiAestheticsModel >> shapeForClassVariable: iceNode [
	^ self
		shapeForClassVariableDefinition: iceNode value definition
		color: (self fillColorFor: iceNode)
		border: (self innerBorderFor: iceNode)
]

{ #category : #accessing }
RiAestheticsModel >> shapeForClassVariableDefinition: iceDefinition color: aColor border: aBorder [
	^ RiIconGenerator new
		extent: self scaleForMethods asPoint;
		foregroundColor: aColor;
		backgroundColor: self backgroundColor;
		border: aBorder;
		filled: RSShapeFactory circle
			with: (self iconTitleForClassVariableDefinition: iceDefinition);
		newRSComposite

]

{ #category : #accessing }
RiAestheticsModel >> shapeForDefinition: iceDefinition [
	^ RSBitmap new
		form: (self iconForDefinition: iceDefinition);
		scaleBy: 0.7;
		yourself
]

{ #category : #accessing }
RiAestheticsModel >> tinyBoxBorder [
	^ tinyBoxBorder
]
