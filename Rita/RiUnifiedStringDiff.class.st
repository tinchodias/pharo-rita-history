Class {
	#name : #RiUnifiedStringDiff,
	#superclass : #Object,
	#instVars : [
		'lineJoins',
		'unifiedString',
		'oldString',
		'newString',
		'inlineJoins'
	],
	#category : #'Rita-Diffmodel'
}

{ #category : #building }
RiUnifiedStringDiff >> build [

	| diffBuilder |
	unifiedString := ''.
	lineJoins := OrderedCollection new.
	
	diffBuilder := TextDiffBuilder from: oldString to: newString.
	diffBuilder buildPatchSequence do: [ :patch |
		| start end |
		start := unifiedString size + 1.
		unifiedString := unifiedString, patch value, String cr.
		end := unifiedString size.

		lineJoins add: (RiLinesJoin new rawfrom: start; rawto: end; rawpatch: patch; yourself) ].
	self buildInlineJoins.
]

{ #category : #building }
RiUnifiedStringDiff >> buildInlineJoins [
	| runs runsStream |
	inlineJoins := OrderedCollection new.

	runs := lineJoins groupByRuns: [ :e | e rawkind ].
	runsStream := runs readStream.
	[ runsStream atEnd ] whileFalse: [
		| current following inlinePatches removedString insertedString inlineString offset |
		current := runsStream next.
		following := runsStream peek.
		(current first rawkind = #insert and: [ following first rawkind = #remove ]) ifTrue: [
			removedString := following flatCollect: [ :each | each rawstring, String cr ] as: String.
			insertedString := current  flatCollect: [ :each | each rawstring, String cr ] as: String.

			offset := current first rawfrom.
			
			inlineString := ''.
			inlinePatches := (InlineTextDiffBuilder from: removedString to: insertedString) buildPatchSequence.
			inlinePatches do: [ :patch |
				| start end |
				start := inlineString size + 1.
				inlineString := inlineString, patch value, String space.
				end := inlineString size.

				inlineJoins add: (RiLinesJoin new rawfrom: offset+start; rawto: offset+end; rawpatch: patch; yourself) ].
			]
		
		]

]

{ #category : #accessing }
RiUnifiedStringDiff >> inlineJoins [
	^ inlineJoins
]

{ #category : #accessing }
RiUnifiedStringDiff >> lineJoins [
	^ lineJoins
]

{ #category : #accessing }
RiUnifiedStringDiff >> newString: anObject [
	newString := anObject
]

{ #category : #accessing }
RiUnifiedStringDiff >> oldString: anObject [
	oldString := anObject
]

{ #category : #accessing }
RiUnifiedStringDiff >> unifiedString [
	^ unifiedString
]
