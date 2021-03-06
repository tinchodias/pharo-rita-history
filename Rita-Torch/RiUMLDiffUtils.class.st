Class {
	#name : #RiUMLDiffUtils,
	#superclass : #Object,
	#category : #'Rita-Torch-Old'
}

{ #category : #accessing }
RiUMLDiffUtils >> maxLabelSize [
	^ 200
]

{ #category : #private }
RiUMLDiffUtils >> shapeForClassOrTrait [

	^ self shapeForNodeEmulatingCondensedFont: false bold: true
]

{ #category : #private }
RiUMLDiffUtils >> shapeForMethod [

	^ self shapeForNodeEmulatingCondensedFont: true bold: false
]

{ #category : #private }
RiUMLDiffUtils >> shapeForNodeEmulatingCondensedFont: isCondensed bold: isBold [

	| iconShape labelShape widthScale |
	widthScale := isCondensed ifTrue: [ 0.8 ] ifFalse: [ 1 ].
	iconShape := RSShapeBuilder bitmap form: #icon.
	labelShape := RSShapeBuilder label
		color: Smalltalk ui theme textColor;
		if: [:node | node value definition isMethodDefinition and: [ node value definition classIsMeta ] ]
			then: [:s | s underline ];
		if: [ isBold ] then: [ :s | s bold ];
		onElement; 
		text: [ :e | RiTextWidthKeeper
			stringFor: e model key
			font: e font
			maxSize: self maxLabelSize * (1/widthScale) ];
		yourself.

	^ RSShapeBuilder composite 
		shapes: [:node | 
			| g icon text |
			g := RSGroup new.
			icon := iconShape elementOn: node value.
			text := labelShape elementOn: node.
			text scaleBy: widthScale@1.
			g add: icon; add: text.
			RSHorizontalLineLayout new alignCenter; gapSize: 2; on: g.
			g ];
		interactionDo: [:i | i popupText: [ :node | node key ] ];
		yourself
]
