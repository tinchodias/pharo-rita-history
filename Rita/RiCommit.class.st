"
Represents a commit, independently if it's already pushed to a remote or only local.
"
Class {
	#name : #RiCommit,
	#superclass : #RiElement,
	#instVars : [
		'commit',
		'model',
		'ancestors',
		'children'
	],
	#category : #'Rita-Core'
}

{ #category : #'instance creation' }
RiCommit class >> model: aRiRepositoryModel commit: anIceCommit [
	^ self new
		model: aRiRepositoryModel;
		commit: anIceCommit;
		yourself
]

{ #category : #accessing }
RiCommit >> addChildren: aRiElement [
	self children add: aRiElement
]

{ #category : #accessing }
RiCommit >> ancestors [
	^ ancestors ifNil: [ 
		ancestors := commit ancestors
			collect: [ :each | model elementByCommit at: each ] ]
]

{ #category : #accessing }
RiCommit >> author [
	^ commit author
]

{ #category : #accessing }
RiCommit >> children [
	^ children ifNil: [ 
		children := OrderedCollection new ]
]

{ #category : #accessing }
RiCommit >> comment [
	^ commit comment
]

{ #category : #accessing }
RiCommit >> commit [
	^ commit
]

{ #category : #accessing }
RiCommit >> commit: anObject [
	commit := anObject
]

{ #category : #accessing }
RiCommit >> date [
	^ commit datetime asDate
]

{ #category : #accessing }
RiCommit >> model [
	^ model
]

{ #category : #accessing }
RiCommit >> model: anObject [
	model := anObject
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
RiCommit >> shortId [
	^ commit shortId
]
