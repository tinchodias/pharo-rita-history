Class {
	#name : #RiFullDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'torchDiffPresenter',
		'treeDiffPresenter',
		'diffPanel'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiFullDiffPresenter class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 55 percent;
		add:
			(SpPanedLayout newHorizontal
				position: 66 percent;
				add: #torchDiffPresenter;
				add: #treeDiffPresenter;
				yourself);
		add: #diffPanel;
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
		add: #diffQuery -> (RiDiffQuery new
			diff: (model at: #iceDiff);
			onlyConsiderChanged: (model at: #root) considerOnlyChanged;
			yourself);
		yourself.

	torchDiffPresenter model: modelCopy.
	treeDiffPresenter model: modelCopy.
	diffPanel model: modelCopy.

]
