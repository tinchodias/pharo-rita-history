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
RiPRConversationPresenter >> conversationItems [
	| aPR commentsToSort sortedComments |
	aPR := model at: #pullRequest.
	commentsToSort := aPR reviewComments.

	sortedComments := (commentsToSort select: [:each | each repliedId isNil ]) asOrderedCollection.
	sortedComments := (sortedComments, aPR comments) sorted: [ :a :b | a createdAt asDateAndTime < b createdAt asDateAndTime ].
	sortedComments := sortedComments asOrderedCollection.

	commentsToSort
		select: [:each | each repliedId notNil ]
		thenDo: [ :each |
			| repliedComment |
			repliedComment := sortedComments detect: [ :c | c id = each repliedId ].
			sortedComments add: each after: repliedComment ].
	^ {aPR}, sortedComments
]

{ #category : #private }
RiPRConversationPresenter >> hunkTextFor: aPRComment [
	^ Text streamContents: [ :stream |
		| path line |
		path := aPRComment path asText makeAllColor: (self theme textColor alpha: 0.7).
		line := (aPRComment originalPosition asString, ':	', (aPRComment diffHunk lines at: (aPRComment originalPosition+1))) asText
						addAttribute: (TextFontReference
						toFont: (LogicalFont 
							familyName: 'Source Code Pro' 
							pointSize: StandardFonts defaultFont pointSize)).
		stream
			nextPutAll: path; lf;
			nextPutAll: line; lf; lf.
		 ].

]

{ #category : #initialization }
RiPRConversationPresenter >> initializePresenters [
	textPresenter := self newText.
	printer := RiDateAndTimePrinter new
]

{ #category : #initialization }
RiPRConversationPresenter >> refreshOnModelUpdate [
	textPresenter text: (self textForAll: self conversationItems)
]

{ #category : #initialization }
RiPRConversationPresenter >> textFor: aPRComment [
	| timestamp text timestampHumanReadable |
	timestamp := aPRComment createdAt asDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.

	text := aPRComment author asText
		append: ' · ' , timestampHumanReadable;
		append: String lf;
		yourself.
	text := text allBold makeAllColor: (model at: #aesthetics) colorForNames.
	
	aPRComment path ifNotNil: [
		self flag: #todo.
		text append: String tab.
		text prepend: String tab.
		aPRComment repliedId ifNil: [ 
			text prepend: (self hunkTextFor: aPRComment) ]].
		
	text append: (MicroDownParser asText: aPRComment body).
	text append: String lf.
	text append: String lf.
	^ text
]

{ #category : #initialization }
RiPRConversationPresenter >> textForAll: aListOfPRComments [
	^ Text
		streamContents: [ :stream | 
			aListOfPRComments
				do: [ :each | stream nextPutAll: (self textFor: each) ] ]
]
