"
I extend my superclass with the sole purpose of showing line removals before line insertion, in the case of a text modification. This is the more common way of showing unified text diffs in nowadays tools: green lines below red lines.

"
Class {
	#name : #RiTextDiffBuilder,
	#superclass : #TextDiffBuilder,
	#category : #'Rita-Diff'
}

{ #category : #'creating patches' }
RiTextDiffBuilder >> buildPatchSequence [
	"Adapt superclass implementation to the fact that x and y strings are inverted."
	
	^ Array streamContents: [ :stream | 
		self
			patchSequenceDoIfMatch: [ :string | stream nextPut: #match -> string ]
			ifInsert: [ :string | stream nextPut: #remove -> string ]
			ifRemove: [ :string | stream nextPut: #insert -> string ] ]
]

{ #category : #'creating patches' }
RiTextDiffBuilder >> from: xString to: yString [
	"Invert the strings. See #buildPatchSequence."

	super from: yString to: xString
]
