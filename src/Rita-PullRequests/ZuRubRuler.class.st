Class {
	#name : #ZuRubRuler,
	#superclass : #RubTextSegmentIconDisplayer,
	#instVars : [
		'hoveredLineNumber',
		'clickActionBlock',
		'hoveredLineIcon'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #'event handling' }
ZuRubRuler >> changed [

	super changed.
	"self textArea changed.   --> why this makes hoveredIcon to mirror?"

]

{ #category : #accessing }
ZuRubRuler >> clickActionBlock [

	^ clickActionBlock
]

{ #category : #accessing }
ZuRubRuler >> clickActionBlock: aBlockBlosure [

	clickActionBlock := aBlockBlosure
]

{ #category : #private }
ZuRubRuler >> clickedLineAt: lineIndex [

	"| line |
	line := self lines at: lineIndex."

	clickActionBlock value: lineIndex
]

{ #category : #drawing }
ZuRubRuler >> drawHoveredLineIconOn: aCanvas [

	| icon line  position|
	icon := self hoveredLineIcon.
	line := self lines at: hoveredLineNumber.

	position := (aCanvas clipRect origin + line topLeft) - (3@0).

	aCanvas translucentImage: icon at: position.

]

{ #category : #drawing }
ZuRubRuler >> drawHoveredLineIconOnAthensCanvas: aCanvas [

	| icon line |
	icon := self hoveredLineIcon.
	line := self lines at: hoveredLineNumber.

	aCanvas pathTransform
		restoreAfter: [ 
"			aCanvas paintOptions composeOver."
			aCanvas setPaint: icon.
			aCanvas pathTransform translateBy: line topLeft.
			aCanvas drawShape: icon boundingBox ].

]

{ #category : #drawing }
ZuRubRuler >> drawOn: aCanvas [

	super drawOn: aCanvas.
	self paragraph lines ifNil: [ ^ self ].

	aCanvas
		clipBy: self bounds
		during: [ :clippedCanvas | 
			| visibleRectangle tl br |
			visibleRectangle := clippedCanvas clipRect.
			tl := self lineIndexForPoint: visibleRectangle topLeft.
			br := self lineIndexForPoint: visibleRectangle bottomRight.
			((tl to: br) includes: hoveredLineNumber) ifTrue: [
				self drawHoveredLineIconOn: aCanvas ] ]

]

{ #category : #drawing }
ZuRubRuler >> drawOnAthensCanvas: anAthensCanvas [

	super drawOnAthensCanvas: anAthensCanvas.
	self paragraph lines ifNil: [ ^ self ].

	anAthensCanvas
		clipBy: self bounds
		during: [ 
			| visibleRectangle tl br |
			visibleRectangle := anAthensCanvas clipRect.
			tl := self lineIndexForPoint: visibleRectangle topLeft.
			br := self lineIndexForPoint: visibleRectangle bottomRight.
			((tl to: br) includes: hoveredLineNumber) ifTrue: [
				self drawHoveredLineIconOnAthensCanvas: anAthensCanvas ] ]

]

{ #category : #drawing }
ZuRubRuler >> hoveredLineIcon [

	^ hoveredLineIcon
]

{ #category : #accessing }
ZuRubRuler >> hoveredLineIcon: aForm [

	hoveredLineIcon := aForm
]

{ #category : #'event handling' }
ZuRubRuler >> mouseDown: anEvent [

	anEvent redButtonChanged ifTrue: [
		| lineIndex |
		lineIndex := self lineIndexForPoint: anEvent position.
		self clickedLineAt: lineIndex ].

	^ super mouseDown: anEvent

]

{ #category : #'event handling' }
ZuRubRuler >> mouseLeave: anEvent [

	hoveredLineNumber := nil.
	self changed.

	^ super mouseLeave: anEvent
]

{ #category : #'event handling' }
ZuRubRuler >> mouseMove: anEvent [

	| newHoveredLineNumber |
	newHoveredLineNumber := self lineIndexForPoint: anEvent position.

	newHoveredLineNumber = hoveredLineNumber ifFalse: [ 
		hoveredLineNumber := newHoveredLineNumber.
		self changed ].
	
	^ super mouseMove: anEvent

]
