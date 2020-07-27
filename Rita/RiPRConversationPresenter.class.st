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

{ #category : #initialization }
RiPRConversationPresenter >> headerLineFor: aPRComment [
	| timestamp text timestampHumanReadable |
	timestamp := aPRComment createdAt asDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.

	text := aPRComment author asText
		append: ' · ' , timestampHumanReadable;
		append: String lf;
		yourself.
	^ text allBold makeAllColor: (model at: #aesthetics) colorForNames.

]

{ #category : #private }
RiPRConversationPresenter >> hunkTextFor: anIceGitHubPullRequestComment [
	^ Text streamContents: [ :stream |
		| path line |
		path := self linkToIceNodePointedBy: anIceGitHubPullRequestComment.
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
RiPRConversationPresenter >> linkToIceNodePointedBy: anIceGitHubPullRequestComment [
	| iceDiff file originalSHA commitToResolve mapping lineNumber |
	"Get diff"
	originalSHA := anIceGitHubPullRequestComment originalCommitSHA.
	iceDiff := ((model at: #repository) commitAt: originalSHA) diffTo: (model at: #pullRequest) baseCommit.

	"Parse file"
	commitToResolve := anIceGitHubPullRequestComment isSideOfAddition
		ifTrue: [ iceDiff sourceVersion ] ifFalse: [ iceDiff targetVersion ].
	file := commitToResolve fileSystem resolveString: anIceGitHubPullRequestComment path.
	lineNumber := anIceGitHubPullRequestComment originalLine.

	mapping := file extension = 'st'
		ifTrue: [ RiTonelToDiffMapping new ] 
		ifFalse: [ RiFileToDiffMapping new ].
	
	mapping
		file: file;
		lineNumber: lineNumber;
		iceDiff: iceDiff; 
		calculate;
		yourself.

	^ (mapping iceNode value definition ritaGlobalDescription", ', line ' , mapping iceNodeLineNumber asString") asText
		addAttribute: (TextAction new actOnClickBlock: [ { mapping iceNode. mapping iceNodeLineNumber. iceDiff. anIceGitHubPullRequestComment } inspect ])
]

{ #category : #initialization }
RiPRConversationPresenter >> refreshOnModelUpdate [
	textPresenter text: (self textForAll: self conversationItems)
]

{ #category : #initialization }
RiPRConversationPresenter >> textFor: aPRComment [
	| text indentationString body |
	text := self headerLineFor: aPRComment.
	indentationString := ''.
	
	aPRComment path ifNotNil: [
		text prepend: (indentationString := String tab).
		aPRComment repliedId ifNil: [ 
			text prepend: (self hunkTextFor: aPRComment) ]].

	body := (MicroDownParser asText: aPRComment body, String cr, '***').
	body := body copyReplaceAll: String cr with: String cr, indentationString.
	text append: body.

	text append: String lf.
	text append: String lf.
	^ text
]

{ #category : #initialization }
RiPRConversationPresenter >> textForAll: aListOfPRComments [
	^ Text streamContents: [ :stream | 
			aListOfPRComments do: [ :each |
				stream nextPutAll: (self textFor: each) ] ]
]
