Class {
	#name : #RiPullRequestMasterDetailPresenter,
	#superclass : #RiMasterDetailPresenter,
	#category : #'Rita-PullRequests-UI'
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
		| iceDiff conversationItems conversationItemsByIceNode |
		iceDiff := aPR diffToBase.
		conversationItems := self allConversationItemsOf: aPR iceDiff: iceDiff.
		conversationItemsByIceNode := self conversationItemsByIceNodeFrom: conversationItems.

		detailPresenter model:
			(model copy 
				add: #pullRequest -> aPR;
				add: #pullRequestDiff -> iceDiff;
				add: #pullRequestConversationItems -> conversationItems;
				add: #conversationItemsByIceNode -> conversationItemsByIceNode;
				yourself) ].

]

{ #category : #private }
RiPullRequestMasterDetailPresenter >> conversationItemsByIceNodeFrom: conversationItems [

	| dictionary |
	dictionary := conversationItems
		groupedBy: [ :each | each hasMapping
			ifTrue: [ each mapping iceNode ]
			ifFalse: [ nil ] ].
	dictionary removeKey: nil.
	^ IdentityDictionary newFrom: dictionary
]

{ #category : #initialization }
RiPullRequestMasterDetailPresenter >> detailPresenterClass [
	^ RiPullRequestDetailPresenter
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
