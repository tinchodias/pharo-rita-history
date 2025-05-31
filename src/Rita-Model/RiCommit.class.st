"
Represents a commit, independently if it's already pushed to a remote or only local.
"
Class {
	#name : 'RiCommit',
	#superclass : 'RiElement',
	#instVars : [
		'ancestors',
		'children',
		'repository',
		'iceGitCommit'
	],
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RiCommit class >> repository: aRiRepository iceGitCommit: anIceCommit [
	^ self basicNew
		initializeWithRepository: aRiRepository iceGitCommit: anIceCommit;
		yourself
]

{ #category : 'visiting' }
RiCommit >> accept: aVisitor [
	^ aVisitor visitCommit: self
]

{ #category : 'accessing' }
RiCommit >> addAncestor: aRiElement [
	ancestors := ancestors copyWith: aRiElement
]

{ #category : 'accessing' }
RiCommit >> addChildren: aRiElement [
	children := children copyWith: aRiElement
]

{ #category : 'accessing' }
RiCommit >> ancestors [
	^ ancestors
]

{ #category : 'converting' }
RiCommit >> asIceObject [
	^ iceGitCommit
]

{ #category : 'accessing' }
RiCommit >> author [
	^ iceGitCommit libgitCommit author
]

{ #category : 'accessing' }
RiCommit >> authorEmail [
	^ self author email
]

{ #category : 'accessing' }
RiCommit >> authorName [
	^ iceGitCommit author
]

{ #category : 'accessing' }
RiCommit >> children [
	^ children
]

{ #category : 'accessing' }
RiCommit >> comment [
	^ iceGitCommit comment
]

{ #category : 'accessing' }
RiCommit >> committer [
	^ iceGitCommit libgitCommit committer
]

{ #category : 'accessing' }
RiCommit >> committerEmail [
	^ self committer email
]

{ #category : 'accessing' }
RiCommit >> dateAndTime [
	^ RiDatePrinter new stringFor: iceGitCommit datetime asDate
]

{ #category : 'diff' }
RiCommit >> diffTo: aRiCommit [

	^ RiceDiff from: iceGitCommit to: aRiCommit iceGitCommit
]

{ #category : 'API - changes' }
RiCommit >> diffToParent [
	
	^ self diffTo: ancestors first
]

{ #category : 'accessing' }
RiCommit >> iceGitCommit [
	^ iceGitCommit
]

{ #category : 'accessing' }
RiCommit >> id [
	^ iceGitCommit id
]

{ #category : 'initialization' }
RiCommit >> initializeWithRepository: aRiRepository iceGitCommit: anIceGitCommit [

	self initialize.
	repository := aRiRepository.
	iceGitCommit := anIceGitCommit.
	children := #().
	ancestors := #()
]

{ #category : 'printing' }
RiCommit >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self shortId asString;
		nextPutAll: ')'
]

{ #category : 'accessing' }
RiCommit >> repository [
	^ repository
]

{ #category : 'accessing' }
RiCommit >> repository: anObject [
	repository := anObject
]

{ #category : 'accessing' }
RiCommit >> shortDescription [
	^ ' ' join: { self shortId. self comment printStringLimitedTo: 50. self dateAndTime }
]

{ #category : 'accessing' }
RiCommit >> shortId [
	^ iceGitCommit shortId
]
