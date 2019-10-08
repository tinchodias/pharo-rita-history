Class {
	#name : #RiTorchLikeSettingsPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'colorByPackageCheckBox',
		'draggableCheckBox',
		'onChangeBlock'
	],
	#category : #'Rita-Torch'
}

{ #category : #specs }
RiTorchLikeSettingsPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
		add: #colorByPackageCheckBox
			withConstraints: [ :constraints | constraints height: self inputTextHeight ];
		add: #draggableCheckBox
			withConstraints: [ :constraints | constraints height: self inputTextHeight ];
		yourself
]

{ #category : #examples }
RiTorchLikeSettingsPresenter class >> example1 [
	(RiTorchLikeSettingsPresenter new
		onChangeBlock: [ self inform: 'changed' ];
		openWithSpec)
		withWindowDo: [ :window | 
			window
				extent: 200 @ 100;
				title: 'Settings' ]
]

{ #category : #initialization }
RiTorchLikeSettingsPresenter >> initializeWidgets [
	onChangeBlock := [].

	colorByPackageCheckBox := self newCheckBox
		label: 'Color by package';
		whenChangedDo: [ onChangeBlock value ]
		yourself.
	draggableCheckBox := self newCheckBox
		label: 'Draggable classes';
		whenChangedDo: [ onChangeBlock value ]
		yourself
]

{ #category : #accessing }
RiTorchLikeSettingsPresenter >> onChangeBlock: aBlock [
	onChangeBlock := aBlock

]
