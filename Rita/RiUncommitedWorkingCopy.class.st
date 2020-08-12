"
Represents changes in image's working copy.
"
Class {
	#name : #RiUncommitedWorkingCopy,
	#superclass : #RiElement,
	#instVars : [
		'referenceCommit'
	],
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiUncommitedWorkingCopy >> accept: aVisitor [
	^ aVisitor visitUncommitedWorkingCopy: self
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> ancestors [
	^ { referenceCommit }
]

{ #category : #converting }
RiUncommitedWorkingCopy >> asIceObject [
	^ self repository iceRepository workingCopy
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> author [
	^ '---'
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> authorEmail [
	^ ''
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> children [
	^ #()
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> comment [
	^ '---'
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> committerEmail [
	^ ''
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> dateAndTime [
	^ '---'
]

{ #category : #diff }
RiUncommitedWorkingCopy >> diffTo: aRiCommit [ 
	^ self asIceObject diffTo: aRiCommit iceCommit
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> id [
	^ '---'
]

{ #category : #testing }
RiUncommitedWorkingCopy >> isUncommited [
	^ true
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> referenceCommit [
	^ referenceCommit
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> referenceCommit: aRiCommit [
	referenceCommit := aRiCommit
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> repository [
	^ referenceCommit repository
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> shortDescription [
	^ 'Uncommited changes'
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> shortId [
	^ '---'
]
