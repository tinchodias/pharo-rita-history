"
I represent a commit, independently if it's already pushed to a remote or only local. I am the generic part: a subclass reads a concrete backend, such as RiIcebergCommit, and implements the accessors that answer the id, the comment, the author, the committer, the date and the ids of the ancestors. The author and the committer answer #name, #email and #dateAndTime.
"
Class {
	#name : 'RiCommit',
	#superclass : 'RiElement',
	#instVars : [
		'ancestors',
		'children',
		'repository'
	],
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'accessing' }
RiCommit >> addAncestor: aRiElement [
	ancestors := ancestors copyWith: aRiElement
]

{ #category : 'accessing' }
RiCommit >> addChildren: aRiElement [
	children := children copyWith: aRiElement
]

{ #category : 'accessing' }
RiCommit >> ancestorIds [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiCommit >> ancestors [
	^ ancestors
]

{ #category : 'accessing' }
RiCommit >> authorName [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiCommit >> checkout [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiCommit >> children [
	^ children
]

{ #category : 'accessing' }
RiCommit >> committer [

	^ self subclassResponsibility
]

{ #category : 'API - changes' }
RiCommit >> diffToParent [
	
	^ self diffTo: ancestors first
]

{ #category : 'initialization' }
RiCommit >> initializeWithRepository: aRiRepository [

	self initialize.
	repository := aRiRepository.
	children := #(  ).
	ancestors := #(  )
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
