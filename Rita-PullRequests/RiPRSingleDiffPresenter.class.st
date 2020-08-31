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

	| newSegment indexInterval diffText |
	diffText := diffMorphPresenter morph text.
	indexInterval := diffText asString indexCorrespondingToLineNumber: aRiPullRequestConversationItem mapping iceNodeLineNumber.
	
	newSegment := RubUnderlinedSegmentMorph from: indexInterval first to: indexInterval last.
	newSegment
		icon: (self iconNamed: ZuTheme current changeIconSelector);
		label: 'Conversation';
		iconBlock: [
			aRiPullRequestConversationItem inspect ].

	diffMorphPresenter morph addSegment: newSegment.
	segments add: newSegment.

]

{ #category : #private }
RiPRSingleDiffPresenter >> removeAllConversationSegments [
	segments ifNil: [ segments := OrderedCollection new ].
	segments do: [ :each | diffMorphPresenter morph textArea removeSegment: each ]
]

{ #category : #initialization }
RiPRSingleDiffPresenter >> selectIceNode: iceNode [
	super selectIceNode: iceNode.
	iceNode ifNil: [ ^ self ].

	self defer: [
		diffMorphPresenter morph withTextSegmentIcons].

	 (model at: #conversationItemsByIceNode) 
		at: iceNode
		ifPresent: [ :items |
			self removeAllConversationSegments.
			items do: [ :each | self addConversationSegmentFor: each ] ]

]
