Class {
	#name : #RiMethodBitmapCreatorVisitor,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'builder'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #accessing }
RiMethodBitmapCreatorVisitor class >> builder: aBuilder [
	^ self basicNew
		initialize: aBuilder;
		yourself
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> formForJust: anIceChange [
	^ RSBox new
		extent: self widthForMethod @ (self heightForMethod: anIceChange);
		color: (builder foregroundColorFor: anIceChange);
		yourself
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> formForPatchSequence: patchSequence [

	| colorMap scale canvas |
	colorMap := {
		#insert -> Color green darker darker.
		#remove -> Color red darker.
		} asDictionary.

	scale := (self widthForMethod)@(self heightScale).
 	canvas := FormCanvas extent: (1@patchSequence size)*scale.
	patchSequence withIndexDo: [ :each :index |
		colorMap at: each key ifPresent: [ :color |
			| rect |
			rect := 0@(index-1) corner: 1@index.
			canvas fillRectangle: (rect scaleBy: scale) color: color ] ].

	^ RSBitmap new form: (canvas finish; form); yourself
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> heightForMethod: node [
	^ node definition linesOfCode * self heightScale
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> heightScale [
	^ 3
]

{ #category : #initialization }
RiMethodBitmapCreatorVisitor >> initialize: aBuilder [
	self initialize.
	builder := aBuilder
]

{ #category : #visiting }
RiMethodBitmapCreatorVisitor >> visitAddition: anIceAddition [ 
	^ self formForJust: anIceAddition
]

{ #category : #visiting }
RiMethodBitmapCreatorVisitor >> visitModification: anIceModification [
	^ self
		formForPatchSequence:
			(RiTextDiffBuilder
				from: anIceModification rightDefinition sourceCode
				to: anIceModification leftDefinition sourceCode)
				buildPatchSequence
]

{ #category : #visiting }
RiMethodBitmapCreatorVisitor >> visitNoModification: anIceNoModification [ 
	^ self formForJust: anIceNoModification
]

{ #category : #visiting }
RiMethodBitmapCreatorVisitor >> visitRemoval: anIceRemoval [ 
	^ self formForJust: anIceRemoval
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> widthForMethod [
	^ builder scaleForMethods
]
