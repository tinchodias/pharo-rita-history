Class {
	#name : #RiTagMark,
	#superclass : #RiMark,
	#instVars : [
		'tag'
	],
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiTagMark >> accept: aVisitor [
	^ aVisitor visitTagMark: self
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
