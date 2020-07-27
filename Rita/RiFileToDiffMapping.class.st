Class {
	#name : #RiFileToDiffMapping,
	#superclass : #RiDiffMapping,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #mapping }
RiFileToDiffMapping >> calculate [
	iceNode := iceDiff tree resolve: file path.
	iceNodeLineNumber := lineNumber
]
