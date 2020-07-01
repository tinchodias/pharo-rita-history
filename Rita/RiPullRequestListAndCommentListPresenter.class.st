Class {
	#name : #RiPullRequestListAndCommentListPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #initialization }
RiPullRequestListAndCommentListPresenter >> connectMasterToDetail [
	masterPresenter blockForPRSelected: [ :aPR |
		detailPresenter model: 
			(model copy 
				add: #pullRequest -> aPR;
				yourself) ].

]

{ #category : #initialization }
RiPullRequestListAndCommentListPresenter >> detailPresenterClass [
	^ RiPullRequestPresenter2
]

{ #category : #initialization }
RiPullRequestListAndCommentListPresenter >> masterPresenterClass [
	^ RiPullRequestListPresenter
]

{ #category : #accessing }
RiPullRequestListAndCommentListPresenter >> model: anObject [
	| iceRepo githubRemote jsons prs |

	iceRepo := (anObject at: #repository) iceRepository.
	githubRemote := (iceRepo remotes 
		select: [ :each | each host = 'github.com' ])
		last.

	"List all PRs"
	jsons := (IceGitHubAPI new
		beAnonymous;
		getPullRequests: githubRemote owner
		project: githubRemote projectName) all.
	prs := jsons collect: [ :each |
			(IceGitHubPullRequest fromJSON: each)
				repository: iceRepo;
				yourself ].

	masterPresenter model: prs.
	super model: anObject.	"Note: refreshOnUpdate shouldn't refresh masterPresenter again "

]
