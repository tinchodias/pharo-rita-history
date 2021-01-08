Class {
	#name : #RiFileToDiffMapping,
	#superclass : #RiDiffMapping,
	#category : #'Rita-PullRequests-Model'
}

{ #category : #mapping }
RiFileToDiffMapping >> calculate [

	iceNode := iceDiff tree resolve: file path.
	iceNodeLineNumber := lineNumber
]
