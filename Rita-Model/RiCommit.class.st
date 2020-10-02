"
Represents a commit, independently if it's already pushed to a remote or only local.
"
Class {
	#name : #RiCommit,
	#superclass : #RiElement,
	#instVars : [
		'ancestors',
		'children',
		'repository',
		'iceCommit'
	],
	#category : #'Rita-Model-Core'
}

{ #category : #'instance creation' }
RiCommit class >> repository: aRiRepository iceCommit: anIceCommit [
	^ self basicNew
		initializeWithRepository: aRiRepository iceCommit: anIceCommit;
		yourself
]

{ #category : #visiting }
RiCommit >> accept: aVisitor [
	^ aVisitor visitCommit: self
]

{ #category : #accessing }
RiCommit >> addAncestor: aRiElement [
	ancestors := ancestors copyWith: aRiElement
]

{ #category : #accessing }
RiCommit >> addChildren: aRiElement [
	children := children copyWith: aRiElement
]

{ #category : #accessing }
RiCommit >> ancestors [
	^ ancestors
]

{ #category : #converting }
RiCommit >> asIceObject [
	^ iceCommit
]

{ #category : #accessing }
RiCommit >> author [
	^ iceCommit libgitCommit author
]

{ #category : #accessing }
RiCommit >> authorEmail [
	^ self author email
]

{ #category : #accessing }
RiCommit >> authorName [
	^ iceCommit author
]

{ #category : #accessing }
RiCommit >> children [
	^ children
]

{ #category : #accessing }
RiCommit >> comment [
	^ iceCommit comment
]

{ #category : #accessing }
RiCommit >> committer [
	^ iceCommit libgitCommit committer
]

{ #category : #accessing }
RiCommit >> committerEmail [
	^ self committer email
]

{ #category : #accessing }
RiCommit >> dateAndTime [
	^ RiDatePrinter new stringFor: iceCommit datetime asDate
]

{ #category : #diff }
RiCommit >> diffTo: aRiCommit [ 
	^ iceCommit diffTo: aRiCommit iceCommit
]

{ #category : #accessing }
RiCommit >> iceCommit [
	^ iceCommit
]

{ #category : #accessing }
RiCommit >> id [
	^ iceCommit id
]

{ #category : #initialization }
RiCommit >> initializeWithRepository: aRiRepository iceCommit: anIceCommit [
	self initialize.
	repository := aRiRepository.
	iceCommit := anIceCommit.
	children := #().
	ancestors := #()
]

{ #category : #printing }
RiCommit >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self shortId asString;
		nextPutAll: ')'
]

{ #category : #accessing }
RiCommit >> repository [
	^ repository
]

{ #category : #accessing }
RiCommit >> repository: anObject [
	repository := anObject
]

{ #category : #accessing }
RiCommit >> shortDescription [
	^ ' ' join: { self shortId. self comment printStringLimitedTo: 50. self dateAndTime }
]

{ #category : #accessing }
RiCommit >> shortId [
	^ iceCommit shortId
]
