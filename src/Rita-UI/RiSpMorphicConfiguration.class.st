"
I add a few custom styles to the default Spec 2 Morphic configuration.
"
Class {
	#name : 'RiSpMorphicConfiguration',
	#superclass : 'SpMorphicConfiguration',
	#category : 'Rita-UI-Spec2-Base',
	#package : 'Rita-UI',
	#tag : 'Spec2-Base'
}

{ #category : 'styling' }
RiSpMorphicConfiguration >> styleSheet [ 
	^ super styleSheet, (SpStyleSTONReader fromString: '
	.application [
		.ritaNarrow [
			Geometry { #width: 20 }
			],
		.ritaTable [ 
			Geometry { #height: 20 }
			]
	]')
]
