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
			self showConversationItem: aRiPullRequestConversationItem ].

	diffMorphPresenter morph addSegment: newSegment.
	segments add: newSegment.

]

{ #category : #private }
RiPRSingleDiffPresenter >> initialize [

	super initialize.
	segments := OrderedCollection new
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

{ #category : #private }
RiPRSingleDiffPresenter >> showConversationItem: aRiPullRequestConversationItem [

	| text| 
	text := Text streamContents: [ :stream | 
		RiPRConversationPrinter new
			item: aRiPullRequestConversationItem;
			linkBlock: [ 1halt ];
			printAsTextOn: stream ].
		
	self showPopoverWith: text

]

{ #category : #initialization }
RiPRSingleDiffPresenter >> showPopoverWith: aText [

	| content |
	content := SpPresenter new 
		layout: (SpBoxLayout newVertical
			borderWidth: 5; 
			spacing: 5;
			add: (self newText
				beNotEditable;
				text: aText;
				yourself);
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
