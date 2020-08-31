Extension { #name : #String }

{ #category : #'*Rita-PullRequests' }
String >> indexCorrespondingToLineNumber: lineNumber [
	"Answer the character position interval for the given lineNumber."

	| currentLineNumber |
	currentLineNumber := 0.
	
	self lineIndicesDo: [:start :endWithoutDelimiters :end |
		currentLineNumber := currentLineNumber + 1.
		currentLineNumber = lineNumber ifTrue: [ ^ start to: end ]].
	
	NotFound signalFor: lineNumber in: self
]
