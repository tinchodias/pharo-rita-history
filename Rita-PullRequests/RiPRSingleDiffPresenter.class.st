Class {
	#name : #RiPRSingleDiffPresenter,
	#superclass : #RiSingleDiffPresenter,
	#instVars : [
		'segments'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #private }
RiPRSingleDiffPresenter >> addConversationSegmentFor: aRiPullRequestConversationItem [ 

	| newSegment indexInterval diffText label |
	diffText := diffMorphPresenter morph text.
	indexInterval := diffText asString 
		indexCorrespondingToLineNumber: 
			aRiPullRequestConversationItem mapping iceNodeLineNumber.
	label := '{1} comment{2}' format: {
		aRiPullRequestConversationItem numberOfComments.
		aRiPullRequestConversationItem numberOfComments > 1 ifTrue: [ 's' ] ifFalse: [ '' ] }.
	
	newSegment := RubUnderlinedSegmentMorph from: indexInterval first to: indexInterval last.
	newSegment
		underlineColor: self theme textColor;
		icon: (self iconNamed: ZuTheme current conversationIconSelector);
		label: label;
		iconBlock: [
			self openConversationItemWindowFor: aRiPullRequestConversationItem ].

	diffMorphPresenter morph addSegment: newSegment.
	segments add: newSegment.

]

{ #category : #private }
RiPRSingleDiffPresenter >> initialize [

	super initialize.
	segments := OrderedCollection new
]

{ #category : #private }
RiPRSingleDiffPresenter >> openConversationItemWindowFor: aRiPullRequestConversationItem [

	| content textPresenter refreshBlock |
	textPresenter := self newText
				beNotEditable;
				yourself.

	refreshBlock := [
		| aText |
		aText := Text streamContents: [ :stream | 
			RiPRConversationPrinter new
				item: aRiPullRequestConversationItem;
				linkBlock: [ "Ignore" ];
				printAsTextOn: stream ].
		textPresenter text: aText].
		
	content := SpPresenter new 
		layout: (SpBoxLayout newVertical
			spacing: 4;
			add: textPresenter;
			add: (self newButton 
				label: 'Reply...';
				action: [
					"Open window and update from model if there is an update (reply)"
					self
						openReplyWindowFor: aRiPullRequestConversationItem
						onRefreshDo: refreshBlock ];
				yourself)
				expand: false;
			add: (self newButton 
				label: 'Done';
				action: [ content window close ];
				yourself)
				expand: false;
			yourself);
		yourself.

	"initialize with current model"
	refreshBlock value.

	content openWithSpec withWindowDo: [ :window |
		window
			title: 'Comments';
			extent: 500@700 ].

]

{ #category : #private }
RiPRSingleDiffPresenter >> openReplyWindowFor: aRiPullRequestConversationItem onRefreshDo: refreshBlock [

	| aPresenter replyTextPresenter submitBlock |
"	aPresenter := (self instantiate: RiPRCommentReplyPresenter)
		model: aRiPullRequestConversationItem;
		openWithSpec

TODO: EXTRACT ALL HERE ^^^^

"
	replyTextPresenter := self newText
				placeholder: 'Write your reply here...';
				yourself.

	submitBlock := [ 
		replyTextPresenter text ifEmpty: [ self error: 'Cant be empty' ].
		self
			submitReply: replyTextPresenter text string
			for: aRiPullRequestConversationItem
			onSuccess: [ :result |
				aRiPullRequestConversationItem addReply: result.
				self inform: 'Reply accepted'.
				(model at: #blockForRefreshPullRequest) value.
				aPresenter window close.
				refreshBlock value ]
			onError: [ :e | self inform: 'Reply failed: ', e asString. ] ].

	aPresenter := SpPresenter new 
		layout: (SpBoxLayout newVertical
			add: replyTextPresenter;
			add: (self newButton 
				label: 'Submit';
				action: submitBlock;
				yourself)
				expand: false;
			add: (self newButton 
				label: 'Cancel';
				action: [ aPresenter window close ];
				yourself)
				expand: false;
			yourself);
		yourself.

	aPresenter openWithSpec withWindowDo: [ :window |
		window
			title: 'Comments';
			extent: 500@400 ].

]

{ #category : #private }
RiPRSingleDiffPresenter >> removeAllConversationSegments [

	segments do: [ :each | each delete ]
]

{ #category : #initialization }
RiPRSingleDiffPresenter >> selectIceNode: iceNode [

	super selectIceNode: iceNode.

	iceNode ifNil: [ ^ self ].

	self removeAllConversationSegments.
	diffMorphPresenter morph
		withoutTextSegmentIcons;
		withTextSegmentIcons.

	 (model at: #conversationItemsByIceNode) 
		at: iceNode
		ifPresent: [ :items |
			items do: [ :each | self addConversationSegmentFor: each ] ]

]

{ #category : #private }
RiPRSingleDiffPresenter >> submitReply: messageString for: aRiPullRequestConversationItem onSuccess: successBlock onError: errorBlock [

	| commentId result |
	commentId := aRiPullRequestConversationItem commentIdToReply.

	[ result := aRiPullRequestConversationItem pullRequest
			replyComment: messageString
			commentId: commentId.
	] on: Error do: [ :e | errorBlock cull: e ].

	successBlock cull: result

]
