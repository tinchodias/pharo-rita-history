Class {
	#name : #RiDiffPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'diffPresenter',
		'viewPresenter',
		'iceDiffModel',
		'packageColorScale'
	],
	#category : #'Rita-IceTip-DiffView'
}

{ #category : #specs }
RiDiffPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #viewPresenter;
		spacing: 5;
		add: #diffPresenter;
		yourself
]

{ #category : #private }
RiDiffPresenter >> buildDiffOn: view [
	self subclassResponsibility
]

{ #category : #accessing }
RiDiffPresenter >> diffPresenter: aPresenter [
	diffPresenter := aPresenter

]

{ #category : #accessing }
RiDiffPresenter >> iceDiffModel: anIceDiffModel [

	iceDiffModel := anIceDiffModel.
	viewPresenter refresh.
]

{ #category : #initialization }
RiDiffPresenter >> initializeWidgets [
	viewPresenter := self instantiate: RoassalPresenter.
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
