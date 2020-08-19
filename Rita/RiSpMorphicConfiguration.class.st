"
I add a few custom styles to the default Spec 2 Morphic configuration.
"
Class {
	#name : #RiSpMorphicConfiguration,
	#superclass : #SpMorphicConfiguration,
	#category : #'Rita-UI'
}

{ #category : #styling }
RiSpMorphicConfiguration >> styleSheet [ 
	^ super styleSheet, (SpStyleSTONReader fromString: '
	.application [
		.ritaNarrow [
			Geometry { #width: 20 }
		]
	]')
]
