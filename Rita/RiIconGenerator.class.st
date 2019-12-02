Class {
	#name : #RiIconGenerator,
	#superclass : #Object,
	#instVars : [
		'extent',
		'foregroundColor',
		'backgroundColor',
		'border',
		'shapes'
	],
	#category : #'Rita-Utilities'
}

{ #category : #'as yet unclassified' }
RiIconGenerator class >> examples [
	| shapeSelectors instances |
	shapeSelectors := #(circle diamond square hexagon).

	instances := #(S P T) flatCollect: [ :letter |
		shapeSelectors flatCollect: [ :s | {
			self new filled: (RSShape perform: s) with: letter.
			self new bordered: (RSShape perform: s) with: letter.
		} ]].
	
	(instances collect: #newForm) inspect

]

{ #category : #accessing }
RiIconGenerator >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
RiIconGenerator >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #accessing }
RiIconGenerator >> border [
	^ border
]

{ #category : #accessing }
RiIconGenerator >> border: anObject [
	border := anObject
]

{ #category : #drawing }
RiIconGenerator >> bordered: shape with: aString [

	shapes add: 
		(shape
			size: extent;
			noPaint;
			border: (RSBorder new width: 1.5; color: foregroundColor);
			yourself).

	shapes add: 
		((self labelWith: aString)
			color: foregroundColor;
			yourself).

]

{ #category : #accessing }
RiIconGenerator >> extent [
	^ extent
]

{ #category : #accessing }
RiIconGenerator >> extent: anObject [
	extent := anObject
]

{ #category : #drawing }
RiIconGenerator >> filled: shape with: aString [

	shapes add: 
		(shape
			size: extent;
			color: foregroundColor;
			border: border;
"			border: (RSBorder new width: 1.5; color: foregroundColor);"
			yourself).

	shapes add: 
		((self labelWith: aString)
			color: backgroundColor;
			yourself).

]

{ #category : #accessing }
RiIconGenerator >> foregroundColor [
	^ foregroundColor
]

{ #category : #accessing }
RiIconGenerator >> foregroundColor: anObject [
	foregroundColor := anObject
]

{ #category : #initialization }
RiIconGenerator >> initialize [
	| theme |
	theme := Smalltalk ui theme.
	foregroundColor := theme textColor.
	backgroundColor := theme backgroundColor.
	
	extent := 16 @ 16.
	shapes := OrderedCollection new.

]

{ #category : #private }
RiIconGenerator >> labelWith: aString [
	^ RSLabel new
		text: aString;
		bold;
		fontSize: 100;
		position: 0 @ -0.15;
		scaleBy: 0.08;
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
		color: backgroundColor;
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
