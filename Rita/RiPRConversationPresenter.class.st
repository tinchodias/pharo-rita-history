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
RiPRConversationPresenter >> hunkTextForMapping: mapping [

	^ Text streamContents: [ :stream |
		| path line |
		path := self linkToIceNodePointedBy: mapping.
		line := mapping hunkString.
		stream
			nextPutAll: path; lf;
			nextPutAll: line; lf; lf ].



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
		addAttribute: (TextAction new actOnClickBlock: [ self selectIceNodePointedBy: mapping ]);
		yourself
]

{ #category : #initialization }
RiPRConversationPresenter >> refreshOnModelUpdate [
	textPresenter text: self textForAllConversationItems
]

{ #category : #private }
RiPRConversationPresenter >> selectIceNodePointedBy: mapping [

	mapping halt
]

{ #category : #initialization }
RiPRConversationPresenter >> textFor: itemAssociation [
	| aPRComment text indentationString body |
	aPRComment := itemAssociation key.
	
	text := self headerLineFor: aPRComment.
	indentationString := ''.
	
	aPRComment isHunkComment ifTrue: [
		text prepend: (indentationString := String tab).
		aPRComment isReplyComment ifFalse: [
			text prepend: (self hunkTextForMapping: itemAssociation value) ]].

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
