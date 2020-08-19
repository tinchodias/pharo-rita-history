Class {
	#name : #RiSingleDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffMorphPresenter'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #specs }
RiSingleDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #diff;
		yourself
]

{ #category : #initialization }
RiSingleDiffPresenter >> initializePresenters [
	diffMorphPresenter := self newMorph
]

{ #category : #accessing }
RiSingleDiffPresenter >> limitForDiff [
	^ 20000
]

{ #category : #initialization }
RiSingleDiffPresenter >> selectIceNode: anIceNode [
	| aesthetics left right |
	anIceNode ifNil: [ ^ self ].

	aesthetics := model at: #aesthetics.
	diffMorphPresenter morph ifNil: [
		diffMorphPresenter morph: aesthetics scrolledUnifiedDiffMorph ].

	right := anIceNode value rightContents.
	left := anIceNode value leftContents.
	(right size + left size) > self limitForDiff
		ifTrue: [ left := right := 'Too large to compare' ].
		
	aesthetics
		fillUnifiedDiff: diffMorphPresenter morph textArea
		from: right
		to: left

]
