Class {
	#name : #ZuLineAndSideMapping,
	#superclass : #Object,
	#category : #'Rita-PullRequests-Model'
}

{ #category : #building }
ZuLineAndSideMapping >> mapFrom: from to: to [

	^ self newForPatchSequence:
		  (RiTextDiffBuilder from: from to: to) buildPatchSequence
]

{ #category : #private }
ZuLineAndSideMapping >> newForPatchSequence: aCollection [ 

	| map leftLine rightLine |
	map := OrderedCollection new.
	leftLine := 0.
	rightLine := 0.

	aCollection do: [ :each |
		each key = #insert ifTrue: [
			rightLine := rightLine + 1.
			map add: { rightLine. #RIGHT } ].
		each key = #remove ifTrue: [
			leftLine := leftLine + 1.
			map add: { leftLine. #LEFT } ].
		each key = #match ifTrue: [
			"Both sides advance when there is match"
			leftLine := leftLine + 1.
			rightLine := rightLine + 1.
			"Arbitrary: GitHub v3 defines that review comments in a non-changed line are RIGHT side."
			map add: { rightLine. #RIGHT } ].
		].

	^ map
]
