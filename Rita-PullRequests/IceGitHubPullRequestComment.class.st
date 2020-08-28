Class {
	#name : #IceGitHubPullRequestComment,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'Rita-PullRequests-Model'
}

{ #category : #'instance creation' }
IceGitHubPullRequestComment class >> fromJSON: aDictionary [
	^ self basicNew
		initializeWithJSON: aDictionary;
		yourself
]

{ #category : #accessing }
IceGitHubPullRequestComment >> author [
	^ (json at: #user) at: #login
]

{ #category : #accessing }
IceGitHubPullRequestComment >> body [
	^ json at: #body
]

{ #category : #accessing }
IceGitHubPullRequestComment >> creationDateAndTime [
	^ (json at: #created_at) asDateAndTime 
]

{ #category : #accessing }
IceGitHubPullRequestComment >> diffHunk [
	^ json at: 'diff_hunk' ifAbsent: [ nil ]
]

{ #category : #accessing }
IceGitHubPullRequestComment >> id [
	^ json at: #id
]

{ #category : #initialization }
IceGitHubPullRequestComment >> initializeWithJSON: aDictionary [
	json := aDictionary.
	self initialize
]

{ #category : #inspecting }
IceGitHubPullRequestComment >> inspectBodyOn: composite [
	<gtInspectorPresentationOrder: 1>
	composite text
		title: 'Contents';
		format: #asText;
		display: [ MicroDownParser asText: self body ];
		yourself
]

{ #category : #testing }
IceGitHubPullRequestComment >> isHunkComment [
	^ json includesKey: 'path'
]

{ #category : #'as yet unclassified' }
IceGitHubPullRequestComment >> isReplyComment [
	^ json includesKey: 'in_reply_to_id'
]

{ #category : #testing }
IceGitHubPullRequestComment >> isSideOfAddition [
	^ self side = 'RIGHT'
]

{ #category : #accessing }
IceGitHubPullRequestComment >> line [
	^ json at: 'line'
]

{ #category : #accessing }
IceGitHubPullRequestComment >> originalCommitSHA [
	^ json at: 'original_commit_id'
]

{ #category : #accessing }
IceGitHubPullRequestComment >> originalLine [
	^ json at: 'original_line'
]

{ #category : #accessing }
IceGitHubPullRequestComment >> originalPosition [
	^ json at: 'original_position' ifAbsent: [ nil ]
]

{ #category : #accessing }
IceGitHubPullRequestComment >> path [
	^ json at: 'path'
]

{ #category : #printing }
IceGitHubPullRequestComment >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self id.
	
	self isReplyComment ifTrue: [ :repliedId |
		aStream
			nextPutAll: ' - reply to: ';
			print: self repliedId ].
	aStream
		nextPut: $).
]

{ #category : #accessing }
IceGitHubPullRequestComment >> projectName [
	^ ((self jsonAt: #base) at: #repo) at: #name
]

{ #category : #accessing }
IceGitHubPullRequestComment >> repliedId [
	^ json at: 'in_reply_to_id' ifAbsent: [ nil ]
]

{ #category : #accessing }
IceGitHubPullRequestComment >> side [
	^ json at: 'side'
]

{ #category : #accessing }
IceGitHubPullRequestComment >> updateDateAndTime [
	^ (json at: #updated_at) asDateAndTime 
]

{ #category : #accessing }
IceGitHubPullRequestComment >> userLogin [
	^ (json at: #user) at: #login
]
