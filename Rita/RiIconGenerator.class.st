Class {
	#name : #RiIconGenerator,
	#superclass : #Object,
	#instVars : [
		'canvas',
		'theme'
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
	
	(instances collect: #icon) inspect

]

{ #category : #initialization }
RiIconGenerator >> bordered: shape with: aString [

	canvas add: 
		(shape
			size: self extent;
			noPaint;
			border: (RSBorder new width: 1.5; color: theme textColor);
			yourself).

	canvas add: 
		(RSLabel new
			text: aString;
			bold;
			fontSize: 100;
			position: (0 @ -0.15);
			scaleBy: 0.08;
			color: theme textColor;
			yourself).

]

{ #category : #initialization }
RiIconGenerator >> extent [
	^ 16 @ 16
]

{ #category : #initialization }
RiIconGenerator >> filled: shape with: aString [

	canvas add: 
		(shape
			size: self extent;
			color: theme textColor;
			border: (RSBorder new width: 1.5; color: theme textColor);
			yourself).

	canvas add: 
		(RSLabel new
			text: aString;
			bold;
			fontSize: 100;
			position: (0 @ -0.15);
			scaleBy: 0.08;
			color: theme backgroundColor;
			yourself).

]

{ #category : #initialization }
RiIconGenerator >> icon [
	^ canvas createMorph
		extent: self extent;
		imageForm
]

{ #category : #initialization }
RiIconGenerator >> initialize [
	theme := Smalltalk ui theme.
	canvas := RSCanvas new.
	canvas color: theme backgroundColor
]
