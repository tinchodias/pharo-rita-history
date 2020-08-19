Class {
	#name : #RiPRConversationPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'textPresenter',
		'printer'
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
RiPRConversationPresenter >> headerLineFor: aPRComment [
	| timestamp text timestampHumanReadable |
	timestamp := aPRComment createdAt asDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.

	text := aPRComment author asText
		append: ' · ' , timestampHumanReadable;
		append: String lf;
		yourself.
	^ text allBold makeAllColor: (model at: #aesthetics) secondaryTextColor.

]

{ #category : #private }
RiPRConversationPresenter >> hunkTextForComment: anIceGitHubPullRequestComment mapping: mappingOrNil [

	^ Text streamContents: [ :stream |
		| path line |
		path := self linkToIceNodePointedBy: mappingOrNil.
		line := anIceGitHubPullRequestComment diffHunk lines
			at: (anIceGitHubPullRequestComment originalLine+1). "GH is zero-based"
		stream
			nextPutAll: path; lf;
			nextPutAll: line; lf; lf.
		 ].



]

{ #category : #initialization }
RiPRConversationPresenter >> initializePresenters [
	textPresenter := self newText
		beNotEditable;
		yourself.
	printer := RiDateAndTimePrinter new
]

{ #category : #private }
RiPRConversationPresenter >> linkToIceNodePointedBy: mapping [

	^ mapping iceNode value definition ritaAsTextForPRConversation asText
		addAttribute: (TextAction new actOnClickBlock: [ mapping inspect ]);
		yourself
]

{ #category : #initialization }
RiPRConversationPresenter >> refreshOnModelUpdate [
	textPresenter text: self textForAllConversationItems
]

{ #category : #initialization }
RiPRConversationPresenter >> textFor: itemAssociation [
	| aPRComment mappingOrNil text indentationString body |
	aPRComment := itemAssociation key.
	mappingOrNil := itemAssociation value.
	
	text := self headerLineFor: aPRComment.
	indentationString := ''.
	
	aPRComment isHunkComment ifTrue: [
		text prepend: (indentationString := String tab).
		aPRComment isReplyComment ifFalse: [
			text prepend: (self hunkTextForComment: aPRComment mapping: mappingOrNil) ]].

	body := (MicroDownParser asText: aPRComment body, String cr, '***').
	body := body copyReplaceAll: String cr with: String cr, indentationString.
	text append: body.

	text append: String lf.
	text append: String lf.
	^ text
]

{ #category : #initialization }
RiPRConversationPresenter >> textForAllConversationItems [
	^ Text streamContents: [ :stream | 
			(model at: #pullRequestConversationItems) do: [ :each |
				stream nextPutAll: (self textFor: each) ] ]
]
