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
	#category : #'Rita-Model-Diff'
}

{ #category : #building }
RiUnifiedStringDiff >> build [

	| diffBuilder |
	unifiedString := ''.
	lineJoins := OrderedCollection new.
	
	diffBuilder := RiTextDiffBuilder from: oldString to: newString.
	diffBuilder buildPatchSequence do: [ :patch |
		| start end |
		start := unifiedString size + 1.
		unifiedString := unifiedString, patch value, String cr.
		end := unifiedString size.

		lineJoins add: (RiLinesJoin from: start to: end kind: patch key string: patch value)  ].
	self buildInlineJoins.
]

{ #category : #building }
RiUnifiedStringDiff >> buildInlineJoins [
	| runs runsStream |
	inlineJoins := OrderedCollection new.

	runs := lineJoins groupByRuns: [ :e | e kindSymbol ].
	runsStream := runs readStream.
	[ runsStream atEnd ] whileFalse: [
		| current following inlinePatches removedPart insertedPart |
		current := runsStream next.
		following := runsStream peek.
		(current first kindSymbol = #remove and: [ following isNotNil and: [following first kindSymbol = #insert] ]) ifTrue: [
			removedPart := current flatCollect: [ :each | each diffString, String cr ] as: String.
			insertedPart := following flatCollect: [ :each | each diffString, String cr ] as: String.
			inlinePatches := (InlineTextDiffBuilder from: removedPart to: insertedPart) buildPatchSequence.

			self buildInlineJoins: inlinePatches offset: following first fromIndex reject: #remove add: #insert.
			self buildInlineJoins: inlinePatches offset: current first fromIndex reject: #insert add: #remove.
		]]

]

{ #category : #building }
RiUnifiedStringDiff >> buildInlineJoins: inlinePatches offset: offset reject: aSymbol add: anotherSymbol [ 
	| inlineString |
	inlineString := ''.
	inlinePatches reject: [:patch | patch key = aSymbol ] thenDo: [ :patch |
		| start end |
		start := inlineString size.
		inlineString := inlineString, patch value.
		end := inlineString size.

		patch key = anotherSymbol ifTrue: [
			inlineJoins add: (RiLinesJoin from: offset+start to: offset+end kind: patch key string: patch value) ] ].

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
