Extension { #name : #IceGitHubPullRequestComment }

{ #category : #'*Rita' }
IceGitHubPullRequestComment >> isReplyComment [
	^ json includesKey: 'in_reply_to_id'
]
