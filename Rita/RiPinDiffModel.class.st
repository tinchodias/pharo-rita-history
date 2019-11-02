Class {
	#name : #RiPinDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'sourceRiCommit'
	],
	#category : #'Rita-UI'
}

{ #category : #'instance creation' }
RiPinDiffModel class >> sourceRiCommit: aRiCommit [
	^ self basicNew
		initializeWithSourceRiCommit: aRiCommit;
		yourself
]

{ #category : #accessing }
RiPinDiffModel >> iceDiffTo: targetRiCommit [
	^ targetRiCommit iceCommit diffTo: sourceRiCommit iceCommit
]

{ #category : #accessing }
RiPinDiffModel >> initializeWithSourceRiCommit: aRiCommit [
	self initialize.
	sourceRiCommit := aRiCommit
]

{ #category : #accessing }
RiPinDiffModel >> title [
	^ 'Pin (', sourceRiCommit shortId, ')'
]
