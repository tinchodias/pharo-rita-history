Class {
	#name : #RiTonelToDiffMapping,
	#superclass : #RiDiffMapping,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #mapping }
RiTonelToDiffMapping >> calculate [
	| contents parser mcDefinition |
	contents := file contents.
	parser := RiTonelParser on: contents readStream.
	parser string: file contents.
	[ parser start ]
		on: TonelParseError
		do: [ ^ self notYetImplemented ].
	mcDefinition := parser definitionAtLine: lineNumber.

	self flag: #todo.
	iceDiff tree allChildrenDo: [ :each |
		(each value definition isMethodDefinition) and: [
		each value definition asMCDefinition description = mcDefinition description
			ifTrue: [
				iceNode := each children second.
				iceNodeLineNumber := lineNumber - (parser methodBodyOffsetAtLine: lineNumber).
				^ self ] ]].

	self notYetImplemented
]