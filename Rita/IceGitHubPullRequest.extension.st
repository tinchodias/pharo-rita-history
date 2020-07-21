Extension { #name : #IceGitHubPullRequest }

{ #category : #'*Rita' }
IceGitHubPullRequest >> comments [
	| jsons |
	jsons := (IceGitHubAPI new
		beAnonymous;
		getListPullRequestComments: self owner 
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
IceGitHubPullRequest >> diffToRepositoryHead [
	"Inspired on IceMerge>>calculateChanges"

	^ self branch head diffTo: self repository head
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
		addCommentOn: self owner 
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
		getListPullRequestReviewComments: self owner 
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
		getListPullRequestReviews: self owner 
			project: self projectName
			number: self number) all.
	^ jsons "reify"
]