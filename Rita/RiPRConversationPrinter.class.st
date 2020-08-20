Class {
	#name : #RiPRConversationPrinter,
	#superclass : #Object,
	#instVars : [
		'printer',
		'linkBlock',
		'item'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPRConversationPrinter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #textPresenter;
		yourself
]

{ #category : #initialization }
RiPRConversationPrinter >> headerLineFor: aPRComment [
	| timestamp text timestampHumanReadable |
	timestamp := aPRComment createdAt asDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.

	text := aPRComment author asText
		append: ' · ' , timestampHumanReadable;
		append: String lf;
		yourself.
	^ text allBold "makeAllColor: (model at: #aesthetics) secondaryTextColor."

]

{ #category : #private }
RiPRConversationPrinter >> hunkTextForMapping: mapping [

	^ Text streamContents: [ :stream |
		| path line diffString |
		path := self linkToIceNodePointedBy: mapping.

		diffString := mapping iceNode value newUnifiedStringDiff unifiedString.
		line := diffString lines at: mapping iceNodeLineNumber.

		stream
			nextPutAll: path; lf;
			nextPutAll: line; lf; lf ].



]

{ #category : #initialization }
RiPRConversationPrinter >> initialize [
	super initialize.
	printer := RiDateAndTimePrinter new
]

{ #category : #accessing }
RiPRConversationPrinter >> item: anObject [
	item := anObject
]

{ #category : #accessing }
RiPRConversationPrinter >> linkBlock: anObject [
	linkBlock := anObject
]

{ #category : #private }
RiPRConversationPrinter >> linkToIceNodePointedBy: mapping [

	^ mapping iceNode value definition ritaAsTextForPRConversation asText
		addAttribute: (TextAction new actOnClickBlock: linkBlock);
		yourself
]

{ #category : #initialization }
RiPRConversationPrinter >> printAsTextOn: aTextStream [
	item comments do: [ :each |
		aTextStream
			nextPutAll: (self textFor: each) ]
]

{ #category : #initialization }
RiPRConversationPrinter >> textFor: aPRComment [
	| text indentationString body |
	
	text := self headerLineFor: aPRComment.
	indentationString := ''.
	
	aPRComment isHunkComment ifTrue: [
		text prepend: (indentationString := String tab).
		aPRComment isReplyComment ifFalse: [
			text prepend: (self hunkTextForMapping: item mapping) ]].

	body := (MicroDownParser asText: aPRComment body, String cr, '***').
	body := body copyReplaceAll: String cr with: String cr, indentationString.
	text append: body.

	text append: String lf.
	text append: String lf.
	^ text
]
