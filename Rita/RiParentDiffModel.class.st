Class {
	#name : #RiParentDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'parentRiElement'
	],
	#category : #'Rita-UI'
}

{ #category : #'instance creation' }
RiParentDiffModel class >> parentRiElement: anObject [
	^ self basicNew
		initializeWithParentRiElement: anObject;
		yourself
]

{ #category : #accessing }
RiParentDiffModel >> iceDiffTo: targetRiElement [
	^ targetRiElement iceCommit diffTo: parentRiElement iceCommit
]

{ #category : #accessing }
RiParentDiffModel >> initializeWithParentRiElement: anObject [
	parentRiElement := anObject
]

{ #category : #accessing }
RiParentDiffModel >> title [
	^ 'Parent ({1})' format: { parentRiElement shortId } 
]
