Class {
	#name : #RiHighlightingController,
	#superclass : #RSInteraction,
	#instVars : [
		'canvas',
		'shapeByModel',
		'selectedModel',
		'lastOutline',
		'lastSecondaryOutlines',
		'aesthetics'
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
RiHighlightingController >> addOutlineFor: aRSShape [

	lastOutline := RSBox new
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

	aRSShape parent add: lastOutline.
	lastOutline pushBack.

"	camera := canvas camera.
	canvasRect := Rectangle
		rsCenter: camera position
		extent: canvas extent / camera scale.
	(canvasRect intersects: lastOutline encompassingRectangle) ifTrue: [ ^ self].
	
	camera translateTo: lastOutline positionInCanvas."
	


]

{ #category : #private }
RiHighlightingController >> addSecondaryOutlineFor: aRSShape [

	| outline |
	outline := RSBox new
		border: (RSBorder new 
				joinMiter;
				color: aesthetics secondaryOutlineColor;
				width: aesthetics outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		yourself.

	aRSShape parent add: outline.
	outline pushBack.

	lastSecondaryOutlines add: outline
]

{ #category : #private }
RiHighlightingController >> addShadowLayerTo: aRSShape [
"	| shadow | 
	shadow := RSBox new
		color: (aesthetics backgroundColor alpha: 0.75);
		extent: aRSShape extent + self outlineSize;
		yourself.

	aRSShape parent add: shadow.
	
	lastShadows add: shadow.
"
]

{ #category : #api }
RiHighlightingController >> highlightAsSecondary: aCollection [ 

	self removeSecondaryOutlines.
	aCollection do: [ :each |
		shapeByModel at: each ifPresent: [ :shape |
			self addSecondaryOutlineFor: shape ] ].
	canvas signalUpdate.

]

{ #category : #api }
RiHighlightingController >> highlightAsSelected: anIceNode [ 

	self removeOutline.
	shapeByModel at: anIceNode ifPresent: [ :shape |
		self addOutlineFor: shape ].
	canvas signalUpdate.

]

{ #category : #initialization }
RiHighlightingController >> initializeWithCanvas: aRSCanvas aesthetics: aRiAestheticsModel [
	self initialize.
	canvas := aRSCanvas.
	aesthetics := aRiAestheticsModel.
	shapeByModel := IdentityDictionary new.
	self resetLastSecondaryOutlines
]

{ #category : #hooks }
RiHighlightingController >> onShape: aRSShape [
	^ shapeByModel at: aRSShape model put: aRSShape
]

{ #category : #private }
RiHighlightingController >> removeOutline [
	lastOutline ifNotNil: #remove
]

{ #category : #private }
RiHighlightingController >> removeSecondaryOutlines [
	lastSecondaryOutlines do: #remove.
	self resetLastSecondaryOutlines
]

{ #category : #private }
RiHighlightingController >> resetLastSecondaryOutlines [
	lastSecondaryOutlines := OrderedCollection new
]
