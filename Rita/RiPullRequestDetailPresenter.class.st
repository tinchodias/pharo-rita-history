Class {
	#name : #RiPullRequestDetailPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffPresenter',
		'notebook',
		'header'
	],
	#category : #'Rita-UI-PullRequests'
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
		icon: (self iconNamed: #announcement)
		provider: [ self newConversationPresenter ].
	notebook addPage: page
]

{ #category : #private }
RiPullRequestDetailPresenter >> initializeDiffPage [
	| page |
	page := SpNotebookPage
		title: 'Diff'
		icon: (self iconNamed: #diff)
		provider: [ self newDiffPresenter ].
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
	RiPRConversationPresenter
]

{ #category : #private }
RiPullRequestDetailPresenter >> newDiffPresenter [
	| iceDiff |
	iceDiff := (model at: #pullRequest) diffToBase.
	^ (self instantiate: RiPRDiffPresenter)
			model: (model copy
				add: #iceDiff -> iceDiff;
				add: #shadowedIceNodes -> IdentitySet new;
				add: #expandedIceNodes -> (RiVisibleTreeStrategy 
					expandedIceNodesFrom: ({iceDiff tree}, iceDiff tree children));
				yourself);
			yourself
]

{ #category : #accessing }
RiPullRequestDetailPresenter >> refreshOnModelUpdate [
	header model: model.
	notebook resetAllPageContents.
]
