Class {
	#name : #RiHighlightingController,
	#superclass : #RSInteraction,
	#instVars : [
		'canvas',
		'shapeByModel',
		'selectedModel',
		'lastOutline'
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
	^ 4
]

{ #category : #private }
RiHighlightingController >> removeOutline [
	lastOutline ifNotNil: #remove
]
