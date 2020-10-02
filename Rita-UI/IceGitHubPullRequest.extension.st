Extension { #name : #IceGitHubPullRequest }

{ #category : #'*Rita-UI' }
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

{ #category : #'*Rita-UI-PullRequests' }
IceGitHubPullRequest >> isHunkComment [
	^ false
]

{ #category : #'*Rita-UI' }
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

{ #category : #'*Rita-UI' }
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

{ #category : #'*Rita-UI' }
IceGitHubPullRequest >> reviews [
	| jsons |
	jsons := (IceGitHubAPI new
		beAnonymous;
		getListPullRequestReviews: self owner 
			project: self projectName
			number: self number) all.
	^ jsons "reify"
]
