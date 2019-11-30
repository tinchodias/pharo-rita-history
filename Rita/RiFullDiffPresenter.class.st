Class {
	#name : #RiFullDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'torchDiffPresenter',
		'treeDiffPresenter'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiFullDiffPresenter class >> defaultSpec [
	^ SpPanedLayout newVertical
		add: #torchDiffPresenter;
		add: #treeDiffPresenter;
		yourself
]

{ #category : #initialization }
RiFullDiffPresenter >> initializePresenters [
	torchDiffPresenter := self instantiate: RiTorchDiffPresenter.
	treeDiffPresenter := self instantiate: RiTreeDiffPresenter.
]

{ #category : #initialization }
RiFullDiffPresenter >> refreshOnModelUpdate [
	torchDiffPresenter model: (
		model copy
			add: #blockWhenNodeSelected -> [ :iceNode |
				treeDiffPresenter selectIceNode: iceNode ];
			yourself).
	treeDiffPresenter model: (
		model copy
			add: #blockWhenNodeSelected -> [ :iceNode |
				torchDiffPresenter selectIceNode: iceNode ];
			yourself).
]
