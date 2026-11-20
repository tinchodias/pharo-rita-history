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

{ #category : 'constants' }
RiSpMorphicConfiguration class >> commitsRowHeight [

	^ 25
]

{ #category : 'constants' }
RiSpMorphicConfiguration >> commitsRowHeight [
	^ self class commitsRowHeight
]

{ #category : 'styling' }
RiSpMorphicConfiguration >> styleSheet [

	^ styleSheet := super styleSheet , (SpStyleVariableSTONReader fromString: '
	.application [
		.ritaNarrow [
			Geometry { #width: 20 }
			],
		.ritaTable [
			Container { #rowHeight: ' , self commitsRowHeight asString , ' }
			]
	]')
]
