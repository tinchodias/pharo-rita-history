"
Represents changes in image's working copy.
"
Class {
	#name : #RiWorkingCopyChanges,
	#superclass : #RiElement,
	#instVars : [
		'ancestorWorkingCopyElement'
	],
	#category : #'Rita-Core'
}

{ #category : #accessing }
RiWorkingCopyChanges >> ancestorWorkingCopyElement [
	^ ancestorWorkingCopyElement
]

{ #category : #accessing }
RiWorkingCopyChanges >> ancestorWorkingCopyElement: anObject [
	ancestorWorkingCopyElement := anObject
]

{ #category : #accessing }
RiWorkingCopyChanges >> ancestors [
	^ { ancestorWorkingCopyElement }
]

{ #category : #accessing }
RiWorkingCopyChanges >> comment [
	^ '------ UNCOMMITED CHANGES IN THE IMAGE ------'
]
