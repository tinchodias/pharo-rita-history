Class {
	#name : #RiMethodShapeCreatorVisitor,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'colorMap',
		'renderer'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #accessing }
RiMethodShapeCreatorVisitor class >> builder: aBuilder [
	^ self basicNew
		initialize: aBuilder;
		yourself
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> heightForMethod: node [
	^ node definition linesOfCode * self heightScale
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> heightScale [
	^ 3
]

{ #category : #initialization }
RiMethodShapeCreatorVisitor >> initialize: aRenderer [
	self initialize.
	renderer := aRenderer.
	colorMap := {
		#insert -> renderer insertColor.
		#remove -> renderer removeColor.
		} asDictionary.


]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> newForPatchSequence: patchSequence [

	| scale canvas |
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
RiMethodShapeCreatorVisitor >> newForPlain: anIceChange [
	^ RSBox new
		extent: self widthForMethod @ (self heightForMethod: anIceChange);
		color: (renderer fillColorFor: anIceChange);
		yourself
]

{ #category : #visiting }
RiMethodShapeCreatorVisitor >> visitAddition: anIceAddition [ 
	^ self newForPlain: anIceAddition
]

{ #category : #visiting }
RiMethodShapeCreatorVisitor >> visitModification: anIceModification [
	^ self
		newForPatchSequence:
			(RiTextDiffBuilder
				from: anIceModification rightDefinition sourceCode
				to: anIceModification leftDefinition sourceCode)
				buildPatchSequence
]

{ #category : #visiting }
RiMethodShapeCreatorVisitor >> visitNoModification: anIceNoModification [ 
	^ self newForPlain: anIceNoModification
]

{ #category : #visiting }
RiMethodShapeCreatorVisitor >> visitRemoval: anIceRemoval [ 
	^ self newForPlain: anIceRemoval
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> widthForMethod [
	^ renderer scaleForMethods
]
