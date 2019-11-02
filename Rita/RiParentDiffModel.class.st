Class {
	#name : #RiParentDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'parentRiElement'
	],
	#category : #'Rita-UI'
}

{ #category : #'instance creation' }
RiParentDiffModel class >> parentRiElement: aRiCommit [
	^ self basicNew
		initializeWithParentRiElement: aRiCommit;
		yourself
]

{ #category : #accessing }
RiParentDiffModel >> iceDiffTo: targetRiElement [
	^ targetRiElement iceCommit diffTo: parentRiElement iceCommit
]

{ #category : #accessing }
RiParentDiffModel >> initializeWithParentRiElement: aRiCommit [
	self initialize.
	parentRiElement := aRiCommit
]

{ #category : #accessing }
RiParentDiffModel >> title [
	^ 'Parent ({1})' format: { parentRiElement shortId } 
]
