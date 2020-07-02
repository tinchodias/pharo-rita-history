"
I'm a Rubric segment that's created with an interval of the text indices and visually marks the whole lines involved be such interval.
"
Class {
	#name : #RiRubricTextSegment,
	#superclass : #RubTextSegmentMorph,
	#category : #'Rita-UI-Morphic'
}

{ #category : #drawing }
RiRubricTextSegment >> computeVertices [
	| firstLineIndex lastLineIndex firstLine lastLine |
	firstLineIndex := self lineIndexOfCharacterIndex: firstIndex.
	lastLineIndex := self lineIndexOfCharacterIndex: lastIndex.
	firstLine := self lines at: firstLineIndex.
	lastLine := self lines at: lastLineIndex.

	self setVertices: {
		firstLine left @ firstLine top.
		firstLine left @ lastLine bottom.
		lastLine right @ lastLine bottom.
		lastLine right @ firstLine top }

]
