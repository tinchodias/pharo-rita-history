Class {
	#name : #RiTorchRenderer,
	#superclass : #RSAbstractUMLClassRenderer,
	#instVars : [
		'methodShapeCreatorVisitor',
		'highlighingController',
		'aesthetics',
		'model'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiTorchRenderer class >> model: aModel highlighingController: highlighingController [
	^ self basicNew
		initializeWithModel: aModel
			highlighingController: highlighingController;
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> applyMLayoutOn: shapes [
	RSFlowLayout new 
		gapSize: aesthetics gapBetweenMethods;
		maxWidth: self classBoxMaxWidth;
		on: shapes.
]

{ #category : #hooks }
RiTorchRenderer >> applyVLayoutOn: shapes [
	self applyMLayoutOn: shapes
]

{ #category : #private }
RiTorchRenderer >> blockForMouseClickOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodeSelected) value: clickEvent shape model ]
]

{ #category : #private }
RiTorchRenderer >> blockForMouseEnterOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodesHighlighted) value: { clickEvent shape model } ]
]

{ #category : #private }
RiTorchRenderer >> blockForMouseLeaveOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodesHighlighted) value: #() ]
]

{ #category : #private }
RiTorchRenderer >> classBoxMaxWidth [
	^ (model at: #root) isExpanded
		ifTrue: [ 200 ]
		ifFalse: [ 60 ]

]

{ #category : #hooks }
RiTorchRenderer >> classBoxShapeFor: iceNode [
	| theBorder |
	theBorder := self boxBorder copy color: (aesthetics foregroundColorFor: iceNode).

	^ RSBox new
		noPaint;
		border: theBorder;
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> classNameBoxFor: aClass [ 
	^ RSBox new
		model: aClass;
		color: (aesthetics backgroundColorFor: aClass);
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> classPropertiesFor: iceNode [
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
RiTorchRenderer >> defaultBoxBorder [
	^ aesthetics classBoxBorder
]

{ #category : #hooks }
RiTorchRenderer >> defaultClassBoxPadding [
	^ aesthetics scaleForMethods @ 0
]

{ #category : #hooks }
RiTorchRenderer >> defaultEdgeBuilder [
	^ RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: aesthetics innerBorder;
		"markerStart: self marker;"
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> defaultMarker [
	^ RSMarker new
		shape: (RSShapeFactory triangle
			color: aesthetics backgroundColor;
			border: self border;
			size: aesthetics gapFromClassToSubclass / 6;
			yourself);
		offset: aesthetics gapFromClassToSubclass / 12;
		yourself

]

{ #category : #hooks }
RiTorchRenderer >> defaultTextColor [
	^ aesthetics foregroundColor
]

{ #category : #accessing }
RiTorchRenderer >> highlighingController: aRiHighlighingController [
	highlighingController := aRiHighlighingController
]

{ #category : #initialization }
RiTorchRenderer >> initializeWith: aDictionary [
	self initialize.
	
	model := aDictionary.
	aesthetics := model at: #aesthetics.
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor aesthetics: aesthetics.
	modelDescriptor := RiTorchModelDescriptor new
]

{ #category : #initialization }
RiTorchRenderer >> initializeWithModel: aModel highlighingController: aHighlighingController [
	self initialize.
	
	model := aModel.
	highlighingController := aHighlighingController.
	aesthetics := model at: #aesthetics.
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor aesthetics: aesthetics.
	modelDescriptor := RiTorchModelDescriptor new
]

{ #category : #hooks }
RiTorchRenderer >> methodFor: iceNode [
	^ self shapeForMethod: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> methodsFor: aClass [
	^ (super methodsFor: aClass)
		padding:
			(Margin
				left: 0
				right: 0
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
]

{ #category : #'private - popup building' }
RiTorchRenderer >> popupForIceNodeShapes [
	^ (model at: #root) flyDiff
		ifTrue: [
			RSMorphicPopup new
				morphBuilder: [ :iceNode | aesthetics popupDiffMorphFor: iceNode ];
				yourself ]
		ifFalse: [ RSPopup text: [ :node | node value ritaKey ] ]
]

{ #category : #'private - popup building' }
RiTorchRenderer >> popupForTinyClassShapes [
	^ RSPopup new
		shapeBuilder: [ :node | 
			(self shapeForFullClass: node)
				color: aesthetics backgroundColor;
				yourself ];
		yourself
]

{ #category : #'private - popup building' }
RiTorchRenderer >> popupForVariableShapes [
	^ RSPopup text: [ :node | 
		'{1} [{2}]' format: { node value definition name. node value definition typeToShow } ]
]

{ #category : #hooks }
RiTorchRenderer >> shapeFor: iceNode [
	^ iceNode hasChanges
		ifTrue: [ self shapeForFullClass: iceNode ]
		ifFalse: [ self shapeForTinyClass: iceNode ]
]

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForClassProperty: iceNode [
	^ (aesthetics shapeForClassProperty: iceNode)
		model: iceNode;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForFullClass: iceNode [
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

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForMethod: iceNode [
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

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForMethodProperty: iceNode [
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

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForSourceCode: iceNode [
	^ (model at: #root) showMethodsLOC
		ifTrue: [ iceNode accept: methodShapeCreatorVisitor ]
		ifFalse: [
			RSBox new
				extent: methodShapeCreatorVisitor widthForMethod asPoint;
				color: (aesthetics fillColorFor: iceNode);
				yourself ]
]

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForTinyClass: iceNode [
	^ RSBox new
		noPaint;
		size: aesthetics scaleForMethods;
		model: iceNode;
		border: aesthetics tinyBoxBorder;
		addInteraction: self popupForTinyClassShapes;
		yourself
]

{ #category : #'private - shape building' }
RiTorchRenderer >> shapeForVariable: iceNode [
	^ (aesthetics shapeForClassVariable: iceNode)
		model: iceNode;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		addInteraction: self popupForVariableShapes;
		addInteraction: highlighingController;
		yourself

]

{ #category : #hooks }
RiTorchRenderer >> titleFor: iceNode [
	| icon title label shapes |
	icon := aesthetics shapeForDefinition: iceNode value definition.

	label := (RSLabel new
		color: self textColor;
		scaleBy: 1@1.2
		yourself).
	label fontSize: label fontSize * 0.6.
	title := (modelDescriptor classname rsValue: iceNode) asString.
	label text: (RiTextWidthKeeper
		middleTruncationFor: title
		font: label font
		maxSize: self classBoxMaxWidth - icon width - aesthetics scaleForMethods "padding").

	shapes := { icon. label }.
	RSHorizontalLineLayout new 
		gapSize: 1;
		alignCenter;
		on: shapes.
	
	^ RSComposite new
		shapes: shapes;
		padding: 0@4;
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> varFor: iceNode [
	^ self shapeForVariable: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> varsFor: model [
	^ (super varsFor: model)
		padding:
			(Margin
				left: 0
				right: 0
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
]
