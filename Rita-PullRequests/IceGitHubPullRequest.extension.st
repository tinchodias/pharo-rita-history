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
IceGitHubPullRequest >> changedFiles [

	| jsons |
	jsons := (IceGitHubAPI new
		   getListPullRequestFiles: self owner
		   project: self projectName
		   number: self number) all.
		
	^ jsons collect: [ :each |
		IceGitHubPullRequestChangedFile fromJSON: each ]
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> comments [
	| jsons |
	jsons := (IceGitHubAPI new
		useComfortFadeAcceptMediaType; "--> for multi-line comment support"
		beAnonymous;
		getListPullRequestComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
"			repository: self repository
			yourself "]
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
IceGitHubPullRequest >> isHunkComment [
	^ false
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> isOutdated [
	^ false
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> replyComment: messageString commentId: commentId [
	| aJsonDictionary |
	aJsonDictionary := IceGitHubAPI new 
		addCommentOn: self owner 
			project: self projectName
			number: self number
			commentId: commentId
			body: messageString.
			
	^ IceGitHubPullRequestComment fromJSON: aJsonDictionary
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> reviewComments [
	| jsons |
	jsons := (IceGitHubAPI new
		useComfortFadeAcceptMediaType; "--> for multi-line comment support"
		beAnonymous;
		getListPullRequestReviewComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
"			repository: self repository;
			yourself "]
]

{ #category : #'*Rita-PullRequests' }
IceGitHubPullRequest >> reviews [
	| jsons |
	jsons := (IceGitHubAPI new
		beAnonymous;
		getListPullRequestReviews: self owner 
			project: self projectName
			number: self number) all.
	^ jsons "reify"
]
