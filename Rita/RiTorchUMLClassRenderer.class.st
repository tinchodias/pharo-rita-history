Class {
	#name : #RiTorchUMLClassRenderer,
	#superclass : #RSAbstractUMLClassRenderer,
	#instVars : [
		'blockWhenNodeSelected',
		'innerBorder',
		'methodShapeCreatorVisitor',
		'tinyBoxBorder',
		'innerBorderLowImpact',
		'highlighingController'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #private }
RiTorchUMLClassRenderer >> addPackInteractionOn: aCanvas [
	"Interaction to pack hierarachies."

	| packer |
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: self gapBetweenHierarchies.
	aCanvas addInteraction: packer.

]

{ #category : #private }
RiTorchUMLClassRenderer >> addZoomingInteractionOn: aCanvas [
	"Interaction for zooming."

	| controls |
	controls := RSCanvasController new.
	controls configuration
		useBasicZoom;
		maxScale: 1.
	aCanvas addInteraction: controls.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> applyMLayoutOn: shapes [
	RSFlowLayout new 
		gapSize: self gapBetweenMethods;
		maxWidth: self currentMaxWidth;
		on: shapes.
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> applyVLayoutOn: shapes [
	self applyMLayoutOn: shapes
]

{ #category : #settings }
RiTorchUMLClassRenderer >> backgroundColor [
	^ self currentTheme backgroundColor
]

{ #category : #settings }
RiTorchUMLClassRenderer >> backgroundColorFor: node [
	^ node value ritaColor
		alphaMixed: 0.1
		with: self backgroundColor
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockForMouseClickOnIceNode [
	^ [ :clickEvent | blockWhenNodeSelected value: clickEvent shape model ]
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockWhenNodeSelected: anObject [
	blockWhenNodeSelected := anObject 
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classBoxShapeFor: iceNode [
	| theBorder |
	theBorder := self boxBorder copy color: (self foregroundColorFor: iceNode).

	^ RSBox new
		noPaint;
		border: theBorder;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classNameBoxFor: aClass [ 
	^ RSBox new
		model: aClass;
		color: (self backgroundColorFor: aClass);
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classPropertiesFor: iceNode [
	| properties shapes |
	properties := modelDescriptor classProperties rsValue: iceNode.
	shapes := properties collect: [ :each | self shapeForClassProperty: each ].
	self applyVLayoutOn: shapes.

	^ RSComposite new
		shapes: shapes;
		padding:
			(Margin
				left: 0
				right: 0
				top: self gapBetweenMethods
				bottom: self gapBetweenMethods);
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> currentMaxWidth [
	^ 200
]

{ #category : #settings }
RiTorchUMLClassRenderer >> currentTheme [
	^ Smalltalk ui theme
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultBoxBorder [
	^ RSBorder new
		width: 1.5;
		joinMiter; 
		yourself 
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultClassBoxPadding [
	^ 10@0
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultEdgeBuilder [
	^ RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: innerBorder;
		"markerStart: self marker;"
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultLayout [
	| defaultLayout |
	defaultLayout := RSLayoutBuilder new.
	defaultLayout tree 
		verticalGap: self gapFromClassToSubclass;
		horizontalGap: self gapFromSubclassToSibling.
	^ defaultLayout

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultMarker [
	^ RSMarker new
		shape: (RSPolygon triangle
			color: self backgroundColor;
			border: self border;
			size: self gapFromClassToSubclass / 6;
			yourself);
		offset: self gapFromClassToSubclass / 12;
		yourself

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultTextColor [
	^ self foregroundColor
]

{ #category : #private }
RiTorchUMLClassRenderer >> diffMorphFor: iceNode [

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

{ #category : #settings }
RiTorchUMLClassRenderer >> fillColorFor: node [
	| color |
	color := node value ritaColor.
	^ color isTransparent
		ifTrue: [ color ]
		ifFalse: [ color mixed: 0.8 with: self foregroundColor ]
]

{ #category : #settings }
RiTorchUMLClassRenderer >> foregroundColor [
	^ self currentTheme textColor
]

{ #category : #settings }
RiTorchUMLClassRenderer >> foregroundColorFor: iceNode [
	^ self foregroundColorMixedWith: iceNode value ritaColor
]

{ #category : #settings }
RiTorchUMLClassRenderer >> foregroundColorMixedWith: aColor [
	^ aColor
		mixed: 0.8
		with: self foregroundColor
]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.3
]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapBetweenMethods [
	^ 4

]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapFromClassToSubclass [
	^ 20
]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapFromSubclassToSibling [
	^ self gapFromClassToSubclass / 2
]

{ #category : #accessing }
RiTorchUMLClassRenderer >> highlighingController: aRiHighlighingController [
	highlighingController := aRiHighlighingController
]

{ #category : #initialization }
RiTorchUMLClassRenderer >> initialize [
	super initialize.

	blockWhenNodeSelected := [ :anIceNode | ].
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor builder: self.

	innerBorder := RSBorder new color: self foregroundColor; width: 0.75; yourself.
	innerBorderLowImpact := innerBorder copy dashArray: #(2); yourself.
	tinyBoxBorder := RSBorder new
		width: 1;
		color: self foregroundColor;
		joinMiter;
		dashArray: #(1); 
		yourself.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> innerBorderFor: iceNode [
	^ iceNode value isOnlyLowImpact
		ifTrue: [ innerBorderLowImpact ]
		ifFalse: [ innerBorder ]
]

{ #category : #settings }
RiTorchUMLClassRenderer >> insertColor [
	^ self foregroundColorMixedWith: Color green
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodFor: iceNode [
	| shapes shape |
	shapes := OrderedCollection new.

	iceNode nextNodeSuchThat: [ :each | each value name = #category ]
		ifFound: [:found | shapes add: (self shapeForMethodProperty: found) ].
	shapes ifEmpty: [ 
		shapes add: (RSShape box 
			width: self scaleForMethods;
			height: self scaleForMethods / 2;
			color: self backgroundColor; 
			border: innerBorderLowImpact;
			yourself) ].
	
	iceNode nextNodeSuchThat: [ :each | each value name = #source ] ifFound: [:found |
		shapes add: ((iceNode accept: methodShapeCreatorVisitor)
			model: found;
			border: (self innerBorderFor: found);
			when: RSMouseClick do: self blockForMouseClickOnIceNode;
			addInteraction: self popupForIceNodeShapes;
			addInteraction: highlighingController;
			yourself) ].
	
	RSVerticalLineLayout new gapSize: 0; on: shapes.
	
	^ RSComposite new
		model: iceNode;
		shapes: shapes;
		addInteraction: highlighingController;
		yourself.

]

{ #category : #settings }
RiTorchUMLClassRenderer >> methodsFor: aClass [
	^ (super methodsFor: aClass)
		padding:
			(Margin
				left: 0
				right: 0
				top: self gapBetweenMethods
				bottom: self gapBetweenMethods);
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForIceNodeShapes [
	^ RSMorphicPopup new
		morphBuilder: [ :iceNode |
			self diffMorphFor: iceNode ];
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForTinyClassShapes [
	^ RSPopup new
		shapeBuilder: [ :node | 
			(self shapeForFullClass: node)
				color: self backgroundColor;
				yourself ];
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForVariableShapes [
	^ RSPopup text: [ :node | 
		'{1} [{2}]' format: { node value definition name. node value definition typeToShow } ]
]

{ #category : #settings }
RiTorchUMLClassRenderer >> removeColor [
	^ self foregroundColorMixedWith: Color red
]

{ #category : #settings }
RiTorchUMLClassRenderer >> scaleForMethods [
	^ 10
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> setUpCanvas: aCanvas [

	self addZoomingInteractionOn: aCanvas.
	self addPackInteractionOn: aCanvas.

	aCanvas color: self backgroundColor.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> shapeFor: iceNode [
	^ iceNode hasChanges
		ifTrue: [ self shapeForFullClass: iceNode ]
		ifFalse: [ self shapeForTinyClass: iceNode ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForClassProperty: iceNode [
	| mapping composite letter |
	mapping := {
		#superclassName -> 'S'.
		#category -> 'P'.
		#type -> 'K'.
		#comment -> 'C'.
		#traitComposition -> 'T'.
		#classTraitComposition -> 'T.' 
		} asDictionary.

	letter := mapping 
		at: iceNode value definition propertyName
		ifAbsent: [ iceNode value definition propertyName first: 1 ].
		
	composite := RiIconGenerator new
		extent: self scaleForMethods asPoint;
		foregroundColor: (self fillColorFor: iceNode);
		backgroundColor: self backgroundColor;
		border: innerBorder "(self innerBorderFor: iceNode)";
		filled: RSShape square with: letter;
		newRSComposite.

	^ composite
		model: iceNode;
		adjustToChildren;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> shapeForFullClass: iceNode [
	| shapes box title classProperties vars methods boxTitle |
	title := self titleFor: iceNode.
	classProperties := self classPropertiesFor: iceNode.
	vars := self varsFor: iceNode.
	methods := self methodsFor: iceNode.
	shapes := self groupFor: { classProperties. vars. methods }.
	shapes addFirst: title.
	box := self classBoxShapeFor: iceNode.
	boxTitle := self classNameBoxFor: iceNode.
	self applyLayoutOn: shapes.
	self adjustTitle: title on: shapes.
	shapes addFirst: boxTitle.
	shapes addLast: box.
	self adjustBox: box on: shapes. 
	boxTitle
		position: box position x @ title position y;
		extent: (box width @ title height).

	^ RSComposite new
		model: iceNode;
		shapes: shapes;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForMethodProperty: iceNode [
	^ RSShape box
		width: self scaleForMethods;
		height: self scaleForMethods/1.5;
		model: iceNode;
		border: (self innerBorderFor: iceNode);
		color: (self fillColorFor: iceNode);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForTinyClass: iceNode [
	^ RSBox new
		noPaint;
		size: 10;
		model: iceNode;
		border: tinyBoxBorder;
		addInteraction: self popupForTinyClassShapes;
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForVariable: iceNode [
	^ RSPolygon circle
		model: iceNode;
		size: self scaleForMethods;
		border: innerBorder;
		color: (self fillColorFor: iceNode);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForVariableShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> titleFor: model [
	| icon label shapes |
	icon := RSBitmap new
		form: model value definition icon;
		scaleBy: 0.7;
		yourself.

	label := RSLabel new
		color: self textColor;
		text: (modelDescriptor classname rsValue: model) asString;
		scaleBy: 0.7@0.8
		yourself.
	"label fontSize: label fontSize * 0.8".

	shapes := { icon. label }.

	RSHorizontalLineLayout new 
		gapSize: 1;
		alignCenter;
		on: shapes.
		
	^ RSComposite new
		shapes: shapes;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varFor: iceNode [
	^ self shapeForVariable: iceNode
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varsFor: model [
	^ (super varsFor: model)
		padding:
			(Margin
				left: 0
				right: 0
				top: self gapBetweenMethods
				bottom: self gapBetweenMethods);
		yourself
]
