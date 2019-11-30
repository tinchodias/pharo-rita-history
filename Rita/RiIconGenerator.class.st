Class {
	#name : #RiIconGenerator,
	#superclass : #Object,
	#instVars : [
		'theme',
		'extent',
		'foregroundColor',
		'backgroundColor',
		'container'
	],
	#category : #'Rita-Utilities'
}

{ #category : #'as yet unclassified' }
RiIconGenerator class >> examples [
	| shapeSelectors mapping instances |
	shapeSelectors := #(circle diamond square hexagon).

	mapping := {
		#superclassName -> 'S'.
		#category -> 'P'.
		#type -> 'K'.
		#comment -> 'C'.
		#traitComposition -> 'T' 
		} asDictionary.
	
	instances := mapping values flatCollect: [ :letter |
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

{ #category : #drawing }
RiIconGenerator >> bordered: shape with: aString [

	container add: 
		(shape
			size: extent;
			noPaint;
			border: (RSBorder new width: 1.5; color: foregroundColor);
			yourself).

	container add: 
		(RSLabel new
			text: aString;
			bold;
			fontSize: 100;
			position: (0 @ -0.15);
			scaleBy: 0.08;
			color: foregroundColor;
			yourself).

]

{ #category : #accessing }
RiIconGenerator >> container [
	^ container
]

{ #category : #accessing }
RiIconGenerator >> container: anObject [
	container := anObject
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

	container add: 
		(shape
			size: extent;
			color: foregroundColor;
			border: (RSBorder new width: 1.5; color: foregroundColor);
			yourself).

	container add: 
		(RSLabel new
			text: aString;
			bold;
			fontSize: 100;
			position: (0 @ -0.15);
			scaleBy: 0.08;
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
	extent := 16 @ 16.
	theme := Smalltalk ui theme.
	foregroundColor := theme textColor.
	container := RSCanvas new.
	backgroundColor := theme backgroundColor
]

{ #category : #generation }
RiIconGenerator >> newForm [
	^ self newMorph imageForm
]

{ #category : #generation }
RiIconGenerator >> newMorph [
	^ (container
		color: backgroundColor;
		createMorph)
			extent: extent;
			yourself
]

{ #category : #accessing }
RiIconGenerator >> theme [
	^ theme
]

{ #category : #accessing }
RiIconGenerator >> theme: anObject [
	theme := anObject
]
