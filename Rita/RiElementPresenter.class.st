Class {
	#name : #RiElementPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'summaryLabel',
		'diffPresenter'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #summaryLabel withConstraints: [ :constraints | constraints height: self labelHeight ];
		add: #diffPresenter;
		yourself
]

{ #category : #initialization }
RiElementPresenter >> blockForSpawn: aBlock [
	diffPresenter blockForSpawn: aBlock
]

{ #category : #initialization }
RiElementPresenter >> initializePresenters [
	summaryLabel := self newLabel.

	diffPresenter := self instantiate: RiElementDiffPresenter.

]

{ #category : #initialization }
RiElementPresenter >> refreshOnModelUpdate [
	summaryLabel label: 'SHA: ', model shortId.

	diffPresenter
		model:
			(model isUncommited
				ifTrue: [ nil ]
				ifFalse: [ model iceCommit diffToParent ])
]
