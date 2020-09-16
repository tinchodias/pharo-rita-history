Extension { #name : #IceGitHubPullRequest }

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> authorAvatarUrl [
	^ (json at: #user) at: #avatar_url
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> authorHtmlUrl [
	^ (json at: #user) at: #html_url
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> isOutdated [
	^ false
]
