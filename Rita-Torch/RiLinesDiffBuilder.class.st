Class {
	#name : #RiLinesDiffBuilder,
	#superclass : #TextDiffBuilder,
	#category : #'Rita-Torch-Utilities'
}

{ #category : #examples }
RiLinesDiffBuilder class >> example1 [

	| diffs diffsByKind |
	diffs := (RiLinesDiffBuilder from: '
	aaa
	b
	cc
	' to: '
	aaa
	d
	e
	f
	cc
	') buildPatchSequence.

	diffsByKind := diffs groupedBy: #key.

	^ {	diffsByKind at: #insert.
			diffsByKind at: #remove }

]

{ #category : #accessing }
RiLinesDiffBuilder >> coolresult [

	^ Array streamContents: [ :stream |
		self 
			patchSequenceDoIfMatch: [ :string :position | stream nextPut: $m ]
			ifInsert: [ :string :position | stream nextPut: $i ]
			ifRemove: [ :string :position | stream nextPut: $d ] 
		]
]

{ #category : #accessing }
RiLinesDiffBuilder >> patchSequenceDoIfMatch: matchBlock ifInsert: insertBlock ifRemove: removeBlock [

	| xLine xLineStream |
	xLineStream := xLines readStream.
	yLines
		doWithIndex: [ :yLine :yIndex |
			yLine hasMatch
				ifFalse: [
					insertBlock cull: yLine string cull: yIndex ]
				ifTrue: [ 
					[ (xLine := xLineStream next) isNil or: [ xLine == yLine match ] ] whileFalse: [ 
						removeBlock cull: xLine string cull: xLineStream position ].
					matchBlock cull: yLine string cull: yIndex ] ].
	[ (xLine := xLineStream next) isNil ] whileFalse: [
		removeBlock cull: xLine string cull: xLineStream position ]

]

{ #category : #accessing }
RiLinesDiffBuilder >> result [

	^ Array streamContents: [ :stream |
		self 
			patchSequenceDoIfMatch: [ :string :position | 1halt. "skip" ]
			ifInsert: [ :string :position | 1halt. ]
			ifRemove: [ :string :position | 1halt. ] 
		]
]

{ #category : #private }
RiLinesDiffBuilder >> split: aString [	
	^ aString lines
]
