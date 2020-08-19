Class {
	#name : #RiSingleDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diff',
		'diffMorph'
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
	diff := self newMorph
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
	diff morph ifNil: [
		diff morph: aesthetics scrolledUnifiedDiffMorph ].

	(anIceNode value rightContents size + anIceNode value leftContents size) <= self limitForDiff
		ifTrue: [
			right := anIceNode value rightContents.
			left := anIceNode value leftContents ]
		ifFalse: [
			left := right := 'Too large to compare' ].
		
	aesthetics
		fillUnifiedDiff: diff morph textArea
		from: right
		to: left

]
