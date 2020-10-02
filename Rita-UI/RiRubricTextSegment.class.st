"
I'm a Rubric segment that's created with an interval of the text indices and visually marks the whole lines involved be such interval.
"
Class {
	#name : #RiRubricTextSegment,
	#superclass : #RubTextSegmentMorph,
	#category : #'Rita-UI-Support'
}

{ #category : #drawing }
RiRubricTextSegment >> computeVertices [
	| firstLineIndex lastLineIndex firstLine lastLine |
	firstLineIndex := self lineIndexOfCharacterIndex: firstIndex.
	lastLineIndex := self lineIndexOfCharacterIndex: lastIndex.
	firstLine := self lines at: firstLineIndex.
	lastLine := self lines at: lastLineIndex.

	self setVertices: {
		self textArea left @ firstLine top.
		self textArea left @ lastLine bottom.
		self textArea right @ lastLine bottom.
		self textArea right @ firstLine top }

]
