Class {
	#name : #RiTorchUMLClassRenderer,
	#superclass : #RSTorchUMLClassRenderer,
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
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		yourself
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

{ #category : #settings }
RiTorchUMLClassRenderer >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.3
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

{ #category : #private }
RiTorchUMLClassRenderer >> methodDiffFormFrom: from to: to [ 

	| presenter font |
	presenter := RiUnifiedDiffPresenter new
		buildWithSpec;
		model: { #from -> from. #to -> to } asDictionary;
		yourself.
			
	font := LogicalFont 
		familyName: StandardFonts codeFont familyName
		pointSize: 7.

	^ presenter theWidget
		font: font;
		extent: 300@350;
		scrollbarsShowNever;
		imageForm.
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodFor: aMethod [
	^ (aMethod accept: methodShapeCreatorVisitor)
		model: aMethod;
		border: innerBorder;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		yourself
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForIceNodeShapes [
	^ RSPopup new
		shapeBuilder: [ :node | 
			| form |
			form := self
				methodDiffFormFrom: node value rightContents
				to: node value leftContents.
			RSBitmap new
				form: form;
				border: innerBorder;
				yourself ];
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
			(super shapeFor: iceNode)
				when: RSMouseClick do: self blockForMouseClickOnIceNode;
				removeInteractionIfPresent: RSPopup;
				addInteraction: self popupForIceNodeShapes;
				yourself ]
		ifFalse: [ self tinyClassShapeFor: iceNode ]
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
	currentTitleWidth := label textWidth.
	^ label
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varFor: model [
	^ RSPolygon triangle
		model: model;
		size: self scaleForMethods * 1.3;
		border: innerBorder;
		color: (self fillColorFor: model);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForVariableShapes;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varsFor: model [
	^ (super varsFor: model)
		padding:
			(Margin
				left: 0
				right: 0
				top: 3
				bottom: 0);
		yourself
]
