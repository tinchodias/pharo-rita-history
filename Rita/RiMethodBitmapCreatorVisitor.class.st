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

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> formForJust: anIceChange [
	| canvas |
	canvas := FormCanvas extent:  (builder widthForMethod: anIceChange) @ (builder heightForMethod: anIceChange).
	canvas fillColor: (builder foregroundColorFor: anIceChange).
	^ canvas finish; form
]

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> formForPatchSequence: patchSequence [

	| colorMap scale canvas |
	colorMap := {
		#insert -> Color green darker darker.
		#remove -> Color red darker.
		} asDictionary.

	scale := (builder widthForMethod: nil)@3.
 	canvas := FormCanvas extent: (1@patchSequence size)*scale.
	patchSequence withIndexDo: [ :each :index |
		colorMap at: each key ifPresent: [ :color |
			| rect |
			rect := 0@(index-1) corner: 1@index.
			canvas fillRectangle: (rect scaleBy: scale) color: color ] ].

	^ canvas finish; form
]

{ #category : #accessing }
RiMethodBitmapCreatorVisitor >> initialize: aBuilder [
	self initialize.
	builder := aBuilder
]

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> visitAddition: anIceAddition [ 
	^ self formForJust: anIceAddition
]

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> visitModification: anIceModification [
	^ self
		formForPatchSequence:
			(RiTextDiffBuilder
				from: anIceModification rightDefinition sourceCode
				to: anIceModification leftDefinition sourceCode)
				buildPatchSequence
]

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> visitNoModification: anIceNoModification [ 
	^ self formForJust: anIceNoModification
]

{ #category : #'as yet unclassified' }
RiMethodBitmapCreatorVisitor >> visitRemoval: anIceRemoval [ 
	^ self formForJust: anIceRemoval
]
