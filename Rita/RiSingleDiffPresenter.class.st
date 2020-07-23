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
	| aesthetics |
	anIceNode ifNil: [ ^ self ].
	aesthetics := model at: #aesthetics.
	diff morph ifNil: [
		diff morph: aesthetics scrolledUnifiedDiffMorph ].
	(anIceNode value rightContents size + anIceNode value leftContents size) <= self limitForDiff
		ifTrue: [ 
			aesthetics
				fillUnifiedDiff: diff morph textArea
				from: anIceNode value rightContents
				to: anIceNode value leftContents ]
		ifFalse: [ 
			| msg |
			msg := 'Too large to compare'.
			aesthetics
				fillUnifiedDiff: diff morph textArea
				from: msg
				to: msg ]

]
