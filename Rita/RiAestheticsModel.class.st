Class {
	#name : #RiAestheticsModel,
	#superclass : #Object,
	#instVars : [
		'innerBorder',
		'innerBorderLowImpact',
		'tinyBoxBorder'
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

{ #category : #accessing }
RiAestheticsModel >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #accessing }
RiAestheticsModel >> diffMorphFor: iceNode [

	| presenter font |
	presenter := RiUnifiedDiffPresenter new
		buildWithSpec;
		model: {
			#from -> iceNode value rightContents.
			#to -> iceNode value leftContents
			} asDictionary;
		yourself.
			
	font := LogicalFont 
		familyName: StandardFonts codeFont familyName
		pointSize: 7.

	^ presenter theWidget
		font: font;
		extent: 300@250;
		scrollbarsShowNever;
		yourself.
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

	^ 0.3
]

{ #category : #accessing }
RiAestheticsModel >> gapBetweenMethods [
	^ 4

]

{ #category : #accessing }
RiAestheticsModel >> gapFromClassToSubclass [
	^ 20
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
		bordered: RSShape square
			with: (self iconTitleForClassPropertyDefinition: iceDefinition);
		newForm
]

{ #category : #accessing }
RiAestheticsModel >> iconForClassVariableDefinition: iceDefinition [
	^ RiIconGenerator new
		extent: 10 asPoint;
		foregroundColor: self foregroundColor;
		backgroundColor: self backgroundColor;
		bordered: RSShape circle with: '';
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
		filled: RSShape square
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
		filled: RSShape circle with: '';
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
