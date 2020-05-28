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

{ #category : #accessing }
IceGitHubPullRequestComment >> body [
	^ json at: #body
]

{ #category : #accessing }
IceGitHubPullRequestComment >> createdAt [
	^ (json at: #created_at) asDateAndTime 
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
