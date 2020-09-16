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

	| aText content |
	aText := Text streamContents: [ :stream | 
		RiPRConversationPrinter new
			item: aRiPullRequestConversationItem;
			linkBlock: [ "Ignore" ];
			printAsTextOn: stream ].
		
	content := SpPresenter new 
		layout: (SpBoxLayout newVertical
			spacing: 4;
			add: (self newText
				beNotEditable;
				text: aText;
				yourself);
			add: (self newButton 
				label: 'Reply...';
				action: [ self openReplyWindowFor: aRiPullRequestConversationItem ];
				yourself)
				expand: false;
			add: (self newButton 
				label: 'Done';
				action: [ content window close ];
				yourself)
				expand: false;
			yourself);
		yourself.

	content openWithSpec withWindowDo: [ :window |
		window
			title: 'Comments';
			extent: 500@700 ].

]

{ #category : #private }
RiPRSingleDiffPresenter >> removeAllConversationSegments [
	segments do: [ :each | each delete ]
]

{ #category : #initialization }
RiPRSingleDiffPresenter >> selectIceNode: iceNode [
	super selectIceNode: iceNode.

	self removeAllConversationSegments.
	diffMorphPresenter morph 
		withoutTextSegmentIcons;
		withTextSegmentIcons.

	iceNode ifNil: [ ^ self ].

	 (model at: #conversationItemsByIceNode) 
		at: iceNode
		ifPresent: [ :items |
			items do: [ :each | self addConversationSegmentFor: each ] ]

]
