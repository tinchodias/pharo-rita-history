Class {
	#name : #HiMTopLabelStrategy,
	#superclass : #HiMLabelStrategy,
	#category : #'Rita-Navigator'
}

{ #category : #applying }
HiMTopLabelStrategy >> applyBeforeCreatingElementsWith: aShapeBuilder [

	| labeled |
	labeled := RSLabeled new.
	labeled shape: self shapeBuilder.
	labeled model: [ :element | element model object ].
	aShapeBuilder interaction addInteraction: labeled.
]
