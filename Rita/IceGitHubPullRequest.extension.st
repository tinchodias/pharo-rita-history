Extension { #name : #IceGitHubPullRequest }

{ #category : #'*Rita' }
IceGitHubPullRequest >> basicBranch [
	^ branch ifNil: [
		branch := (self repository
			remoteNamed: self remote name )
				remoteBranchNamed: self headRef ]
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> comments [
	| jsons |
	jsons := (IceGitHubAPI new
"		useComfortFadeAcceptMediaType; --> for multi-line comment support"
		beAnonymous;
		getListPullRequestComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
"			repository: self repository
			yourself "]
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> createdAt [
	^ json at: 'created_at'
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> diffToBase [
	^ self basicBranch commit diffTo: self baseCommit
]

{ #category : #'*Rita' }
IceGitHubPullRequest >> diffToRepositoryHead [
	"Inspired on IceMerge>>calculateChanges"

	^ self basicBranch commit diffTo: self repository headCommit
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
		"useComfortFadeAcceptMediaType; --> for multi-line comment support"
		beAnonymous;
		getListPullRequestReviewComments: self owner 
			project: self projectName
			number: self number) all.
	^ jsons collect: [ :each |
		(IceGitHubPullRequestComment fromJSON: each)
"			repository: self repository;
			yourself "]
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
