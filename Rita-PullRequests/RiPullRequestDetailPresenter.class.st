Class {
	#name : #RiPullRequestDetailPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPresenter',
		'notebook',
		'header'
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
	| page |
	page := SpNotebookPage
		title: 'Conversation'
		icon: (self iconNamed: ZuTheme current conversationIconSelector)
		provider: [ model
				ifNil: [ self newNullPresenter ]
				ifNotNil: [ self newConversationPresenter ] ].
	notebook addPage: page
]

{ #category : #private }
RiPullRequestDetailPresenter >> initializeDiffPage [
	| page |
	page := SpNotebookPage
		title: 'Diff to base'
		icon: (self iconNamed: ZuTheme current changeIconSelector)
		provider: [ model
				ifNil: [ self newNullPresenter ]
				ifNotNil: [ self newDiffPresenter ] ].
	notebook addPage: page
]

{ #category : #initialization }
RiPullRequestDetailPresenter >> initializePresenters [
	header := self instantiate: RiPRHeaderPresenter.
	notebook := self newNotebook.
	self initializeConversationPage.
	self initializeDiffPage.
]

{ #category : #private }
RiPullRequestDetailPresenter >> newConversationPresenter [
	^ (self instantiate: RiPRConversationPresenter)
		model: model;
		yourself
]

{ #category : #private }
RiPullRequestDetailPresenter >> newDiffPresenter [
	| iceDiff |
	iceDiff := model at: #pullRequestDiff.
	^ (self instantiate: RiPRDiffPresenter)
			model: (model copy
				add: #iceDiff -> iceDiff;
				add: #shadowedIceNodes -> IdentitySet new;
				add: #expandedIceNodes -> (RiVisibleTreeStrategy 
					expandedIceNodesFrom: {iceDiff tree});
				yourself);
			yourself
]

{ #category : #accessing }
RiPullRequestDetailPresenter >> refreshOnModelUpdate [
	header model: model.
	notebook resetAllPageContents.
]
