"
Represents changes in disk's working tree.
"
Class {
	#name : #RiWorkingTreeChanges,
	#superclass : #RiElement,
	#instVars : [
		'ancestorCommitElement'
	],
	#category : #'Rita-Core'
}

{ #category : #accessing }
RiWorkingTreeChanges >> ancestorCommitElement [
	^ ancestorCommitElement
]

{ #category : #accessing }
RiWorkingTreeChanges >> ancestorCommitElement: anObject [
	ancestorCommitElement := anObject
]

{ #category : #accessing }
RiWorkingTreeChanges >> ancestors [
	^ { ancestorCommitElement }
]
