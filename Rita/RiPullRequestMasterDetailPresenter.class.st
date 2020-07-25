Class {
	#name : #RiPullRequestMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> connectMasterToDetail [
	masterPresenter blockForPRSelected: [ :aPR |
		detailPresenter model: 
			(model copy 
				add: #pullRequest -> aPR;
				yourself) ].

]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> detailPresenterClass [
	^ RiPullRequestPresenter2
]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> masterPresenterClass [
	^ RiPullRequestListPresenter
]

{ #category : #accessing }
RiPullRequestMasterDetailPresenter >> refreshOnModelUpdate [
	| iceRepo githubRemote jsons prs |

	githubRemote := model at: #githubRemote.
	iceRepo := githubRemote localRepository.

	"List all PRs"
	jsons := (IceGitHubAPI new
		beAnonymous;
		getPullRequests: githubRemote owner
		project: githubRemote projectName) all.
	prs := jsons collect: [ :each |
			(IceGitHubPullRequest fromJSON: each)
				repository: iceRepo;
				yourself ].

	masterPresenter model: (model copy
		at: #pullRequestsToShow put: prs;
		yourself)
]
