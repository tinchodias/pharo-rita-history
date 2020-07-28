Class {
	#name : #RiFullDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'torchDiffPresenter',
		'treeDiffPresenter',
		'sourceCodePanel'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiFullDiffPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 60 percent;
		add: #torchDiffPresenter;
		add:
			(SpPanedLayout newVertical
				position: 50 percent;
				add: #treeDiffPresenter;
				add: #sourceCodePanel;
				yourself) yourself
]

{ #category : #initialization }
RiFullDiffPresenter >> initializePresenters [
	torchDiffPresenter := self instantiate: RiTorchDiffPresenter.
	treeDiffPresenter := self instantiate: RiTreeDiffPresenter.
	sourceCodePanel := self instantiate: RiSingleDiffPresenter.

]

{ #category : #private }
RiFullDiffPresenter >> nodesToIterate [
	^ (treeDiffPresenter model at: #diffQuery) allLeafChildren
]

{ #category : #initialization }
RiFullDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	modelCopy := model copy
		add: #blockWhenNodeSelected -> [ :iceNode |
			self selectIceNode: iceNode ];
		add: #blockWhenNodeExpandToggle -> [ :iceNode |
			treeDiffPresenter selectIceNode: iceNode.
			treeDiffPresenter doToggleExpandOneLevel ];
		add: #blockWhenNodesHighlighted -> [ :iceNodeCollection |
			treeDiffPresenter highlightIceNode: iceNodeCollection.
			torchDiffPresenter highlightIceNode: iceNodeCollection ];
		add: #blockWhenShadowedIceNodesChanged -> [ 
			torchDiffPresenter refreshOnCheckedIceNodesChanged.
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #blockWhenExpandedIceNodesChanged -> [
			torchDiffPresenter
				refreshOnModelUpdate;
				refreshOnCheckedIceNodesChanged.
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #diffQuery -> (RiDiffQuery new
			diff: (model at: #iceDiff);
			onlyConsiderChanged: (model at: #root) considerOnlyChanged;
			yourself);
		yourself.

	torchDiffPresenter model: modelCopy.
	treeDiffPresenter model: modelCopy.
	sourceCodePanel model: modelCopy.

]

{ #category : #actions }
RiFullDiffPresenter >> selectBackIceNode [
| iceNodes index iceNode |
	iceNodes := self nodesToIterate.
	iceNodes ifEmpty: [ ^self ].
	iceNode := treeDiffPresenter selectedIceNode
		ifNil: [ iceNodes first.] 
		ifNotNil: [ :currentIceNode |
			index := iceNodes detectIndex: [ :each |
				each == currentIceNode ] ifNone: [ 1 ].
			index = 1 ifTrue: [
				^ self inform: 'At start' ].
			iceNodes at: index - 1 ].

	self selectIceNode: iceNode
]

{ #category : #initialization }
RiFullDiffPresenter >> selectIceNode: iceNode [
	treeDiffPresenter selectIceNode: iceNode.
	torchDiffPresenter selectIceNode: iceNode.
	sourceCodePanel selectIceNode: iceNode
]

{ #category : #actions }
RiFullDiffPresenter >> selectNextIceNode [
	| iceNodes index iceNode |
	iceNodes := self nodesToIterate.
	iceNodes ifEmpty: [ ^self ].
	iceNode := treeDiffPresenter selectedIceNode
		ifNil: [ iceNodes first ] 
		ifNotNil: [ :currentIceNode |
			index := iceNodes detectIndex: [ :each |
				each == currentIceNode ] ifNone: [ 0 ].
			index = iceNodes size ifTrue: [
				^ self inform: 'At end' ].
			iceNodes at: index + 1 ].

	self selectIceNode: iceNode
]
