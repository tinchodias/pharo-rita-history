Class {
	#name : #RiDiffBuilder,
	#superclass : #TextDiffBuilder,
	#instVars : [
		'linesCount',
		'codeStyler'
	],
	#category : #'Rita-Torch-Utilities'
}

{ #category : #examples }
RiDiffBuilder class >> example1 [
	| srcClass srcString dstString diffBuilder |
	srcClass := Integer.
	srcString := 'lowBit
	"Answer the index of the low order bit of this number."
	| index |
	self = 0 ifTrue: [ ^ 0 ].
	index := 1.
	[ (self byteAt: index) = 0 ]
		whileTrue:
			[ index := index + 1 ].
	^ (self byteAt: index) lowBit + (8 * (index - 1))'.
	dstString := 'lowBit
	"Answer the index of the low order bit of this number."
	| index i |
	self = 0 ifTrue: [ ^ 0 ].
	index := 1.
	[ (self byteAt: index) = 0 ] whileTrue: [ index := index + 1 ].
	^ (self byteAt: index) lowBit + (8 * (index - 1))'.

	diffBuilder := self
		from: srcString
		to: dstString
		inClass: srcClass.
	
	TSBitmap new
		border: (TSBorder new width: 0.1; color: Color black);
		form: diffBuilder asForm;
		width: 10;
		height: 30;
		inspect.
		

]

{ #category : #'as yet unclassified' }
RiDiffBuilder >> asForm [

	| lines colorMap scale canvas |
	lines := self results.
	colorMap := {
		$= -> Color white.
		$+ -> Color green darker darker.
		$- -> Color red darker.
		} asDictionary.

" 	form := Form extent: 1@(lines size) depth: 32.
	lines withIndexDo: [:each :index |
		form colorAt: 0@(index-1) put: (colorMap at: each first) ]."

	scale := 10@5.
 	canvas := FormCanvas extent: (1@lines size)*scale.
	lines withIndexDo: [:each :index |
		| rect |
		rect := 0@(index-1) corner: 1@index.
		canvas fillRectangle: (rect scaleBy: scale) color: (colorMap at: each first) ].

	^ canvas form
]

{ #category : #initialize }
RiDiffBuilder >> from: xString to: yString [
	^ super from: xString to: yString
		"from: (codeStyler style: xString asText)
		to: (codeStyler style: yString asText)"
]

{ #category : #accessing }
RiDiffBuilder >> groupedResults [
	^ self results groupByRuns: [ :e | e first ]
]

{ #category : #initialize }
RiDiffBuilder >> initialize [
	super initialize.
	
	codeStyler := SHRBTextStyler new
]

{ #category : #accessing }
RiDiffBuilder >> results [
	^ Array streamContents: [ :stream |
		self
			patchSequenceDoIfMatch: [ :text | stream nextPut: { $=. text } ]
			ifInsert: [ :text | stream nextPut: { $+. text } ]
			ifRemove: [ :text | stream nextPut: { $-. text } ] ]
]
