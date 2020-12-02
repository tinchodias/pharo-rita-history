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

{ #category : #private }
RiTorchRenderer >> adjustTitle: title on: aGroup [
	super adjustTitle: title on: aGroup.

	title position: title position - (0@1).
	title height: title height - 2.

]

{ #category : #'popup building' }
RiTorchRenderer >> announceAction: aSymbol iceNode: iceNode [

	(model at: #root) announceAction: aSymbol iceNode: iceNode
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

{ #category : #testing }
RiTorchRenderer >> areAllParentsExpanded: iceNode [

	^ iceNode allParentNodes allSatisfy: [ :each | self isExpanded: each ]
]

{ #category : #private }
RiTorchRenderer >> blockForMouseClickOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodeSelected) value: clickEvent shape model ]
]

{ #category : #private }
RiTorchRenderer >> blockForMouseDoubleClickOnIceNode [
	^ [ :clickEvent | (model at: #blockWhenNodeExpandToggle) value: clickEvent shape model ]
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

{ #category : #'shape building' }
RiTorchRenderer >> configuredAsDraggable: aShape [

	^ aShape
		  addInteraction: RSDraggable;
		  yourself
]

{ #category : #'shape building' }
RiTorchRenderer >> configuredWithInteractions: aShape model: iceNode [

	aShape model: iceNode.

	self flag: #todo. "FIX this hack"		
	RiShouldAddInteractions value == false ifTrue: [ ^aShape ].

	^ aShape
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		when: RSMouseEnter do: self blockForMouseEnterOnIceNode;
		when: RSMouseLeave do: self blockForMouseLeaveOnIceNode;
		when: RSMouseDoubleClick do: self blockForMouseDoubleClickOnIceNode;
		addInteraction: (self popupFor: iceNode);
		addInteraction: highlighingController;
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> defaultBoxBorder [
	^ aesthetics classBoxBorder
]

{ #category : #hooks }
RiTorchRenderer >> defaultClassBoxPadding [
	^ aesthetics widthForMethod @ 0
]

{ #category : #hooks }
RiTorchRenderer >> defaultEdgeBuilder [
	^ RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: aesthetics innerBorder;
		markerStart: self marker;
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> defaultMarker [
	^ RSMarker new
		shape: (RSShapeFactory triangle
			color: aesthetics backgroundColor;
			border: self border;
			size: aesthetics gapFromClassToSubclass / 3;
			yourself);
		offset: aesthetics gapFromClassToSubclass / 6;
		yourself

]

{ #category : #hooks }
RiTorchRenderer >> defaultTextColor [
	^ aesthetics foregroundColor
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

{ #category : #testing }
RiTorchRenderer >> isExpanded: iceNode [
	^  (model at: #expandedIceNodes) includes: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> methodFor: iceNode [
	^ self shapeForMethod: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> methodsFor: aClass [
	^ (super methodsFor: aClass)
		padding: aesthetics classRowMargin;
		yourself
]

{ #category : #'popup building' }
RiTorchRenderer >> popupDiffMorphFor: iceNode [
	^ aesthetics popupDiffMorphFor: iceNode
]

{ #category : #'popup building' }
RiTorchRenderer >> popupFor: iceNode [
	^ (self isExpanded: iceNode)
		ifTrue: [ self popupForExpandedNode ]
		ifFalse: [ self popupForCollapsedNode ]

]

{ #category : #'popup building' }
RiTorchRenderer >> popupForCollapsedNode [

	^ RSMorphicPopup new
		gapFromPointer: aesthetics widthForMethod asPoint;
		morphBuilder: [ :iceNode |
			| selector popupContent |
			selector := iceNode value definition accept: RiDetailedPopupHackyVisitor new.

			self flag: #todo. "FIX this hack"
			popupContent := RiShouldAddInteractions
				value: false 
				during: [ self perform: selector with: iceNode ].

			popupContent isMorph
				ifTrue: [ popupContent ]
				ifFalse: [ 
					| canvas extent scale pad hackyOffset |
					scale := 1.2.
					pad := 20@20.
					hackyOffset := -0.5 @ -1.
					extent := popupContent extent * scale.
					canvas := RSCanvas new 
						color: aesthetics backgroundColor;
						add: popupContent;
						yourself.
					canvas camera
						zoomToFit: extent;
						translateTo: canvas camera position + hackyOffset;
						scale: scale.
					canvas createMorph
						extent: extent + pad;
						yourself.
					 ].
			
			 ];
		yourself
]

{ #category : #'popup building' }
RiTorchRenderer >> popupForExpandedNode [
	^ RSMorphicPopup new
		gapFromPointer: aesthetics widthForMethod asPoint;
		morphBuilder: [ :iceNode |
			self announceAction: #torchPopup iceNode: iceNode.
			
			self flag: #todo.
			iceNode value isNoModification
				ifTrue: [
					Morph new extent: 0 asPoint; color: Color transparent; yourself 
					"aesthetics popupNoModificationMorphFor: iceNode" ]
				ifFalse: [ self popupDiffMorphFor: iceNode ].

			 ];
		yourself
]

{ #category : #hooks }
RiTorchRenderer >> shapeFor: iceNode [
	^ self shapeForClass: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> shapeForClass: iceNode [
	^ self configuredAsDraggable: ((self isExpanded: iceNode)
		ifTrue: [
			iceNode hasChanges
				ifTrue: [ self shapeForClassInExpandedMode: iceNode ]
				ifFalse: [ self shapeForClassInTinyMode: iceNode ] ]
		ifFalse: [ self shapeForClassInCollapsedMode: iceNode ])
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassInCollapsedMode: iceNode [
	^ self
		shapeForTitledBox: iceNode
		shapes: { }
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassInExpandedMode: iceNode [
	^ self
		shapeForTitledBox: iceNode
		shapes: {
			self shapeForClassProperties: iceNode.
			self varsFor: iceNode.
			self methodsFor: iceNode }
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassInTinyMode: iceNode [
	^ RSBox new
		noPaint;
		size: aesthetics widthForMethod;
		model: iceNode;
		border: aesthetics tinyBoxBorder;
		addInteraction: self popupForCollapsedNode;
		yourself
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassName: iceNode [
	^ (self classBoxShapeFor: iceNode)
		model: iceNode;
		yourself
		
	"Previous version, with no border but a background color:
	
	RSBox new
		model: iceNode;
		color: (aesthetics backgroundColorFor: iceNode);
		yourself"
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassProperties: iceNode [
	| properties shapes |
	properties := modelDescriptor classProperties rsValue: iceNode.
	shapes := properties collect: [ :each | self shapeForClassProperty: each ].
	self applyVLayoutOn: shapes.

	^ RSComposite new
		shapes: shapes;
		padding: aesthetics classRowMargin;
		yourself
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForClassProperty: iceNode [
	^ self
		configuredWithInteractions: (aesthetics shapeForClassProperty: iceNode)
		model: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> shapeForContentsOfCollapsedClass: iceNode [
	| group |
	group := RSGroup streamContents: [ :stream |
		(modelDescriptor classProperties rsValue: iceNode)
			do: [ :each | stream nextPut: (self shapeForClassProperty: each) ].
		(modelDescriptor instVars rsValue: iceNode)
			do: [ :each | stream nextPut: (self varFor: each) ].
		(modelDescriptor methods rsValue: iceNode)
			do: [ :each | stream nextPut: (self methodFor: each) ] ].

	self applyVLayoutOn: group.
	^ group asShape
		scaleBy: 0.5 asPoint;
		padding: aesthetics classRowMargin;
		yourself
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForContentsOfCollapsedPackage: iceNode [
	
	| shapes |
	shapes := iceNode children collect: [ :each | 
		(self
			configuredWithInteractions: (self shapeForTinyBox: each)
			model: each)
			border: aesthetics innerBorder;
			yourself ].
	self applyVLayoutOn: shapes.

	^ RSComposite new
		shapes: shapes;
		padding: aesthetics classRowMargin;
		yourself

]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForFiles: iceNodes [
	
	| shapes |
	shapes := iceNodes collect: [ :each | 
		(self
			configuredWithInteractions: (self shapeForTinyBox: each)
			model: each)
"			addInteraction: (RSPopup text: [ :node | node path pathString ]);"
			border: aesthetics innerBorder;
			yourself ].
	self applyVLayoutOn: shapes.

	^ RSComposite new
		shapes: shapes;
		padding: aesthetics classRowMargin;
		yourself

]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForFilesBox: iceNodes [

	| aGroup title titleBox outerBox aBorder |
	aBorder := self boxBorder copy color: (aesthetics iceOperationColorVisitor visitNoModification: nil).
	aGroup := self groupFor: { self shapeForFiles: iceNodes }.
	title := self
		titleForString: 'Files'
		icon: (aesthetics shapeForIcon: aesthetics iconForFiles).
	aGroup addFirst: title.
	
	"Distribute vertically"
	RSVerticalLineLayout new gapSize: 0; on: aGroup.
	
	self adjustTitle: title on: aGroup.
	
	aGroup addFirst: (titleBox := RSBox new
		noPaint;
		border: aBorder;
		yourself).
	aGroup addLast: (outerBox := RSBox new
		noPaint;
		border: aBorder;
		yourself).
	self adjustBox: outerBox on: aGroup.
	titleBox
		position: outerBox position x @ (title position y);
		extent: (outerBox width @ (title height)).

	^ self configuredAsDraggable: aGroup asShape
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForMethod: iceNode [
	^ self shapeForMethodInExpandedMode: iceNode

]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForMethodInExpandedMode: iceNode [

	| aGroup sourceBox composite |
	aGroup := OrderedCollection new asGroup. 
	
	iceNode value definition classIsMeta ifTrue: [
		aGroup add: (aesthetics shapeForMethodStereotypeLabeled: 'C') ].
	iceNode value definition isUnitTest ifTrue: [
		aGroup add: (aesthetics shapeForMethodStereotypeLabeled: 'T') ].
	
	sourceBox := iceNode accept: methodShapeCreatorVisitor.
	aGroup add: sourceBox.

	"Distribute vertically"
	RSVerticalLineLayout new gapSize: 0; on: aGroup.

	composite :=
		aGroup asShape
			border: (aesthetics innerBorderFor: iceNode);
			yourself.
	
	^ self configuredWithInteractions: composite model: iceNode
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForPackage: iceNode [

	| outerBox aGroup h |
	aGroup := {
		self titleFor: iceNode.
		outerBox := self classBoxShapeFor: iceNode } asGroup.
	h := (10 + (iceNode allChildren size / 2)) min: 500.
	outerBox
		position: aGroup encompassingRectangle floatCenter;
		extent: aGroup encompassingRectangle extent + (20 @ h).
	^ self configuredAsDraggable: (self
		configuredWithInteractions: aGroup asShape
		model: iceNode)

"	alternative/experimental: 
	^ self
		  shapeForTitledBox: iceNode
		  shapes: { self shapeForContentsOfCollapsedPackage: iceNode }"
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForTinyBox: iceNode [
	^ RSBox new
		extent: methodShapeCreatorVisitor widthForMethod asPoint;
		color: (aesthetics fillColorFor: iceNode);
		yourself
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForTitledBox: iceNode shapes: shapesArray [

	| outerBox title titleBox aGroup |

	"Do some magic to adjust title on top-center"
	aGroup := self groupFor: shapesArray.
	title := self titleFor: iceNode.
	aGroup addFirst: title.
	
	"Distribute vertically"
	RSVerticalLineLayout new gapSize: 0; on: aGroup.
	
	self adjustTitle: title on: aGroup.
	
	aGroup addFirst: (titleBox := self shapeForClassName: iceNode).
	aGroup addLast: (outerBox := self classBoxShapeFor: iceNode).
	self adjustBox: outerBox on: aGroup.
	titleBox
		position: outerBox position x @ title position y;
		extent: outerBox width @ title height.

	^ self 
		configuredWithInteractions: aGroup asShape
		model: iceNode
]

{ #category : #'shape building' }
RiTorchRenderer >> shapeForVariable: iceNode [
	^ self
		configuredWithInteractions: (aesthetics shapeForClassVariable: iceNode)
		model: iceNode
]

{ #category : #hooks }
RiTorchRenderer >> titleFor: iceNode [
	^ self
		titleForString: (modelDescriptor classname rsValue: iceNode) asString
		icon: (aesthetics shapeForDefinition: iceNode value definition)
]

{ #category : #hooks }
RiTorchRenderer >> titleForString: title icon: icon [
	| label shapes |
	label := (RSLabel new
		color: self textColor;
		scaleBy: 1@1.1
		yourself).
	label fontSize: label fontSize * 0.9.
	label text: (RiTextWidthKeeper
		middleTruncationFor: title
		font: label font
		maxSize: self classBoxMaxWidth - icon width - aesthetics widthForMethod "padding").

	shapes := { icon. label }.
	RSHorizontalLineLayout new 
		gapSize: 1;
		alignMiddle;
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
RiTorchRenderer >> varsFor: iceNode [
	^ (super varsFor: iceNode)
		padding: aesthetics classRowMargin;
		yourself
]
