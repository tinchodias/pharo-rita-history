Class {
	#name : #RiHighlightingController,
	#superclass : #RSInteraction,
	#instVars : [
		'canvas',
		'shapeByModel',
		'selectedModel',
		'aesthetics',
		'primaryOutline',
		'secondaryOutlines',
		'shadowByIceNode'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiHighlightingController class >> canvas: aRSCanvas aesthetics: aRiAestheticsModel [
	^ self basicNew
		initializeWithCanvas: aRSCanvas aesthetics: aRiAestheticsModel;
		yourself
]

{ #category : #private }
RiHighlightingController >> addPrimaryOutlineTo: aRSShape [

	aRSShape parent ifNil: [ ^self ]. "Race"
	
	primaryOutline := RSBox new
		border: (RSBorder new 
				joinMiter;
				color: aesthetics outlineColor;
				width: aesthetics outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		yourself.

	"aRSShape when: TSPositionChangedEvent
		do: [ lastOutline position: aRSShape position ]"

	aRSShape parent add: primaryOutline.
	primaryOutline pushBack.

"	camera := canvas camera.
	canvasRect := Rectangle
		rsCenter: camera position
		extent: canvas extent / camera scale.
	(canvasRect intersects: lastOutline encompassingRectangle) ifTrue: [ ^ self].
	
	camera translateTo: lastOutline positionInCanvas."
	


]

{ #category : #private }
RiHighlightingController >> addSecondaryOutlineTo: aRSShape [

	| newOutline |
	self flag: #todo. "Race..."
	aRSShape parent ifNil: [ ^self ].

	newOutline := RSBox new
		border: (RSBorder new 
				joinMiter;
				color: aesthetics secondaryOutlineColor;
				width: aesthetics outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		yourself.

	aRSShape parent add: newOutline.
	newOutline pushBack.

	secondaryOutlines add: newOutline
]

{ #category : #private }
RiHighlightingController >> ensureAddShadowLayerOver: aRSShape [
	shadowByIceNode
		at: aRSShape model
		ifAbsentPut: [
			| shadow |
			shadow := RSBox new
				color: (aesthetics backgroundColor alpha: 0.75);
				extent: aRSShape extent + aesthetics outlineSize;
				position: aRSShape position;
				yourself.
			aRSShape parent add: shadow.
			shadow ]
]

{ #category : #private }
RiHighlightingController >> ensureAddShadowLayerOverAll: iceNodes [ 
	iceNodes do: [ :each |
		shapeByModel at: each ifPresent: [ :shape |
			self ensureAddShadowLayerOver: shape ] ].
	canvas signalUpdate.

]

{ #category : #private }
RiHighlightingController >> ensureRemoveShadowLayerFrom: aShape [
	shadowByIceNode
		at: aShape
		ifPresent: [ :shadowShape | 
			shadowShape remove.
			shadowByIceNode removeKey: aShape ]
]

{ #category : #private }
RiHighlightingController >> ensureRemoveShadowLayerFromAll: iceNodes [ 
	iceNodes do: [ :each |
		shapeByModel at: each ifPresent: [ :shape |
			self ensureRemoveShadowLayerFrom: shape ] ].
	canvas signalUpdate.

]

{ #category : #initialization }
RiHighlightingController >> initializeWithCanvas: aRSCanvas aesthetics: aRiAestheticsModel [
	self initialize.
	canvas := aRSCanvas.
	aesthetics := aRiAestheticsModel.
	shapeByModel := IdentityDictionary new.
	self resetShadowByIceNode.
	self resetSecondaryOutlines
]

{ #category : #hooks }
RiHighlightingController >> onShape: aRSShape [
	^ shapeByModel at: aRSShape model put: aRSShape
]

{ #category : #private }
RiHighlightingController >> removePrimaryOutline [
	primaryOutline ifNotNil: [
		primaryOutline remove.
		primaryOutline := nil ]
]

{ #category : #private }
RiHighlightingController >> removeSecondaryOutlines [
	secondaryOutlines do: #remove.
	self resetSecondaryOutlines
]

{ #category : #private }
RiHighlightingController >> resetSecondaryOutlines [
	secondaryOutlines := OrderedCollection new
]

{ #category : #initialization }
RiHighlightingController >> resetShadowByIceNode [
	shadowByIceNode := IdentityDictionary new
]

{ #category : #public }
RiHighlightingController >> setPrimaryOutlineTo: anIceNode [ 
	self removePrimaryOutline.
	shapeByModel at: anIceNode ifPresent: [ :shape |
		self addPrimaryOutlineTo: shape ].
	canvas signalUpdate.

]

{ #category : #public }
RiHighlightingController >> setSecondaryOutlineToAll: aCollection [ 
	self removeSecondaryOutlines.
	aCollection do: [ :each |
		shapeByModel at: each ifPresent: [ :shape |
			self addSecondaryOutlineTo: shape ] ].
	canvas signalUpdate.

]

{ #category : #public }
RiHighlightingController >> setShadowedIceNodes: iceNodes [
	shadowByIceNode valuesDo: [ :each | each remove ].
	self resetShadowByIceNode.
	self ensureAddShadowLayerOverAll: iceNodes.
]
