Class {
	#name : #IceGitHubPullRequestChangedFile,
	#superclass : #IceGitHubJsonWrapper,
	#category : #'Rita-PullRequests-Model'
}

{ #category : #accessing }
IceGitHubPullRequestChangedFile >> path [
	^ RelativePath from: self pathString
]

{ #category : #accessing }
IceGitHubPullRequestChangedFile >> pathString [
	^ json at: 'filename'
]

{ #category : #printing }
IceGitHubPullRequestChangedFile >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: self pathString;
		nextPutAll: ')'

]
