Class {
	#name : #RiIconGenerator,
	#superclass : #Object,
	#instVars : [
		'extent',
		'foregroundColor',
		'backgroundColor',
		'border',
		'shapes',
		'labelScale'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #examples }
RiIconGenerator class >> examples [
	| shapeSelectors instances textColor backColor |
	textColor := Smalltalk ui theme textColor.
	backColor := Smalltalk ui theme backgroundColor.
	
	shapeSelectors := #(circle diamond square hexagon).

	instances := #(S P T) flatCollect: [ :letter |
		shapeSelectors flatCollect: [ :s |
			| shape |
			shape := RSShapeFactory perform: s.
			{
			self new
				addFilled: shape color: textColor;
				addLabel: letter color: backColor;
				yourself.
			self new
				addBordered: shape color: textColor;
				addLabel: letter color: textColor;
				yourself.
			} ]].
	
	(instances collect: #newForm) inspect

]

{ #category : #drawing }
RiIconGenerator >> addBordered: aRSShape color: aColor [

	shapes add: 
		(aRSShape
			size: (extent - 1 asPoint);
			noPaint;
			border: (RSBorder new width: 1; color: aColor);
			yourself)

]

{ #category : #drawing }
RiIconGenerator >> addFilled: aRSShape color: aColor [

	shapes add: 
		(aRSShape
			size: extent;
			color: aColor;
			border: border;
			yourself)

]

{ #category : #drawing }
RiIconGenerator >> addLabel: aString color: aColor [

	shapes add: 
		((self labelWith: aString)
			color: aColor;
			yourself).

]

{ #category : #accessing }
RiIconGenerator >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
RiIconGenerator >> backgroundColor: aColor [
	backgroundColor := aColor
]

{ #category : #accessing }
RiIconGenerator >> border [
	^ border
]

{ #category : #accessing }
RiIconGenerator >> border: aRSBorder [
	border := aRSBorder
]

{ #category : #accessing }
RiIconGenerator >> extent [
	^ extent
]

{ #category : #accessing }
RiIconGenerator >> extent: aPoint [
	extent := aPoint
]

{ #category : #accessing }
RiIconGenerator >> foregroundColor [
	^ foregroundColor
]

{ #category : #accessing }
RiIconGenerator >> foregroundColor: aColor [
	foregroundColor := aColor
]

{ #category : #initialization }
RiIconGenerator >> initialize [
	| theme |
	theme := Smalltalk ui theme.
	foregroundColor := theme textColor.
	backgroundColor := theme backgroundColor.
	
	extent := 16 @ 16.
	shapes := OrderedCollection new.
	labelScale := 0.08.
]

{ #category : #accessing }
RiIconGenerator >> labelScale [
	^ labelScale
]

{ #category : #accessing }
RiIconGenerator >> labelScale: aFloat [
	labelScale := aFloat
]

{ #category : #private }
RiIconGenerator >> labelWith: aString [
	^ RSLabel new
		text: aString;
		bold;
		fontSize: 100;
		position: 0 @ -0.15;
		scaleBy: labelScale;
		extent: 1@1; "Important: fonts may exceed the height of the icon"
		yourself
]

{ #category : #generation }
RiIconGenerator >> newForm [
	^ self newMorph imageForm
]

{ #category : #generation }
RiIconGenerator >> newMorph [
	^ self newRSCanvas createMorph
		extent: extent;
		yourself
]

{ #category : #generation }
RiIconGenerator >> newRSCanvas [
	^ RSCanvas new
		shapes: shapes;
		color: Color transparent;
		yourself
]

{ #category : #generation }
RiIconGenerator >> newRSComposite [
	^ RSComposite new
		shapes: shapes;
		color: backgroundColor;
		yourself
]

{ #category : #accessing }
RiIconGenerator >> shapes [
	^ shapes
]
