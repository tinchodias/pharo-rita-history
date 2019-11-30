Class {
	#name : #RiHighlightingController,
	#superclass : #Object,
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
"		onMyselfDo: [:behaviorElement | [ :me |
			behaviorElement
				when: TSPositionChangedEvent
				do: [ me position: behaviorElement position ] ] ];"
		yourself.

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

{ #category : #accessing }
RiHighlightingController >> outlineColor [
	^ Smalltalk ui theme selectionColor
]

{ #category : #accessing }
RiHighlightingController >> outlineSize [
	^ 4
]

{ #category : #api }
RiHighlightingController >> registerShape: aRSShape [
	shapeByModel at: aRSShape model put: aRSShape
]

{ #category : #private }
RiHighlightingController >> removeOutline [
	lastOutline ifNotNil: #remove
]
