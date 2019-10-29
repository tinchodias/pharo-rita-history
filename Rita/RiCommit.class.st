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
	#category : #'Rita-Core'
}

{ #category : #'instance creation' }
RiCommit class >> repository: aRiRepository iceCommit: anIceCommit [
	^ self new
		repository: aRiRepository;
		iceCommit: anIceCommit;
		yourself
]

{ #category : #visiting }
RiCommit >> accept: aVisitor [
	^ aVisitor visitCommit: self
]

{ #category : #accessing }
RiCommit >> addChildren: aRiElement [
	self children add: aRiElement
]

{ #category : #accessing }
RiCommit >> ancestors [
	^ ancestors ifNil: [ 
		ancestors := iceCommit ancestors
			collect: [ :each | repository elementByCommit at: each ] ]
]

{ #category : #accessing }
RiCommit >> author [
	^ iceCommit author
]

{ #category : #accessing }
RiCommit >> children [
	^ children ifNil: [ 
		children := OrderedCollection new ]
]

{ #category : #accessing }
RiCommit >> comment [
	^ iceCommit comment
]

{ #category : #accessing }
RiCommit >> date [
	^ iceCommit datetime asDate
]

{ #category : #accessing }
RiCommit >> iceCommit [
	^ iceCommit
]

{ #category : #accessing }
RiCommit >> iceCommit: anObject [
	iceCommit := anObject
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
RiCommit >> shortId [
	^ iceCommit shortId
]
