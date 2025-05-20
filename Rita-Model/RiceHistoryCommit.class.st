"
I am a commit optimizing history access. I know a history and can determine if I'm merged asking to my history if HEAD history contains me.

All other operations are simply forwarded to my wrapped ice commit.
"
Class {
	#name : #RiceHistoryCommit,
	#superclass : #Object,
	#instVars : [
		'iceCommit',
		'history'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceHistoryCommit class >> commit: anIceCommit history: aHistory [
	
	^ self new
		iceCommit: anIceCommit;
		history: aHistory;
		yourself
]

{ #category : #accessing }
RiceHistoryCommit >> ancestors [
	
	^ iceCommit ancestorIds
]

{ #category : #accessing }
RiceHistoryCommit >> author [
	
	^ iceCommit author
]

{ #category : #testing }
RiceHistoryCommit >> canRevertChanges [
	
	^ iceCommit canRevertChanges
]

{ #category : #accessing }
RiceHistoryCommit >> comment [
	
	^ iceCommit comment
]

{ #category : #accessing }
RiceHistoryCommit >> datetime [
	
	^ iceCommit datetime
]

{ #category : #'API-changes' }
RiceHistoryCommit >> diffFromHead [
	
	^ iceCommit diffFromHead
]

{ #category : #'API-changes' }
RiceHistoryCommit >> diffToParent [
	
	^ iceCommit diffToParent
]

{ #category : #accessing }
RiceHistoryCommit >> history [
	^ history
]

{ #category : #accessing }
RiceHistoryCommit >> history: anObject [
	history := anObject
]

{ #category : #accessing }
RiceHistoryCommit >> iceCommit [
	^ iceCommit
]

{ #category : #accessing }
RiceHistoryCommit >> iceCommit: anIceGitCommit [ 
	iceCommit := anIceGitCommit
]

{ #category : #accessing }
RiceHistoryCommit >> id [
	
	^ iceCommit id
]

{ #category : #testing }
RiceHistoryCommit >> isMerged [
	
	^ history headHistory includes: iceCommit
]

{ #category : #accessing }
RiceHistoryCommit >> repository [
	
	^ iceCommit repository
]

{ #category : #accessing }
RiceHistoryCommit >> shortId [
	
	^ iceCommit shortId
]
