"
Represents a mark of a RiElement.
"
Class {
	#name : #RiMark,
	#superclass : #Object,
	#instVars : [
		'element'
	],
	#category : #'Rita-Model-Core'
}

{ #category : #visiting }
RiMark >> accept: aVisitor [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiMark >> description [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiMark >> element [
	^ element
]

{ #category : #accessing }
RiMark >> element: anObject [
	element := anObject
]

{ #category : #testing }
RiMark >> isBranchMark [
	^ false
]

{ #category : #testing }
RiMark >> isTagMark [
	^ false
]
