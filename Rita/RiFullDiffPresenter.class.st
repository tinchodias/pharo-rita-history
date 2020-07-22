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

{ #category : #initialization }
RiFullDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	modelCopy := model copy
		add: #aesthetics -> RiAestheticsModel new;
		add: #blockWhenNodeSelected -> [ :iceNode |
			treeDiffPresenter selectIceNode: iceNode.
			torchDiffPresenter selectIceNode: iceNode.
			sourceCodePanel selectIceNode: iceNode.
			];
		add: #blockWhenNodesHighlighted -> [ :iceNodeCollection |
			treeDiffPresenter highlightIceNode: iceNodeCollection.
			torchDiffPresenter highlightIceNode: iceNodeCollection ];
		add: #blockWhenShadowedIceNodesChanged -> [ 
			torchDiffPresenter refreshOnCheckedIceNodesChanged.
			treeDiffPresenter refreshOnCheckedIceNodesChanged ];
		add: #blockWhenCollapsedIceNodesChanged -> [
			torchDiffPresenter refreshOnModelUpdate.
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
