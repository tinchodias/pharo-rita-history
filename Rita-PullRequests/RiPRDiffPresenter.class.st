Class {
	#name : #RiPRDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'treeDiffPresenter',
		'sourceCodePanel'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPRDiffPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 45 percent;
		add: #treeDiffPresenter;
		add: #sourceCodePanel;
		yourself
]

{ #category : #private }
RiPRDiffPresenter >> conversationItemsByIceNode [

	| dictionary |
	dictionary := (model at: #pullRequestConversationItems) 
		groupedBy: [ :each | each hasMapping
			ifTrue: [ each mapping iceNode ]
			ifFalse: [ nil ] ].
	dictionary removeKey: nil.
	^ IdentityDictionary newFrom: dictionary
]

{ #category : #initialization }
RiPRDiffPresenter >> initializePresenters [
	treeDiffPresenter := self instantiate: RiPRTreeDiffPresenter.
	sourceCodePanel := self instantiate: RiPRSingleDiffPresenter.

]

{ #category : #initialization }
RiPRDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	modelCopy := model copy
		add: #conversationItemsByIceNode -> self conversationItemsByIceNode;
		add: #blockWhenNodeSelected -> [ :iceNode |
			self selectIceNode: iceNode ];
		add: #blockWhenNodeExpandToggle -> [ :iceNode |
			treeDiffPresenter selectIceNode: iceNode.
			treeDiffPresenter doToggleExpandOneLevel ];
		add: #blockWhenNodesHighlighted -> [ :iceNodeCollection | ];
		add: #blockWhenShadowedIceNodesChanged -> [
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #blockWhenExpandedIceNodesChanged -> [
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #diffQuery -> (RiDiffQuery new
			diff: (model at: #iceDiff);
			yourself);
		yourself.

	treeDiffPresenter model: modelCopy.
	sourceCodePanel model: modelCopy.

]

{ #category : #initialization }
RiPRDiffPresenter >> selectIceNode: iceNode [
	treeDiffPresenter selectIceNode: iceNode.
	sourceCodePanel selectIceNode: iceNode
]
