Class {
	#name : #RiPullRequestDetailPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPresenter',
		'notebook',
		'header',
		'conversationPresenter',
		'diffPage',
		'conversationPage'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPullRequestDetailPresenter class >> defaultSpec [
	^ SpPanedLayout newVertical
		position: 0.07;
		add: #header;
		add: #notebook;
		yourself
]

{ #category : #private }
RiPullRequestDetailPresenter >> initializeConversationPage [
	conversationPresenter := self instantiate: RiPRConversationPresenter.
	conversationPage := SpNotebookPage
		title: 'Conversation'
		icon: (self iconNamed: ZuTheme current conversationIconSelector)
		provider: [ conversationPresenter ].
	notebook addPage: conversationPage
]

{ #category : #private }
RiPullRequestDetailPresenter >> initializeDiffPage [
	diffPresenter := self instantiate: RiPRDiffPresenter.
	diffPage := SpNotebookPage
		title: 'Diff to base'
		icon: (self iconNamed: ZuTheme current changeIconSelector)
		provider: [ diffPresenter ].
	notebook addPage: diffPage
]

{ #category : #initialization }
RiPullRequestDetailPresenter >> initializePresenters [
	header := self instantiate: RiPRHeaderPresenter.
	notebook := self newNotebook.
	self initializeConversationPage.
	self initializeDiffPage.
]

{ #category : #accessing }
RiPullRequestDetailPresenter >> refreshOnModelUpdate [
	| iceDiff |
	header model: model.
	
	conversationPresenter model: (model copy
		add: #blockWhenNodeSelected -> [ :iceNode |
			notebook selectPage: diffPage.
			diffPresenter selectIceNode: iceNode ];
		yourself).
	
	iceDiff := model at: #pullRequestDiff.
	diffPresenter model: (model copy
				add: #iceDiff -> iceDiff;
				add: #shadowedIceNodes -> IdentitySet new;
				add: #expandedIceNodes -> (RiVisibleTreeStrategy 
					expandedIceNodesFrom: {iceDiff tree});
				yourself)
]
