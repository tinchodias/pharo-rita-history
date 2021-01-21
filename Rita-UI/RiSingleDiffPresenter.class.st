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

	super initializePresenters.
	diffMorphPresenter := self newMorph.

]

{ #category : #initialization }
RiSingleDiffPresenter >> newRubTextMorph [

	^ (model at: #aesthetics) scrolledUnifiedDiffMorph
]

{ #category : #accessing }
RiSingleDiffPresenter >> refreshOnModelUpdate [

	diffMorphPresenter morph: self newRubTextMorph
]

{ #category : #initialization }
RiSingleDiffPresenter >> selectIceNode: anIceNode [

	anIceNode ifNil: [ ^ self ].

	(model at: #aesthetics)
		fillUnifiedDiff: diffMorphPresenter morph textArea
		with: anIceNode value newUnifiedStringDiff
]
