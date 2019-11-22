Class {
	#name : #RiDiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'diffPresenter',
		'viewPresenter',
		'iceDiffModel',
		'packageColorScale'
	],
	#category : #'Rita-Torch-Old'
}

{ #category : #specs }
RiDiffPresenter class >> defaultSpec [
	^ SpecLayout composed
		newColumn: [ :col | 
			col
				add: #viewPresenter;
				addSplitter;
				add: #diffPresenter;
				yourself ]
]

{ #category : #private }
RiDiffPresenter >> buildDiffOn: view [
	self subclassResponsibility
]

{ #category : #accessing }
RiDiffPresenter >> diffPresenter [
	^ diffPresenter
]

{ #category : #accessing }
RiDiffPresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

]

{ #category : #accessing }
RiDiffPresenter >> iceDiffModel [
	^ iceDiffModel
]

{ #category : #accessing }
RiDiffPresenter >> iceDiffModel: anIceDiffModel [

	iceDiffModel := anIceDiffModel.
	viewPresenter refresh.
]

{ #category : #initialization }
RiDiffPresenter >> initializeWidgets [
	viewPresenter := self instantiate: Spec1RoassalPresenter.
	viewPresenter script: [ :view | self buildDiffOn: view ].
]

{ #category : #private }
RiDiffPresenter >> packageColorScale [
	^ packageColorScale ifNil: [ packageColorScale := TSScale category10 ]
]

{ #category : #private }
RiDiffPresenter >> packageColorScale: aScale [
	packageColorScale := aScale
]

{ #category : #accessing }
RiDiffPresenter >> viewPresenter [
	^ viewPresenter
]
