Class {
	#name : #RiParentDiffModel,
	#superclass : #RiDiffModel,
	#instVars : [
		'parentRiElement'
	],
	#category : #'Rita-UI-Models'
}

{ #category : #'instance creation' }
RiParentDiffModel class >> parentRiElement: aRiCommit [
	^ self basicNew
		initializeWithParentRiElement: aRiCommit;
		yourself
]

{ #category : #accessing }
RiParentDiffModel >> iceDiffTo: targetRiElement [
	^ targetRiElement diffTo: parentRiElement
]

{ #category : #accessing }
RiParentDiffModel >> icon [
	^ self iconNamed: #diff
]

{ #category : #accessing }
RiParentDiffModel >> initializeWithParentRiElement: aRiCommit [
	self initialize.
	parentRiElement := aRiCommit
]

{ #category : #testing }
RiParentDiffModel >> shouldCompareTo: aRiCommit [ 
	^ true
]

{ #category : #accessing }
RiParentDiffModel >> title [
	^ 'Diff to Parent ({1})' format: { parentRiElement shortId } 
]
