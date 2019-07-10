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

{ #category : #accessing }
RiUncommitedWorkingCopy >> author [
	^ '---'
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> comment [
	^ '---'
]

{ #category : #accessing }
RiUncommitedWorkingCopy >> date [
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
RiUncommitedWorkingCopy >> shortId [
	^ '---'
]
