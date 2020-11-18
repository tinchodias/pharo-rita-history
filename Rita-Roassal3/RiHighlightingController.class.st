Class {
	#name : #RiHighlightingController,
	#superclass : #RSInteraction,
	#instVars : [
		'canvas',
		'shapeByModel',
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

	"Primary outline has precedence"
	self removeSecondaryOutlines.
	
	primaryOutline := RSBox new
		model: aRSShape;
		border: (RSBorder new 
				joinMiter;
				color: aesthetics outlineColor;
				width: aesthetics outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		yourself.

	"Follow any movement of the target shape"
	aRSShape announcer weak
		when: RSPositionChangedEvent
		send: #ritaUpdatePositionFromModelShape
		to: primaryOutline.

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

	"Primary outline has precedence"
	(primaryOutline notNil and: [ 
		primaryOutline model == aRSShape ])
			ifTrue: [ ^ self ].

	newOutline := RSBox new
		model: aRSShape;
		border: (RSBorder new 
				joinMiter;
				color: aesthetics secondaryOutlineColor;
				width: aesthetics outlineSize;
				yourself);
		noPaint;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		yourself.

	"Follow any movement of the target shape"
	aRSShape announcer weak
		when: RSPositionChangedEvent
		send: #ritaUpdatePositionFromModelShape
		to: newOutline.
"	aRSShape removeInteractionIfPresent: RSLocation.
	RSLocation new stick: newOutline on: aRSShape."

	aRSShape parent add: newOutline.
	newOutline pushBack.

	secondaryOutlines add: newOutline
]

{ #category : #private }
RiHighlightingController >> addTempraryOutlineTo: aRSShape border: aRSBorder [ 

	| newOutline |
	newOutline := RSBox new
		model: aRSShape;
		extent: aRSShape extent + aesthetics outlineSize;
		position: aRSShape position;
		border: aRSBorder;
		noPaint;
		yourself.

	"Follow any movement of the target shape"
	aRSShape announcer weak
		when: RSPositionChangedEvent
		send: #ritaUpdatePositionFromModelShape
		to: newOutline.

	aRSShape parent add: newOutline.
	newOutline pushBack.

	^ newOutline
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

{ #category : #public }
RiHighlightingController >> setTempraryOutlineToAll: aCollection [ 

	| border outlines |
	border := RSBorder new 
		joinMiter;
		color: aesthetics temporaryOutlineColor;
		width: aesthetics outlineSize * 2;
		yourself.

	self flag: #todo. "Why I had to check for nil?"
	outlines := aCollection 
		select: [ :each |
			each parent notNil ] 
		thenCollect: [ :each |
			self addTempraryOutlineTo: each border: border ].

	(canvas newAnimation
		duration: 1.5 seconds;
		from: 1.0; to: 0.0;
		onStepDo: [ :t |
			border color: (aesthetics temporaryOutlineColor alpha: t) ])
		when: RSAnimationEndEvent
			do: [ outlines do: #remove ].
]
