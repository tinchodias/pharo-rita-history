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
IceGitHubPullRequest >> baseCommonAncestorCommit [
	^ self baseCommit commonAncestorWith: self basicHeadCommit
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> diffToBaseCommonAncestor [
	^ self headCommit diffTo: self baseCommonAncestorCommit
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> headCommit [
	^ self branch commit
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> isOutdated [
	^ false
]
