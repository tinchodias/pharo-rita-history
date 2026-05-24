Class {
	#name : 'RiFullDiffPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'torchDiffPresenter',
		'treeDiffPresenter',
		'sourceDiffWidget'
	],
	#category : 'Rita-UI-Spec2-Diff',
	#package : 'Rita-UI',
	#tag : 'Spec2-Diff'
}

{ #category : 'layout' }
RiFullDiffPresenter >> defaultLayout [

	^ SpPanedLayout newHorizontal
		  positionOfSlider: 75 percent;
		  add: torchDiffPresenter;
		  add: (SpPanedLayout newVertical
				   positionOfSlider: 50 percent;
				   add: treeDiffPresenter;
				   add: sourceDiffWidget;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
RiFullDiffPresenter >> initializePresenters [

	torchDiffPresenter := self instantiate: RiTorchDiffPresenter.
	treeDiffPresenter := self instantiate: RiTreeDiffPresenter.
	sourceDiffWidget := self newMorph
]

{ #category : 'instance creation' }
RiFullDiffPresenter >> newRubTextMorph [

	^ self aesthetics scrolledUnifiedDiffMorph
]

{ #category : 'private' }
RiFullDiffPresenter >> nodesToIterate [
	^ (treeDiffPresenter model at: #diffQuery) allLeafChildren
]

{ #category : 'updating' }
RiFullDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	modelCopy := model copy
		             add: #blockWhenNodeSelected -> [ :iceNode | self selectIceNode: iceNode ];
		             add: #blockWhenNodeExpandToggle -> [ :iceNode | "Note this is uni-directional: It delegates from
			double-click on a box to the tree toggle."
					             treeDiffPresenter selectIceNode: iceNode.
					             treeDiffPresenter doToggleExpandOneLevel ];
		             add: #blockWhenNodeExpandAll -> [
					             (model at: #iceDiff) tree childrenDo: [ :each |
								             treeDiffPresenter selectIceNode: each.
								             treeDiffPresenter doExpandWithAllChildren ] ];
		             add: #blockWhenNodeCollapseAll -> [
					             (model at: #iceDiff) tree childrenDo: [ :each |
								             treeDiffPresenter selectIceNode: each.
								             treeDiffPresenter doCollapseWithAllChildren ] ];
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
	sourceDiffWidget morph: self newRubTextMorph
]

{ #category : 'actions' }
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

{ #category : 'initialization' }
RiFullDiffPresenter >> selectIceNode: iceNode [

	iceNode ifNil: [ ^ self ].
	(model at: #root) announceAction: #select iceNode: iceNode.

	treeDiffPresenter selectIceNode: iceNode.
	torchDiffPresenter selectIceNode: iceNode.

	self aesthetics fillUnifiedDiff: sourceDiffWidget morph textArea with: iceNode value newUnifiedStringDiff
]

{ #category : 'actions' }
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
