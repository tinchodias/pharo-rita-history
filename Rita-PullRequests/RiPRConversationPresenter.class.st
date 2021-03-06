Class {
	#name : #RiPRConversationPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'textPresenter'
	],
	#category : #'Rita-PullRequests-UI'
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
RiPRConversationPresenter >> selectIceNodePointedBy: aConversationItem [

	(model at: #blockWhenNodeSelected) value: aConversationItem mapping iceNode
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
