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

{ #category : #converting }
RiCommit >> asIceObject [
	^ iceCommit
]

{ #category : #accessing }
RiCommit >> author [
	^ iceCommit author
]

{ #category : #accessing }
RiCommit >> authorEmail [
	^ iceCommit libgitCommit author email
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
RiCommit >> committerEmail [
	^ iceCommit libgitCommit committer email
]

{ #category : #accessing }
RiCommit >> dateAndTime [
	^ String
		streamContents: [ :stream | 
			ExtendedDatePrinter default
				printDate: iceCommit datetime asDate
				format: #(1 2 3 $  2 2 1)
				on: stream ]
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
RiCommit >> iceCommit: anObject [
	iceCommit := anObject
]

{ #category : #accessing }
RiCommit >> id [
	^ iceCommit id
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
