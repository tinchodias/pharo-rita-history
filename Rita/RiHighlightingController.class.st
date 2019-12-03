Class {
	#name : #RiHighlightingController,
	#superclass : #RSInteraction,
	#instVars : [
		'canvas',
		'shapeByModel',
		'selectedModel',
		'lastOutline',
		'lastSecondaryOutlines'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiHighlightingController class >> newFor: aRSCanvas [
	^ self basicNew
		initializeWith: aRSCanvas;
		yourself
]

{ #category : #private }
RiHighlightingController >> addOutlineFor: aRSShape [

	lastOutline := RSBox new
		border: (RSBorder new 
				joinMiter;
				color: self outlineColor;
				width: self outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + self outlineSize;
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
				color: self secondaryOutlineColor;
				width: self outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + self outlineSize;
		position: aRSShape position;
		yourself.

	aRSShape parent add: outline.
	outline pushBack.

	lastSecondaryOutlines add: outline
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
RiHighlightingController >> initializeWith: aRSCanvas [
	self initialize.
	
	canvas := aRSCanvas.
	shapeByModel := IdentityDictionary new.
	self resetLastSecondaryOutlines.
]

{ #category : #hooks }
RiHighlightingController >> onShape: aRSShape [
	^ shapeByModel at: aRSShape model put: aRSShape
]

{ #category : #accessing }
RiHighlightingController >> outlineColor [
	^ Smalltalk ui theme selectionColor
]

{ #category : #accessing }
RiHighlightingController >> outlineSize [
	^ 5
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

{ #category : #accessing }
RiHighlightingController >> secondaryOutlineColor [
	^ Smalltalk ui theme lightBackgroundColor
]
