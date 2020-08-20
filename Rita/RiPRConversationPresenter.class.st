Class {
	#name : #RiPRConversationPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'textPresenter'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPRConversationPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #textPresenter;
		yourself
]

{ #category : #initialization }
RiPRConversationPresenter >> initializePresenters [
	textPresenter := self newText
		beNotEditable;
		yourself.
]

{ #category : #initialization }
RiPRConversationPresenter >> refreshOnModelUpdate [
	textPresenter text: self textForAllConversationItems
]

{ #category : #private }
RiPRConversationPresenter >> selectIceNodePointedBy: x [

	x halt
]

{ #category : #initialization }
RiPRConversationPresenter >> textForAllConversationItems [
	^ Text streamContents: [ :stream | 
		(model at: #pullRequestConversationItems) do: [ :each |
			RiPRConversationPrinter new
				item: each;
				linkBlock: [ self selectIceNodePointedBy: each ];
				printAsTextOn: stream ] ]
]
