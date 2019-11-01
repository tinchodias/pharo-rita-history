Class {
	#name : #RiPinDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'sourceIceCommit'
	],
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiPinDiffModel >> iceDiffTo: targetRiCommit [
	^ targetRiCommit iceCommit diffTo: sourceIceCommit
]

{ #category : #accessing }
RiPinDiffModel >> sourceIceCommit [
	^ sourceIceCommit
]

{ #category : #accessing }
RiPinDiffModel >> sourceIceCommit: anObject [
	sourceIceCommit := anObject
]

{ #category : #accessing }
RiPinDiffModel >> title [
	^ 'Diff to ', sourceIceCommit shortId, ' (pin)'
]
