Class {
	#name : #LinesDiffBuilder,
	#superclass : #TextDiffBuilder,
	#category : #'Rita-IceTip-DiffBuilder'
}

{ #category : #private }
LinesDiffBuilder >> split: aString [	
	^ aString lines
]
