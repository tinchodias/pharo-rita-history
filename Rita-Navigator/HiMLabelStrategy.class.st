Class {
	#name : #HiMLabelStrategy,
	#superclass : #Object,
	#instVars : [
		'navigator',
		'shapeBuilder'
	],
	#category : #'Rita-Navigator-UI'
}

{ #category : #applying }
HiMLabelStrategy >> applyAfterAddingElements: elements [
]

{ #category : #applying }
HiMLabelStrategy >> applyBeforeCreatingElementsWith: shapeBuilder [

]

{ #category : #accessing }
HiMLabelStrategy >> navigator [
	^ navigator
]

{ #category : #accessing }
HiMLabelStrategy >> navigator: anObject [
	navigator := anObject
]

{ #category : #accessing }
HiMLabelStrategy >> shapeBuilder [
	^ shapeBuilder ifNil: [ 
		shapeBuilder := RSShapeBuilder label
			color: (navigator currentTheme textColor alpha: 0.75);
			scaleBy: 0.15;
			yourself ]
]

{ #category : #accessing }
HiMLabelStrategy >> shapeBuilder: aShapeBuilder [
	shapeBuilder := aShapeBuilder
]
