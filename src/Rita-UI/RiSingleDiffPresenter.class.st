Class {
	#name : 'RiSingleDiffPresenter',
	#superclass : 'RiPresenter',
	#instVars : [
		'diffMorphPresenter'
	],
	#category : 'Rita-UI-Spec2-Diff',
	#package : 'Rita-UI',
	#tag : 'Spec2-Diff'
}

{ #category : 'layout' }
RiSingleDiffPresenter class >> defaultLayout [
	^ SpBoxLayout newVertical
		add: #diffMorphPresenter;
		yourself
]

{ #category : 'initialization' }
RiSingleDiffPresenter >> initializePresenters [

	super initializePresenters.
	diffMorphPresenter := self newMorph.

]

{ #category : 'initialization' }
RiSingleDiffPresenter >> newRubTextMorph [

	^ self aesthetics scrolledUnifiedDiffMorph
]

{ #category : 'updating' }
RiSingleDiffPresenter >> refreshOnModelUpdate [

	diffMorphPresenter morph: self newRubTextMorph
]

{ #category : 'initialization' }
RiSingleDiffPresenter >> selectIceNode: anIceNode [

	anIceNode ifNil: [ ^ self ].

	self aesthetics fillUnifiedDiff: diffMorphPresenter morph textArea with: anIceNode value newUnifiedStringDiff
]
