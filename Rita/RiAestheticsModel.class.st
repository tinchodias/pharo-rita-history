Class {
	#name : #RiAestheticsModel,
	#superclass : #Object,
	#instVars : [
		'innerBorder',
		'innerBorderLowImpact',
		'tinyBoxBorder',
		'colorMap',
		'inlinecolorMap',
		'iceDefinitionIconVisitor',
		'iceOperationColorVisitor'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'diff morph creation' }
RiAestheticsModel >> asContentsToDiff: aString [
	| limit |
	limit := 1000.
	aString size <= limit
		ifTrue: [ ^ aString ].
	^ String
		streamContents: [ :stream | 
			stream
				nextPutAll: (aString first: limit);
				cr;
				nextPutAll: '...etc...' ]
]

{ #category : #colors }
RiAestheticsModel >> backgroundColor [
	^ self currentTheme backgroundColor
]

{ #category : #colors }
RiAestheticsModel >> backgroundColorFor: node [
	^ (node value accept: self)
		mixed: 0.2
		with: self backgroundColor
]

{ #category : #colors }
RiAestheticsModel >> backgroundColorMixedWith: aColor [ 
	^ aColor mixed: 0.4 with: self backgroundColor
]

{ #category : #accessing }
RiAestheticsModel >> classBoxBorder [
	^ RSBorder new
		width: 1.5;
		joinMiter; 
		yourself 
]

{ #category : #accessing }
RiAestheticsModel >> classRowMargin [
	^ Margin
		left: 0
		right: 0
		top: self gapBetweenMethods / 2
		bottom: self gapBetweenMethods
]

{ #category : #colors }
RiAestheticsModel >> colorForLineInsert [
	^ self insertColor mixed: 0.7 with: self foregroundColor
]

{ #category : #colors }
RiAestheticsModel >> colorForLineModification [
	^ self modificationColor mixed: 0.7 with: self foregroundColor
]

{ #category : #colors }
RiAestheticsModel >> colorForLineNoModification [
	^ Color gray
]

{ #category : #colors }
RiAestheticsModel >> colorForLineRemove [
	^ self removeColor mixed: 0.7 with: self foregroundColor
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
		color: self currentTheme lightBackgroundColor;
		addAllMorphs: someMorphs;
		yourself
]

{ #category : #accessing }
RiAestheticsModel >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> diffMorphFor2: iceNode [
	| oldString newString morph |
	oldString := self asContentsToDiff: iceNode value rightContents.
	newString := self asContentsToDiff: iceNode value leftContents.
	morph := self scrolledUnifiedDiffMorph.
	self
		fillUnifiedDiff: morph textArea
		from: oldString
		to: newString.
	^ morph
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> diffMorphFor: iceNode [
	| oldString newString |
	oldString := self asContentsToDiff: iceNode value rightContents.
	newString := self asContentsToDiff: iceNode value leftContents.
	^ self unifiedDiffFrom: oldString to: newString
]

{ #category : #colors }
RiAestheticsModel >> fillColorFor: iceNode [
	^ iceNode value accept: iceOperationColorVisitor
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> fillUnifiedDiff: textArea from: from to: to [

	| diff |
	diff := RiUnifiedStringDiff new
		oldString: from;
		newString: to;
		build;
		yourself.

	textArea
		removeAllSegments;
		setTextWith: diff unifiedString;
		font: StandardFonts codeFont. "Don't know why it's necessary to set font again"

	diff lineJoins do: [:each |
		colorMap at: each kindSymbol ifPresent: [ :color |
			textArea addSegment: ((RiRubricTextSegment from: each fromIndex to: each toIndex)
				color: color;
				yourself).
		] ].

	diff inlineJoins do: [:each |
		inlinecolorMap at: each kindSymbol ifPresent: [ :color |
			textArea addSegment: ((RubPlainSegmentMorph from: each fromIndex to: each toIndex)
				color: color;
				yourself).
		] ].

]

{ #category : #colors }
RiAestheticsModel >> foregroundColor [
	^ self currentTheme textColor
]

{ #category : #colors }
RiAestheticsModel >> foregroundColorFor: iceNode [
	^ self foregroundColorMixedWith: (iceNode value accept: iceOperationColorVisitor)
]

{ #category : #colors }
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

{ #category : #icons }
RiAestheticsModel >> geometryForClassProperty [
	^ RSShapeFactory pentagon
		cornerRadii: 1;
		yourself
]

{ #category : #icons }
RiAestheticsModel >> geometryForClassVariable [
	^ RSShapeFactory triangle
		cornerRadii: 1;
		yourself
]

{ #category : #icons }
RiAestheticsModel >> iconForChange: iceNode [
	^ iceNode icon
]

{ #category : #icons }
RiAestheticsModel >> iconForClassPropertyDefinition: iceDefinition [
	^ RiIconGenerator new
		extent: 12 asPoint;
		foregroundColor: self foregroundColor;
		backgroundColor: self backgroundColor;
		bordered: self geometryForClassProperty
			with: (self iconTitleForClassPropertyDefinition: iceDefinition);
		newForm
]

{ #category : #icons }
RiAestheticsModel >> iconForClassVariableDefinition: iceDefinition [
	^ RiIconGenerator new
		extent: 12 asPoint;
		foregroundColor: self foregroundColor;
		backgroundColor: self backgroundColor;
		bordered: self geometryForClassVariable
			with: (self iconTitleForClassVariableDefinition: iceDefinition);
		newForm

]

{ #category : #icons }
RiAestheticsModel >> iconForDefinition: iceDefinition [
	^ iceDefinition accept: iceDefinitionIconVisitor
]

{ #category : #icons }
RiAestheticsModel >> iconForFiles [
	^ self iconNamed: #book
]

{ #category : #icons }
RiAestheticsModel >> iconTitleForClassPropertyDefinition: iceDefinition [

	| mapping |
	mapping := {
		#source -> ' '.
		#superclassName -> 'S'.
		#category -> ' '.
		#type -> 'K'.
		#comment -> 'C'.
		#traitComposition -> 'T'.
		#classTraitComposition -> 'T.' 
		} asDictionary.

	^ mapping 
		at: iceDefinition propertyName
		ifAbsent: [ iceDefinition propertyName first: 1 ]
]

{ #category : #icons }
RiAestheticsModel >> iconTitleForClassVariableDefinition: iceDefinition [

	| mapping |
	mapping := {
		#instance -> ' '.
		#class -> 'C'.
		#classInstance -> 'I'.
		#pool -> 'P'.
		} asDictionary.

	^ mapping at: iceDefinition typeToShow
]

{ #category : #initialization }
RiAestheticsModel >> initialize [
	super initialize.

	innerBorder := RSBorder new color: self foregroundColor; width: 0.75; yourself.
	innerBorderLowImpact := innerBorder copy dashArray: #(2); yourself.
	iceOperationColorVisitor := RiIceOperationColorVisitor newForAesthetics: self.
	iceDefinitionIconVisitor := RiIceDefinitionIconVisitor newForAesthetics: self.

	tinyBoxBorder := RSBorder new
		width: 1;
		color: self foregroundColor;
		joinMiter;
		dashArray: #(1); 
		yourself.

	colorMap := {
		#insert -> self insertColor.
		#remove -> self removeColor.
		} asDictionary.
	
	inlinecolorMap := {
		#insert -> self insertColor.
		#remove -> self removeColor.
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

{ #category : #colors }
RiAestheticsModel >> insertColor [
	^ self backgroundColorMixedWith: self currentTheme diffAdditionalLineBackgroundColor
]

{ #category : #colors }
RiAestheticsModel >> modificationColor [
	| reference |
	reference := self currentTheme diffRemovedLinesBackgroundColor.
	^ self backgroundColorMixedWith: 
		(Color
			h: 240
			s: reference saturation
			v: reference brightness
			alpha: reference alpha)
]

{ #category : #colors }
RiAestheticsModel >> outlineColor [
	^ self currentTheme selectionColor
]

{ #category : #accessing }
RiAestheticsModel >> outlineSize [
	^ 4
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> pathMorphWith: iceNode [

	| separator segments |
	segments := iceNode withAllParentNodes collect: [:each | each value ritaKey ].

	separator :=
		' / ' asText 
"			addAttribute: (TextColor color: Smalltalk ui theme caretColor); "
			addAttribute: TextEmphasis bold;
			yourself.
	
	^ (separator join: (segments collect: [ :each | each asString asText ])) 
		asMorph
		margins: 5 asMargin;
		lock: true;
		yourself
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> popupDiffMorphFor: iceNode [

	| topText font |
	font := LogicalFont 
		familyName: StandardFonts codeFont familyName
		pointSize: 7.
	topText := iceNode value definition ritaDescription.
	^ (self columnMorphWithAll: {
			topText asMorph.
			(self diffMorphFor2: iceNode)
				font: font;
				yourself
		})
		extent: 500@250;
		yourself
]

{ #category : #colors }
RiAestheticsModel >> removeColor [
	^ self backgroundColorMixedWith: self currentTheme diffRemovedLinesBackgroundColor
]

{ #category : #accessing }
RiAestheticsModel >> rowForChange: iceNode [
	^ (String streamContents: [:stream |
		stream
			space;
			nextPutAll: iceNode value ritaKey.
		iceNode children ifNotEmpty: [ :c |
			stream
				nextPutAll: '  (';
				print: c size;
				nextPutAll: ')' ] ]) asMorph
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> scrolledUnifiedDiffMorph [
	^ RubScrolledTextMorph new
		beReadOnly;
		beWrapped;
		margins: (Margin top: 0 left: 4 bottom: 0 right: 4);
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		yourself
]

{ #category : #colors }
RiAestheticsModel >> secondaryOutlineColor [
	^ self outlineColor alpha: 0.7
]

{ #category : #icons }
RiAestheticsModel >> shapeForClassProperty: iceNode [
	^ self
		shapeForClassPropertyDefinition: iceNode value definition
		color: (self fillColorFor: iceNode)
		border: (self innerBorderFor: iceNode)
]

{ #category : #icons }
RiAestheticsModel >> shapeForClassPropertyDefinition: iceDefinition color: aColor border: aBorder [
	^ RiIconGenerator new
		extent: self widthForMethod asPoint;
		foregroundColor: self foregroundColor;
		border: aBorder;
		labelScale: 0.08;
		fillShape: self geometryForClassProperty
			colored: aColor
			labeled: (self iconTitleForClassPropertyDefinition: iceDefinition);
		newRSComposite

]

{ #category : #icons }
RiAestheticsModel >> shapeForClassVariable: iceNode [
	^ self
		shapeForClassVariableDefinition: iceNode value definition
		color: (self fillColorFor: iceNode)
		border: (self innerBorderFor: iceNode)
]

{ #category : #icons }
RiAestheticsModel >> shapeForClassVariableDefinition: iceDefinition color: aColor border: aBorder [
"	| shape |
	shape := RSPolygon new
			points: {(-0.25@1.75). (0.616025403784439@0.25). (-1.1160254037844388@0.25)};
			cornerRadii: 1.5;
			yourself."
	"^^^ Generated (initially) by: (RSPolygon 
			generateUnitNgonPoints: 3
			rotation: Float pi) collect: [ :each | each + (-0.25@0.75) ]"
	
	^ RiIconGenerator new
		extent: self widthForMethod asPoint;
		foregroundColor: self foregroundColor;
		border: aBorder;
		labelScale: 0.05;
		fillShape: self geometryForClassVariable
			colored: aColor
			labeled: (self iconTitleForClassVariableDefinition: iceDefinition);
		newRSComposite

]

{ #category : #icons }
RiAestheticsModel >> shapeForDefinition: iceDefinition [
	^ self shapeForIcon: (self iconForDefinition: iceDefinition)
]

{ #category : #icons }
RiAestheticsModel >> shapeForIcon: aForm [
	^ RSBitmap new
		form: aForm;
		scaleBy: 0.7;
		yourself
]

{ #category : #accessing }
RiAestheticsModel >> tinyBoxBorder [
	^ tinyBoxBorder
]

{ #category : #'diff morph creation' }
RiAestheticsModel >> unifiedDiffFrom: from to: to [

	| textArea diff |
	textArea := RubEditingArea new
		beReadOnly;
		font: StandardFonts codeFont;
		margins: 0 asMargin;
		yourself.
		
	diff := RiUnifiedStringDiff new
		oldString: from;
		newString: to;
		build;
		yourself.

	textArea
		removeAllSegments;
		updateTextWith: diff unifiedString.

	diff lineJoins do: [:each |
		colorMap at: each kindSymbol ifPresent: [ :color |
			textArea addSegment: ((RiRubricTextSegment from: each fromIndex to: each toIndex)
				color: color;
				yourself).
		] ].

	diff inlineJoins do: [:each |
		inlinecolorMap at: each kindSymbol ifPresent: [ :color |
			textArea addSegment: ((RubPlainSegmentMorph from: each fromIndex to: each toIndex)
				color: color;
				yourself).
		] ].

	^ textArea
]

{ #category : #accessing }
RiAestheticsModel >> widthForMethod [
	^ 14
]
