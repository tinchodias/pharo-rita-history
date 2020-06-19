Extension { #name : #IceGitHubPullRequest }

{ #category : #'*Rita' }
IceGitHubPullRequest >> comments [
	| jsons |
	jsons := (IceGitHubAPI new
		beAnonymous;
		listPullRequestComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
			"repository: self repository entity;
			yourself" ]
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> createdAt [
	^ json at: 'created_at'
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> htmlUrl [
	^ self jsonAt: #html_url
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> path [
	^ nil
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> repliedId [
	^ nil
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> replyComment: messageString commentId: commentId [
	IceGitHubAPI new 
		replyCommentOn: self owner 
			project: self projectName
			number: self number
			commentId: commentId
			body: messageString
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> reviewComments [
	| jsons |
	jsons := (IceGitHubAPI new 
		beAnonymous;
		listPullRequestReviewComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
			"repository: self repository entity;
			yourself" ]
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> reviews [
	| jsons |
	jsons := (IceGitHubAPI new
		beAnonymous;
		listPullRequestReviews: self owner 
			project: self projectName
			number: self number) all.
	^ jsons "reify"
]
