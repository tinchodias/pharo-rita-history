"
I represent a mapping between an IceNode and a GitHub Pull Request comment.
"
Class {
	#name : #RiDiffMapping,
	#superclass : #Object,
	#instVars : [
		'file',
		'iceDiff',
		'lineNumber',
		'iceNode',
		'iceNodeLineNumber',
		'iceComment'
	],
	#category : #'Rita-PullRequests-Model'
}

{ #category : #accessing }
RiDiffMapping >> file: aFileReference [

	file := aFileReference
]

{ #category : #accessing }
RiDiffMapping >> iceComment: anIceComment [

	iceComment := anIceComment
]

{ #category : #accessing }
RiDiffMapping >> iceDiff: anIceDiff [

	iceDiff := anIceDiff
]

{ #category : #accessing }
RiDiffMapping >> iceNode [

	^ iceNode
]

{ #category : #accessing }
RiDiffMapping >> iceNodeLineNumber [

	^ iceNodeLineNumber
]

{ #category : #accessing }
RiDiffMapping >> lineNumber [

	^ lineNumber
]

{ #category : #accessing }
RiDiffMapping >> lineNumber: anInteger [

	lineNumber := anInteger
]
