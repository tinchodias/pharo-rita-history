Class {
	#name : #RiBranchMark,
	#superclass : #RiMark,
	#instVars : [
		'local',
		'remote'
	],
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiBranchMark >> accept: aVisitor [
	^ aVisitor visitBranchMark: self
]

{ #category : #testing }
RiBranchMark >> isBranchMark [
	^ true
]

{ #category : #testing }
RiBranchMark >> isOnlyLocal [
	^ local isNotNil and: [ remote isNil ]
]

{ #category : #accessing }
RiBranchMark >> local [
	^ local
]

{ #category : #accessing }
RiBranchMark >> local: anObject [
	local := anObject
]

{ #category : #printing }
RiBranchMark >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self shortname;
		nextPutAll: ')'
]

{ #category : #accessing }
RiBranchMark >> remote [
	^ remote
]

{ #category : #accessing }
RiBranchMark >> remote: anObject [
	remote := anObject
]

{ #category : #accessing }
RiBranchMark >> shortname [
	^ (local ifNil: [ remote ]) shortname "One of both must be not nil"
]
