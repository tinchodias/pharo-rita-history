Class {
	#name : #RiPinDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'sourceRiCommit'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #'instance creation' }
RiPinDiffModel class >> sourceRiCommit: aRiCommit [
	^ self basicNew
		initializeWithSourceRiCommit: aRiCommit;
		yourself
]

{ #category : #accessing }
RiPinDiffModel >> iceDiffTo: targetRiCommit [
	^ targetRiCommit asIceObject diffTo: sourceRiCommit asIceObject
]

{ #category : #accessing }
RiPinDiffModel >> initializeWithSourceRiCommit: aRiCommit [
	self initialize.
	sourceRiCommit := aRiCommit
]

{ #category : #testing }
RiPinDiffModel >> shouldCompareTo: aRiElement [
	^ sourceRiCommit ~= aRiElement
]

{ #category : #accessing }
RiPinDiffModel >> title [
	^ 'Pin (', sourceRiCommit shortId, ')'
]
