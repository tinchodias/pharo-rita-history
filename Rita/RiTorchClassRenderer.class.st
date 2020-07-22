Class {
	#name : #RiTorchClassRenderer,
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
RiTorchClassRenderer class >> model: aModel highlighingController: highlighingController [
	^ self basicNew
		initializeWithModel: aModel
			highlighingController: highlighingController;
		yourself
]

{ #category : #hooks }
RiTorchClassRenderer >> applyMLayoutOn: shapes [
	RSFlowLayout new 
		gapSize: aesthetics gapBetweenMethods;
		maxWidth: self classBoxMaxWidth;
		on: shapes.
]

{ #category : #hooks }
RiTorchClassRenderer >> applyVLayoutOn: shapes [
	self applyMLayoutOn: shapes
]

{ #category : #private }
RiTorchClassRenderer >> blockForMouseClickOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodeSelected) value: clickEvent shape model ]
]

{ #category : #private }
RiTorchClassRenderer >> blockForMouseEnterOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodesHighlighted) value: { clickEvent shape model } ]
]

{ #category : #private }
RiTorchClassRenderer >> blockForMouseLeaveOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodesHighlighted) value: #() ]
]

{ #category : #private }
RiTorchClassRenderer >> classBoxMaxWidth [
	^ (model at: #root) isExpanded
		ifTrue: [ 200 ]
		ifFalse: [ 60 ]

]

{ #category : #hooks }
RiTorchClassRenderer >> classBoxShapeFor: iceNode [
	| theBorder |
	theBorder := self boxBorder copy color: (aesthetics foregroundColorFor: iceNode).

	^ RSBox new
		noPaint;
		border: theBorder;
		yourself
]

{ #category : #hooks }
RiTorchClassRenderer >> classNameBoxFor: aClass [ 
	^ RSBox new
		model: aClass;
		color: (aesthetics backgroundColorFor: aClass);
		yourself
]

{ #category : #hooks }
RiTorchClassRenderer >> classPropertiesFor: iceNode [
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
RiTorchClassRenderer >> defaultBoxBorder [
	^ aesthetics classBoxBorder
]

{ #category : #hooks }
RiTorchClassRenderer >> defaultClassBoxPadding [
	^ aesthetics scaleForMethods @ 0
]

{ #category : #hooks }
RiTorchClassRenderer >> defaultEdgeBuilder [
	^ RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: aesthetics innerBorder;
		"markerStart: self marker;"
		yourself
]

{ #category : #hooks }
RiTorchClassRenderer >> defaultMarker [
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
RiTorchClassRenderer >> defaultTextColor [
	^ aesthetics foregroundColor
]

{ #category : #accessing }
RiTorchClassRenderer >> highlighingController: aRiHighlighingController [
	highlighingController := aRiHighlighingController
]

{ #category : #initialization }
RiTorchClassRenderer >> initializeWith: aDictionary [
	self initialize.
	
	model := aDictionary.
	aesthetics := model at: #aesthetics.
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor aesthetics: aesthetics.
	modelDescriptor := RiTorchModelDescriptor new
]

{ #category : #initialization }
RiTorchClassRenderer >> initializeWithModel: aModel highlighingController: aHighlighingController [
	self initialize.
	
	model := aModel.
	highlighingController := aHighlighingController.
	aesthetics := model at: #aesthetics.
	methodShapeCreatorVisitor := RiMethodShapeCreatorVisitor aesthetics: aesthetics.
	modelDescriptor := RiTorchModelDescriptor new
]

{ #category : #hooks }
RiTorchClassRenderer >> methodFor: iceNode [
	^ self shapeForMethod: iceNode
]

{ #category : #hooks }
RiTorchClassRenderer >> methodsFor: aClass [
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
RiTorchClassRenderer >> popupForIceNodeShapes [
	^ (model at: #root) flyDiff
		ifTrue: [
			RSMorphicPopup new
				morphBuilder: [ :iceNode | aesthetics popupDiffMorphFor: iceNode ];
				yourself ]
		ifFalse: [ RSPopup text: [ :node | node value ritaKey ] ]
]

{ #category : #'private - popup building' }
RiTorchClassRenderer >> popupForTinyClassShapes [
	^ RSPopup new
		shapeBuilder: [ :node | 
			(self shapeForFullClass: node)
				color: aesthetics backgroundColor;
				yourself ];
		yourself
]

{ #category : #'private - popup building' }
RiTorchClassRenderer >> popupForVariableShapes [
	^ RSPopup text: [ :node | 
		'{1} [{2}]' format: { node value definition name. node value definition typeToShow } ]
]

{ #category : #hooks }
RiTorchClassRenderer >> shapeFor: iceNode [
	^ iceNode hasChanges
		ifTrue: [ self shapeForFullClass: iceNode ]
		ifFalse: [ self shapeForTinyClass: iceNode ]
]

{ #category : #'private - shape building' }
RiTorchClassRenderer >> shapeForClassProperty: iceNode [
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
RiTorchClassRenderer >> shapeForFullClass: iceNode [
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
RiTorchClassRenderer >> shapeForMethod: iceNode [
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
RiTorchClassRenderer >> shapeForMethodProperty: iceNode [
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
RiTorchClassRenderer >> shapeForSourceCode: iceNode [
	^ (model at: #root) showMethodsLOC
		ifTrue: [ iceNode accept: methodShapeCreatorVisitor ]
		ifFalse: [
			RSBox new
				extent: methodShapeCreatorVisitor widthForMethod asPoint;
				color: (aesthetics fillColorFor: iceNode);
				yourself ]
]

{ #category : #'private - shape building' }
RiTorchClassRenderer >> shapeForTinyClass: iceNode [
	^ RSBox new
		noPaint;
		size: aesthetics scaleForMethods;
		model: iceNode;
		border: aesthetics tinyBoxBorder;
		addInteraction: self popupForTinyClassShapes;
		yourself
]

{ #category : #'private - shape building' }
RiTorchClassRenderer >> shapeForVariable: iceNode [
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
RiTorchClassRenderer >> titleFor: iceNode [
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
RiTorchClassRenderer >> varFor: iceNode [
	^ self shapeForVariable: iceNode
]

{ #category : #hooks }
RiTorchClassRenderer >> varsFor: model [
	^ (super varsFor: model)
		padding:
			(Margin
				left: 0
				right: 0
				top: aesthetics gapBetweenMethods
				bottom: aesthetics gapBetweenMethods);
		yourself
]
