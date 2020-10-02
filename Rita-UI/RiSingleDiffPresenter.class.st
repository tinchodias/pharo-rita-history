Class {
	#name : #RiSingleDiffPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'diffMorphPresenter'
	],
	#category : #'Rita-UI-Spec2-Diff'
}

{ #category : #specs }
RiSingleDiffPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #diffMorphPresenter;
		yourself
]

{ #category : #initialization }
RiSingleDiffPresenter >> initializePresenters [
	diffMorphPresenter := self newMorph
]

{ #category : #initialization }
RiSingleDiffPresenter >> selectIceNode: anIceNode [
	| aesthetics|
	anIceNode ifNil: [ ^ self ].

	aesthetics := model at: #aesthetics.
	diffMorphPresenter morph ifNil: [
		diffMorphPresenter morph: aesthetics scrolledUnifiedDiffMorph ].

	aesthetics
		fillUnifiedDiff: diffMorphPresenter morph textArea
		with: anIceNode value newUnifiedStringDiff
]
