Class {
	#name : #RiPullRequestListAndCommentListPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'masterPresenter',
		'detailPresenter'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPullRequestListAndCommentListPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add: #masterPresenter;
		add: #detailPresenter;
		yourself
]

{ #category : #initialization }
RiPullRequestListAndCommentListPresenter >> connectPresenters [
	masterPresenter blockForPRSelected: [ :aPR |
		detailPresenter model: 
			(model copy 
				add: #pullRequest -> aPR;
				yourself) ].

]

{ #category : #initialization }
RiPullRequestListAndCommentListPresenter >> initializePresenters [
	masterPresenter := self instantiate: RiPullRequestListPresenter.
	detailPresenter := self instantiate: RiPullRequestPresenter2.

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
		getPullRequests: githubRemote owner
		project: githubRemote projectName) all.
	prs := jsons collect: [ :each |
			(IceGitHubPullRequest fromJSON: each)
				repository: iceRepo;
				yourself ].

	masterPresenter model: prs.
	super model: anObject.	"Note: refreshOnUpdate shouldn't refresh masterPresenter again "

]
