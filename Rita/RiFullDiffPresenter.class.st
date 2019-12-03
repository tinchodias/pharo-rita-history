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
	diffPanel := self instantiate: RiUnifiedDiffPresenter.

]

{ #category : #initialization }
RiFullDiffPresenter >> refreshOnModelUpdate [

	| modelCopy |
	diffPanel reset.

	modelCopy := model copy
		add: #aesthetics -> RiAestheticsModel new;
		add: #blockWhenNodeSelected -> [ :iceNode |
			treeDiffPresenter selectIceNode: iceNode.
			torchDiffPresenter selectIceNode: iceNode.
			iceNode value ifNotNil: [ :iceOperation |
				diffPanel model: { 
					#from -> iceOperation rightContents.
					#to -> iceOperation leftContents } asDictionary ].
			];
		yourself.

	torchDiffPresenter model: modelCopy.
	treeDiffPresenter model: modelCopy.
]
