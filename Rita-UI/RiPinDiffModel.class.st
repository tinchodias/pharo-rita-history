Class {
	#name : #RiPinDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'sourceRiCommit'
	],
	#category : #'Rita-UI-Models'
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
RiPinDiffModel >> icon [
	^ self iconNamed: #breakpoint
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
RiPinDiffModel >> sourceRiCommit [
	^ sourceRiCommit
]

{ #category : #accessing }
RiPinDiffModel >> title [
	^ 'Diff to Pin (', sourceRiCommit shortId, ')'
]
