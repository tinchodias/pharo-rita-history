"
I represent a mapping between an IceNode and a GitHub Pull Request comment on a Tonel file.
"
Class {
	#name : #RiTonelToDiffMapping,
	#superclass : #RiDiffMapping,
	#category : #'Rita-PullRequests-Model'
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
				iceNode := each.
				iceNodeLineNumber := lineNumber - (parser methodBodyOffsetAtLine: lineNumber).
				iceNodeLineNumber := iceNodeLineNumber + 1. 
				"Fix because of protocol showed in first line"
				^ self ] ]].

	self notYetImplemented
]

{ #category : #'as yet unclassified' }
RiTonelToDiffMapping >> calculateFileLineNumber [

	| contents parser mcDefinition offset |
	contents := file contents.
	parser := RiTonelParser on: contents readStream.
	parser string: file contents.
	[ parser start ]
		on: TonelParseError
		do: [ ^ self notYetImplemented ].

	mcDefinition := iceNode definition asMCDefinition. 
	offset := (parser startingLineForDefinition: mcDefinition).
	lineNumber := iceNodeLineNumber + offset.

]
