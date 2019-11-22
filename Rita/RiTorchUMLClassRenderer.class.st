Class {
	#name : #RiTorchUMLClassRenderer,
	#superclass : #RSTorchUMLClassRenderer,
	#instVars : [
		'blockWhenNodeSelected',
		'innerBorder',
		'methodShapeCreatorVisitor'
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
		alphaMixed: 0.25
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

{ #category : #private }
RiTorchUMLClassRenderer >> builderForClassName [
	| builderForName builderForStereotype theLayout |
	builderForName := self builderForLabel: [:node | node value definition name ] widthScale: 0.9.
	
	builderForStereotype := self builderForStereotype.
	theLayout := RSVerticalLineLayout new gapSize: -1; center; yourself.

	^ RSShapeBuilder composite shapes: [ :aBehavior | 
		| group |
		group := RSGroup new.
		self
			stereotypeFor: aBehavior
			ifPresent: [:stereotype |
				group add: (builderForStereotype elementOn: stereotype) ].

		group add: (builderForName elementOn: aBehavior).
		theLayout on: group.
		group ].
]

{ #category : #private }
RiTorchUMLClassRenderer >> builderForLabel: textBlock widthScale: widthScale [

	^ RSShapeBuilder label
		color: self foregroundColor;
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: (textBlock cull: e model) asString
			font: e font
			maxSize: self maxClassWidth * (1/widthScale)  ];
		scaleBy: widthScale@1;
		onModel;
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> builderForMethodName [

	^ (self builderForLabel: [:node | node value definition selector ] widthScale: self widthScaleForNarrowFontStyle)
		if: [:node | node value definition classIsMeta ] then: [:s | s underline ];
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> builderForSlotName [
	^ (self builderForLabel:[:node | node value definition name ] widthScale: self widthScaleForNarrowFontStyle)
"		if: [:m | m isVariableDefinition and: [ m isClassVariable ] ] then: [ :s | s underline ];"
"		if: [:m | m isVariableDefinition and: [ m isPoolVariable ] ] then: [ :s | s underline ];
		if: [:m | m isVariableDefinition and: [ m isClassInstanceVariable ] ] then: [ :s | s underline ];"
		yourself

]

{ #category : #private }
RiTorchUMLClassRenderer >> builderForStereotype [

	| widthScale |
	widthScale := self widthScaleForNarrowFontStyle.
	
	^ RSShapeBuilder label
		color: self stereotypeColor;
		italic;
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: '« ', e model, ' »'
			font: e font
			maxSize: self maxClassWidth * (1/widthScale) ];
		scaleBy: widthScale;
		onModel;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> classBoxShapeFor: iceNode [
	^ RSBox new
		noPaint;
		border: (self boxBorder copy color: (self foregroundColorFor: iceNode));
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
		width: 2;
		joinMiter; 
		yourself 
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> defaultTextColor [
	^ self foregroundColor
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

{ #category : #private }
RiTorchUMLClassRenderer >> formFrom: from to: to [ 

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

{ #category : #settings }
RiTorchUMLClassRenderer >> gapBetweenHierarchies [
	"Tricky: This gap is expressed as a ratio of the average size of elements. See RSRectanglePackLayout."

	^ 0.3
]

{ #category : #settings }
RiTorchUMLClassRenderer >> gapBetweenMethods [
	^ 5
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

"	self setLayoutVerticalWithMarkers: true."
	self marker shape color: self backgroundColor.
	self marker shape size: self gapFromClassToSubclass / 3.
	self marker offset: self gapFromClassToSubclass / 6.

]

{ #category : #settings }
RiTorchUMLClassRenderer >> maxClassWidth [
	^ 200
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> methodFor: aMethod [
	^ (aMethod accept: methodShapeCreatorVisitor)
		model: aMethod;
		border: innerBorder;
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForMethodIceNodeShape;
		yourself
]

{ #category : #settings }
RiTorchUMLClassRenderer >> outlineSize [
	^ self gapFromSubclassToSibling / 2
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForIceNodeShapes [
	^ RSPopup text: [ :node | node value definition name ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> popupForMethodIceNodeShape [
	^ RSPopup new
		shapeBuilder: [ :node | 
			| form |
			form := self
				formFrom: node value rightContents
				to: node value leftContents.
			RSBitmap new
				form: form;
				border: innerBorder;
				yourself ];
		yourself
]

{ #category : #settings }
RiTorchUMLClassRenderer >> scaleForMethods [
	^ 10
]

{ #category : #options }
RiTorchUMLClassRenderer >> setLayoutVerticalWithMarkers: useMarkers [
	| hierarchyEdgeBuilder |
	hierarchyEdgeBuilder := RSEdgeBuilder orthoVertical
		attachPoint: RSVerticalAttachPoint new;
		border: self border;
		yourself.

	useMarkers ifTrue: [
		hierarchyEdgeBuilder markerStart: self marker ].
				
	self edgeBuilder: hierarchyEdgeBuilder.

	self layout tree
		verticalGap: self gapFromClassToSubclass;
		horizontalGap: self gapFromSubclassToSibling.

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

{ #category : #settings }
RiTorchUMLClassRenderer >> stereotypeColor [
	^ self currentTheme caretColor
]

{ #category : #private }
RiTorchUMLClassRenderer >> stereotypeFor: aBehavior ifPresent: aBlock [
	aBehavior isTrait
		ifTrue: [ ^ aBlock cull: 'trait' ].
	(aBehavior isRingResolved not and: [aBehavior hasMethodExtensions])
		ifTrue: [ ^ aBlock cull: 'extension' ]
]

{ #category : #private }
RiTorchUMLClassRenderer >> tinyClassShapeFor: iceNode [
	^ RSBox new
		noPaint;
		size: 20;
		model: iceNode;
		border: (self boxBorder copy dashArray: #());
		addInteraction: self popupForIceNodeShapes;
		yourself
]

{ #category : #hooks }
RiTorchUMLClassRenderer >> varFor: model [
	^ RSPolygon triangle
		model: model;
		size: self scaleForMethods * 1.3;
		border: innerBorder;
		color: (self foregroundColorFor: model);
		when: RSMouseClick do: self blockForMouseClickOnIceNode;
		addInteraction: self popupForIceNodeShapes;
		yourself
]

{ #category : #settings }
RiTorchUMLClassRenderer >> widthScaleForNarrowFontStyle [
	^ 0.8
]
