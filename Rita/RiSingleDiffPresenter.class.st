Class {
	#name : #RiSingleDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diff',
		'diffMorph'
	],
	#category : #'Rita-UI-Diff'
}

{ #category : #initialization }
RiSingleDiffPresenter >> initializePresenters [
	diff := self newMorph
]

{ #category : #initialization }
RiSingleDiffPresenter >> selectIceNode: anIceNode [
	| aesthetics |
	anIceNode ifNil: [ ^ self ].
	aesthetics := model at: #aesthetics.
	diff morph ifNil: [
		diff morph: aesthetics scrolledUnifiedDiffMorph ].
	aesthetics
		fillUnifiedDiff: diff morph textArea
		from: anIceNode value rightContents
		to: anIceNode value leftContents
]
