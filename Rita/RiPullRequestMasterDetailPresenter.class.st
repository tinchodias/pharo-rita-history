Class {
	#name : #RiPullRequestMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #private }
RiPullRequestMasterDetailPresenter >> allConversationItemsOf: anIceGitHubPullRequest iceDiff: anIceDiff [ 
	
	^ anIceGitHubPullRequest sortedConversationItems collect: [ :each | each -> (self mappingOf: each in: anIceDiff) ]
]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> connectMasterToDetail [
	masterPresenter blockForPRSelected: [ :aPR |
		| iceDiff conversationItems |
		iceDiff := aPR diffToBase.
		conversationItems := self allConversationItemsOf: aPR iceDiff: iceDiff.
		
		detailPresenter model:
			(model copy 
				add: #pullRequest -> aPR;
				add: #pullRequestDiff -> iceDiff;
				add: #pullRequestConversationItems -> conversationItems;
				yourself) ].

]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> detailPresenterClass [
	^ RiPullRequestDetailPresenter
]

{ #category : #private }
RiPullRequestMasterDetailPresenter >> mappingOf: anIceGitHubPullRequestComment in: iceDiff [ 

	| commitToResolve file lineNumber mapping |
	self flag: #todo. "FIX FIX FIX"
	(anIceGitHubPullRequestComment isKindOf: IceGitHubPullRequestComment)
		ifFalse: [ ^ nil ].
	anIceGitHubPullRequestComment isHunkComment
		ifFalse: [ ^ nil ].

	"Parse file"
	commitToResolve := anIceGitHubPullRequestComment isSideOfAddition
		ifTrue: [ iceDiff sourceVersion ]
		ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: anIceGitHubPullRequestComment path.
	lineNumber := anIceGitHubPullRequestComment originalLine. "line ?"

	^(file extension = 'st'
		ifTrue: [ RiTonelToDiffMapping new ] 
		ifFalse: [ RiFileToDiffMapping new ])
			file: file;
			lineNumber: lineNumber;
			iceDiff: iceDiff; 
			calculate;
			iceComment: anIceGitHubPullRequestComment;
			yourself
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
