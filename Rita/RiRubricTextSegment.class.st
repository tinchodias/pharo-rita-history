Class {
	#name : #RiRubricTextSegment,
	#superclass : #RubTextSegmentMorph,
	#category : #'Rita-UI-Morphic'
}

{ #category : #drawing }
RiRubricTextSegment >> computeVertices [
	| firstLineIndex lastLineIndex firstLine lastLine verts |
	firstLineIndex := self lineIndexOfCharacterIndex: firstIndex.
	lastLineIndex := self lineIndexOfCharacterIndex: lastIndex.
	firstLine := self lines at: firstLineIndex.
	lastLine := self lines at: lastLineIndex.

	verts := OrderedCollection new.

	verts add: (self textArea left + self margins left) @ firstLine top.
	verts add: (self textArea left + self margins left) @ lastLine bottom.

	verts add: (self textArea right - self margins right) @ lastLine bottom.
	verts add: (self textArea right - self margins right) @ firstLine top.
	self setVertices: verts
]
