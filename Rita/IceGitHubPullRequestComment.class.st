Class {
	#name : #IceGitHubPullRequestComment,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'Rita-Iceberg'
}

{ #category : #'instance creation' }
IceGitHubPullRequestComment class >> fromJSON: aDictionary [
	^ self basicNew
		initializeWithJSON: aDictionary;
		yourself
]

{ #category : #'as yet unclassified' }
IceGitHubPullRequestComment >> author [
	^ (json at: #user) at: #login
]

{ #category : #accessing }
IceGitHubPullRequestComment >> body [
	^ json at: #body
]

{ #category : #accessing }
IceGitHubPullRequestComment >> createdAt [
	^ (json at: #created_at) asDateAndTime 
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
IceGitHubPullRequestComment >> originalPosition [
	^ json at: 'original_position' ifAbsent: [ nil ]
]

{ #category : #'as yet unclassified' }
IceGitHubPullRequestComment >> path [
	^ json at: 'path' ifAbsent: [ nil ]
]

{ #category : #printing }
IceGitHubPullRequestComment >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self id.
	
	self repliedId ifNotNil: [ :repliedId |
		aStream
			nextPutAll: ' - reply to: ';
			print: repliedId ].
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
IceGitHubPullRequestComment >> updatedAt [
	^ (json at: #updated_at) asDateAndTime 
]

{ #category : #accessing }
IceGitHubPullRequestComment >> userLogin [
	^ (json at: #user) at: #login
]
