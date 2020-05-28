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

{ #category : #initialization }
IceGitHubPullRequestComment >> initializeWithJSON: aDictionary [
	json := aDictionary.
	self initialize
]

{ #category : #accessing }
IceGitHubPullRequestComment >> projectName [
	^ ((self jsonAt: #base) at: #repo) at: #name
]
