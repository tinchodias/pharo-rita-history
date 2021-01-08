Class {
	#name : #RiPRConversationPrinter,
	#superclass : #Object,
	#instVars : [
		'printer',
		'linkBlock',
		'item'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPRConversationPrinter class >> defaultSpec [

	^ SpBoxLayout newVertical
		  add: #textPresenter;
		  yourself
]

{ #category : #initialization }
RiPRConversationPrinter >> headerLineFor: aPRComment [

	| timestamp text timestampHumanReadable username avatarUrl htmlUrl result |
	timestamp := aPRComment creationDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.
	username := aPRComment author.
	avatarUrl := aPRComment authorAvatarUrl.
	htmlUrl := aPRComment authorHtmlUrl.

	"![avatar]({2})"
	text := 'User [{1}]({3}) commented ({4}):' format: { username. avatarUrl. htmlUrl. timestampHumanReadable }.

	result := MicroDownParser asText: text.
	"FIX: remove first cr line"
	self assert: result first = Character cr.
	result replaceFrom: 1 to: 1 with: ''.

	^ result
]

{ #category : #private }
RiPRConversationPrinter >> hunkTextForMapping: mapping [

	| result |
	result := Text streamContents: [ :stream |
		| path line diffString |
		path := self linkToIceNodePointedBy: mapping.

		diffString := mapping iceNode value newUnifiedStringDiff unifiedString.
		line := diffString lines at: mapping iceNodeLineNumber.

		"FIX"
		line := line asText.
		line prepend: ('Line {1}:	' format: {mapping iceNodeLineNumber}).
		line addAttribute: (TextFontReference toFont: (LogicalFont 
			familyName: 'Source Code Pro' 
			pointSize: StandardFonts defaultFont pointSize)).

		stream
			nextPutAll: 'Comments at ';
			nextPutAll: path; cr;
			nextPutAll: line; cr ].

"	result addAttribute: (TextBackgroundColor color: Color yellow translucent).

"

	result append: String cr.
	
	^ result
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

	(item comments reject: #isOutdated) do: [ :each | 
		aTextStream nextPutAll: (self textFor: each) ]
]

{ #category : #initialization }
RiPRConversationPrinter >> textFor: aPRComment [

	| result indentCount body |
	indentCount := 0.
	result := '' asText.

	aPRComment isHunkComment ifTrue: [
		indentCount := 1.
		aPRComment isReplyComment ifFalse: [
			result append: (self hunkTextForMapping: item mapping) ]].

	body := self headerLineFor: aPRComment.
	body append: (MicroDownParser asText: aPRComment body, String cr, '***').
	body addAttribute: (TextIndent tabs: indentCount).

	result append: body.
	result append: String lf.
	result append: String lf.

	^ result

]
