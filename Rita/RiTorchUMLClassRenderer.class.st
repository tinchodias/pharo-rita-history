Class {
	#name : #RiTorchUMLClassRenderer,
	#superclass : #RSAbstractUMLClassRenderer,
	#instVars : [
		'blockWhenNodeSelected',
		'methodShapeCreatorVisitor',
		'highlighingController',
		'aesthetics',
		'isExpanded',
		'blockWhenNodesHighlighted',
		'showMethodsLOC'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #private }
RiTorchUMLClassRenderer >> addPackInteractionOn: aCanvas [
	"Interaction to pack hierarachies."

	| packer |
	packer := RSHierarchyPacker new.
	packer rectanglePackLayout gap: aesthetics gapBetweenHierarchies.
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

{ #category : #accessing }
RiTorchUMLClassRenderer >> aesthetics: aRiAestheticsModel [
	aesthetics := aRiAestheticsModel.
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor aesthetics: aesthetics.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> applyMLayoutOn: shapes [
	RSFlowLayout new 
		gapSize: aesthetics gapBetweenMethods;
		maxWidth: self classBoxMaxWidth;
		on: shapes.
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> applyVLayoutOn: shapes [
	self applyMLayoutOn: shapes
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockForMouseClickOnIceNode [
	^ [ :clickEvent | blockWhenNodeSelected value: clickEvent shape model ]
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockForMouseEnterOnIceNode [
	^ [ :clickEvent | blockWhenNodesHighlighted value: { clickEvent shape model } ]
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockForMouseLeaveOnIceNode [
	^ [ :clickEvent | blockWhenNodesHighlighted value: #() ]
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockWhenNodeSelected: aBlock [
	blockWhenNodeSelected := aBlock 
]

{ #category : #options }
RiTorchUMLClassRenderer >> blockWhenNodesHighlighted: aBlock [
	blockWhenNodesHighlighted := aBlock 
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classBoxMaxWidth [
	^ isExpanded
		ifTrue: [ 200 ]
		ifFalse: [ 60 ]

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classBoxShapeFor: iceNode [
	| theBorder |
	theBorder := self boxBorder copy color: (aesthetics foregroundColorFor: iceNode).

	^ RSBox new
		noPaint;
		border: theBorder;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classNameBoxFor: aClass [ 
	^ RSBox new
		model: aClass;
		color: (aesthetics backgroundColorFor: aClass);
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
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
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
		border: aesthetics innerBorder;
		"markerStart: self marker;"
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultLayout [
	^ RSTreeLayout new
		verticalGap: aesthetics gapFromClassToSubclass;
		horizontalGap: aesthetics gapFromSubclassToSibling;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultMarker [
	^ RSMarker new
		shape: (RSPolygon triangle
			color: aesthetics backgroundColor;
			border: self border;
			size: aesthetics gapFromClassToSubclass / 6;
			yourself);
		offset: aesthetics gapFromClassToSubclass / 12;
		yourself

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultTextColor [
	^ aesthetics foregroundColor
]

{ #category : #accessing }
RiTorchUMLClassRenderer >> highlighingController: aRiHighlighingController [
	highlighingController := aRiHighlighingController
]

{ #category : #accessing }
RiTorchUMLClassRenderer >> isExpanded: aBoolean [
	isExpanded := aBoolean
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodFor: iceNode [
	| shapes |
	shapes := OrderedCollection new.

	iceNode nextNodeSuchThat: [ :each | each value name = #category ]
		ifFound: [:found | shapes add: (self shapeForMethodProperty: found) ].
	shapes ifEmpty: [ 
		shapes add: (RSShapeFactory box 
			width: aesthetics scaleForMethods;
			height: aesthetics scaleForMethods / 1.5;
			color: aesthetics backgroundColor; 
			border: aesthetics innerBorderLowImpact;
			yourself) ].
	
	iceNode nextNodeSuchThat: [ :each | each value name = #source ] ifFound: [:found |
		shapes add: ((self shapeForSourceCode: iceNode)
			model: found;
			border: (aesthetics innerBorderFor: found);
			when: RSMouseClick do: self blockForMouseClickOnIceNode;
			when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
			when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
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

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodsFor: aClass [
	^ (super methodsFor: aClass)
		padding:
			(Margin
				left: 0
				right: 0
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForIceNodeShapes [
	^ RSMorphicPopup new
		morphBuilder: [ :iceNode |
			aesthetics diffMorphFor: iceNode ];
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForTinyClassShapes [
	^ RSPopup new
		shapeBuilder: [ :node | 
			(self shapeForFullClass: node)
				color: aesthetics backgroundColor;
				yourself ];
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForVariableShapes [
	^ RSPopup text: [ :node | 
		'{1} [{2}]' format: { node value definition name. node value definition typeToShow } ]
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> setUpCanvas: aCanvas [

	self addZoomingInteractionOn: aCanvas.
	self addPackInteractionOn: aCanvas.

	aCanvas color: aesthetics backgroundColor.

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> shapeFor: iceNode [
	^ iceNode hasChanges
		ifTrue: [ self shapeForFullClass: iceNode ]
		ifFalse: [ self shapeForTinyClass: iceNode ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForClassProperty: iceNode [
	^ (aesthetics shapeForClassProperty: iceNode)
		model: iceNode;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
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
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForMethodProperty: iceNode [
	^ RSShapeFactory box
		width: aesthetics scaleForMethods;
		height: aesthetics scaleForMethods/1.5;
		model: iceNode;
		border: (aesthetics innerBorderFor: iceNode);
		color: (aesthetics fillColorFor: iceNode);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #hooks }
RiTorchUMLClassRenderer >> shapeForSourceCode: iceNode [
	^ showMethodsLOC
		ifTrue: [ iceNode accept: methodShapeCreatorVisitor ]
		ifFalse: [
			RSBox new
				extent: methodShapeCreatorVisitor widthForMethod asPoint;
				color: (aesthetics fillColorFor: iceNode);
				yourself ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForTinyClass: iceNode [
	^ RSBox new
		noPaint;
		size: 10;
		model: iceNode;
		border: aesthetics tinyBoxBorder;
		addInteraction: self popupForTinyClassShapes;
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> shapeForVariable: iceNode [
	^ (aesthetics shapeForClassVariable: iceNode)
		model: iceNode;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		addInteraction: self popupForVariableShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #accessing }
RiTorchUMLClassRenderer >> showMethodsLOC: aBoolean [
	showMethodsLOC := aBoolean
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> titleFor: model [
	| icon title label shapes |
	icon := aesthetics shapeForDefinition: model value definition.

	label := (RSLabel new
		color: self textColor;
		scaleBy: 1@1.2
		yourself).
	label fontSize: label fontSize * 0.6.
	title := (modelDescriptor classname rsValue: model) asString.
	label text: (RiTextWidthKeeper
		stringFor: title
		font: label font
		maxSize: self classBoxMaxWidth - icon width - 10 "paddings").

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
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
]
