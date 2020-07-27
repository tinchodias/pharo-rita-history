Class {
	#name : #RiDiffMapping,
	#superclass : #Object,
	#instVars : [
		'file',
		'iceDiff',
		'lineNumber',
		'iceNode',
		'iceNodeLineNumber'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #accessing }
RiDiffMapping >> file: aFileReference [ 
	file := aFileReference
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
RiDiffMapping >> lineNumber: anInteger [ 
	lineNumber := anInteger
]
