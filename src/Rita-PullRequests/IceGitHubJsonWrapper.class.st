Class {
	#name : #IceGitHubJsonWrapper,
	#superclass : #Object,
	#instVars : [
		'json'
	],
	#category : #'Rita-PullRequests-Model'
}

{ #category : #'instance creation' }
IceGitHubJsonWrapper class >> fromJSON: aDictionary [

	^ self basicNew
		  initializeWithJSON: aDictionary;
		  yourself
]

{ #category : #initialization }
IceGitHubJsonWrapper >> initializeWithJSON: aDictionary [
	json := aDictionary.
	self initialize
]

{ #category : #accessing }
IceGitHubJsonWrapper >> json [
	^ json
]
