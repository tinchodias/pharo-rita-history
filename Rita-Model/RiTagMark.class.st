Class {
	#name : #RiTagMark,
	#superclass : #RiMark,
	#instVars : [
		'tag'
	],
	#category : #'Rita-Model-Core'
}

{ #category : #visiting }
RiTagMark >> accept: aVisitor [
	^ aVisitor visitTagMark: self
]

{ #category : #accessing }
RiTagMark >> description [
	^ self name surroundedBySingleQuotes, ' tag'
]

{ #category : #testing }
RiTagMark >> isTagMark [
	^ true
]

{ #category : #accessing }
RiTagMark >> name [
	^ tag name
]

{ #category : #printing }
RiTagMark >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self name;
		nextPutAll: ')'
]

{ #category : #accessing }
RiTagMark >> tag [
	^ tag
]

{ #category : #accessing }
RiTagMark >> tag: anObject [
	tag := anObject
]
