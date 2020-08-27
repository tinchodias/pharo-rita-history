Class {
	#name : #RiPullRequestMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-UI-PullRequests'
}

{ #category : #private }
RiPullRequestMasterDetailPresenter >> allConversationItemsOf: aPullRequest iceDiff: anIceDiff [

	| groupedComments reviewCommentsThatBegin reviewCommentsThatReply items |
	groupedComments := aPullRequest reviewComments
		groupedBy: [:each | each isReplyComment ].
	reviewCommentsThatBegin := groupedComments at: false ifAbsent: [ #() ].
	reviewCommentsThatReply := groupedComments at: true ifAbsent: [ #() ].

	items := ((reviewCommentsThatBegin, aPullRequest comments, { aPullRequest })
		sorted: [ :a :b | a creationDateAndTime < b creationDateAndTime ])
		collect: [ :each |
			RiPullRequestConversationItem
				withComment: each
				pullRequest: aPullRequest
				iceDiff: anIceDiff ].

	reviewCommentsThatReply do: [ :each |
		items 
			detect: [ :item | item includesCommentWithId: each repliedId ]
			ifFound: [ :item | item addReply: each ]
			ifNone: [ self error: 'Replied comment not found' ] ].

	^ items
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
RiPullRequestMasterDetailPresenter >> mappingOf: aPullRequestComment in: iceDiff [ 

	| commitToResolve file lineNumber |
	aPullRequestComment isHunkComment ifFalse: [ ^ nil ].

	"Parse file"
	commitToResolve := aPullRequestComment isSideOfAddition
		ifTrue: [ iceDiff sourceVersion ]
		ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: aPullRequestComment path.
	lineNumber := aPullRequestComment originalLine. "line ?"

	^(file extension = 'st'
		ifTrue: [ RiTonelToDiffMapping new ] 
		ifFalse: [ RiFileToDiffMapping new ])
			file: file;
			lineNumber: lineNumber;
			iceDiff: iceDiff; 
			calculate;
			iceComment: aPullRequestComment;
			yourself
]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> masterPresenterClass [
	^ RiPullRequestListPresenter
]

{ #category : #accessing }
RiPullRequestMasterDetailPresenter >> refreshOnModelUpdate [
	| iceRepo githubRemote jsons prs credentials |
	githubRemote := model at: #githubRemote.
	iceRepo := githubRemote localRepository.
	credentials := IceGitHubAPI ensureCredentials.

	"List all PRs"
	jsons := (IceGitHubAPI new
		credentials: credentials;
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
