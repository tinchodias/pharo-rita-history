"
I represent a mapping between an IceNode and a GitHub Pull Request comment in an arbitrary file, for example the README.md file.

"
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
