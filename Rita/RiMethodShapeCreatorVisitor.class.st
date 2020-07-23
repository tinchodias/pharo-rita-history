Class {
	#name : #RiMethodShapeCreatorVisitor,
	#superclass : #IceTreeVisitor,
	#instVars : [
		'colorMap',
		'aesthetics'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiMethodShapeCreatorVisitor class >> aesthetics: anObject [
	^ self basicNew
		initialize: anObject;
		yourself
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> heightForMethod: node [
	^ node definition containerIceDefinition linesOfCode * self heightScale
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> heightScale [
	^ 3
]

{ #category : #initialization }
RiMethodShapeCreatorVisitor >> initialize: aRiAestheticsModel [
	self initialize.
	aesthetics := aRiAestheticsModel.

	self flag: #fix.

	colorMap := {
		#insert -> ((aesthetics visitAddition: nil) "alpha: 0.5").
		#remove -> ((aesthetics visitRemoval: nil) "alpha: 0.5").
		} asDictionary
]

{ #category : #accessing }
RiMethodShapeCreatorVisitor >> newForPatchSequence: patchSequence [

	| scale canvas |
	scale := self widthForMethod @ self heightScale.
 	canvas := FormCanvas extent: (1 @ patchSequence size) * scale.
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
		color: (aesthetics fillColorFor: anIceChange);
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
				from: anIceModification rightDefinition containerIceDefinition sourceCode
				to: anIceModification leftDefinition containerIceDefinition sourceCode)
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
	^ aesthetics widthForMethod
]
