Class {
	#name : #RiTorchUMLClassRenderer,
	#superclass : #RSAbstractUMLClassRenderer,
	#instVars : [
		'blockWhenNodeSelected',
		'innerBorder',
		'methodShapeCreatorVisitor',
		'tinyBoxBorder'
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

	iceNode value definition isTraitDefinition ifTrue: [ 
		theBorder dashArray: #(2) ].

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
RiTorchUMLClassRenderer >> foregroundColorFor: node [
	^ node value ritaColor
		mixed: 0.8
		with: self foregroundColor
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> fullClassShapeFor: aClass [
	| shapes box title vars methods boxTitle |
	title := self titleFor: aClass.
	vars := self varsFor: aClass.
	methods := self methodsFor: aClass.
	shapes := self groupFor: { vars. methods }.
	shapes addFirst: title.
	box := self classBoxShapeFor: aClass.
	boxTitle := self classNameBoxFor: aClass.
	self applyLayoutOn: shapes.
	self adjustTitle: title on: shapes.
	shapes addFirst: boxTitle.
	shapes addLast: box.
	self adjustBox: box on: shapes. 
	boxTitle 
		position: box position x @ title position y ;
		extent: (box width @ title height).
	^ RSComposite new
		popup;
		draggable;
		model: aClass;
		shapes: shapes;
		yourself.
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
	^ 30
]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapFromSubclassToSibling [
	^ self gapFromClassToSubclass / 2
]

{ #category : #initialization }
RiTorchUMLClassRenderer >> initialize [
	super initialize.

	blockWhenNodeSelected := [ :anIceNode | ].
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor builder: self.

	innerBorder := RSBorder new color: self foregroundColor; width: 0.5; yourself.
	tinyBoxBorder := RSBorder new
		width: 1;
		color: self foregroundColor;
		joinMiter;
		dashArray: #(1); 
		yourself.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodFor: iceNode [
	| shapes |
	shapes := OrderedCollection new.

	iceNode nextNodeSuchThat: [ :each | each value name = 'category' ]
		ifFound: [:found | shapes add: (self shapeForMethodProperty: found) ].
	shapes ifEmpty: [ 
		shapes add: (RSShape box 
			width: self scaleForMethods;
			height: self scaleForMethods / 2;
			noPaint; 
			border: innerBorder;
			yourself) ].
	
"	iceNode nextNodeSuchThat: [ :each | each value name = 'source' ] ifFound: [:found |"
		shapes add: ((iceNode accept: methodShapeCreatorVisitor)
			model: iceNode;
			border: innerBorder;
			when: RSMouseClick do: self blockForMouseClickOnIceNode;
			addInteraction: self popupForIceNodeShapes;
			yourself).
	
	RSVerticalLineLayout new gapSize: 0; on: shapes.
	
	^ RSComposite new
		shapes: shapes;
		yourself
]

{ #category : #settings }
RiTorchUMLClassRenderer >> methodsFor: aClass [
	^ (super methodsFor: aClass)
		padding: ( Margin 
		 	left: 0
			right: 0
			top: 5
			bottom: 5);
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
	self flag: #todo.	"FIX super"
	^ RSPopup new
		shapeBuilder: [ :node | 
			(super shapeFor: node)
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
		ifTrue:[
			(self fullClassShapeFor: iceNode)
				when: RSMouseClick do: self blockForMouseClickOnIceNode;
				removeInteractionIfPresent: RSPopup;
				addInteraction: self popupForIceNodeShapes;
				yourself ]
		ifFalse: [ self tinyClassShapeFor: iceNode ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForMethodProperty: iceNode [
	^ RSShape box
		width: self scaleForMethods;
		height: self scaleForMethods/2;
		model: iceNode;
		border: innerBorder;
		color: (self fillColorFor: iceNode);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForProperty: iceNode [
	^ RSPolygon triangle
"		rotateByDegrees: 180;"
		model: iceNode;
		size: self scaleForMethods;
		border: innerBorder;
		color: (self fillColorFor: iceNode);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
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
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> tinyClassShapeFor: iceNode [
	^ RSBox new
		noPaint;
		size: 10;
		model: iceNode;
		border: tinyBoxBorder;
		addInteraction: self popupForTinyClassShapes;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> titleFor: model [
	| label |
	label := RSLabel new
		color: self textColor;
		text: (modelDescriptor classname rsValue: model) asString;
		scaleBy: 0.7@0.8
		yourself.
	"label fontSize: label fontSize * 0.8".
	^ label
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varFor: iceNode [
	"Hacky: It draws not only variables but also class properties (e.g. superclass change)."
	
	^ iceNode value definition className = #IceVariableDefinition
		ifTrue: [ self shapeForVariable: iceNode ]
		ifFalse: [ self shapeForProperty: iceNode ]

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varsFor: model [
	^ (super varsFor: model)
		padding:
			(Margin
				left: 0
				right: 0
				top: 3
				bottom: 3);
		yourself
]
