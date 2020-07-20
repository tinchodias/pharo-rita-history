Class {
	#name : #RiFullDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'torchDiffPresenter',
		'treeDiffPresenter',
		'diffPanel'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiFullDiffPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 80 percent;
		add:
			(SpPanedLayout newHorizontal
				position: 50 percent;
				add: #torchDiffPresenter;
				add: #diffPanel;
				yourself);
		add: #treeDiffPresenter;
		yourself
]

{ #category : #initialization }
RiFullDiffPresenter >> initializePresenters [
	torchDiffPresenter := self instantiate: RiTorchDiffPresenter.
	treeDiffPresenter := self instantiate: RiTreeDiffPresenter.
	diffPanel := self instantiate: RiMultipleDiffsPresenter.

]

{ #category : #initialization }
RiFullDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	modelCopy := model copy
		add: #aesthetics -> RiAestheticsModel new;
		add: #blockWhenNodeSelected -> [ :iceNode |
			treeDiffPresenter selectIceNode: iceNode.
			torchDiffPresenter selectIceNode: iceNode.
			diffPanel selectIceNode: iceNode.
			];
		add: #blockWhenNodesHighlighted -> [ :iceNodeCollection |
			treeDiffPresenter highlightIceNode: iceNodeCollection.
			torchDiffPresenter highlightIceNode: iceNodeCollection ];
		add: #blockWhenCheckedNodesChanged -> [ 
			torchDiffPresenter refreshOnCheckedIceNodesChanged.
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #diffQuery -> (RiDiffQuery new
			diff: (model at: #iceDiff);
			onlyConsiderChanged: (model at: #root) considerOnlyChanged;
			yourself);
		yourself.

	torchDiffPresenter model: modelCopy.
	treeDiffPresenter model: modelCopy.
	diffPanel model: modelCopy.

]
