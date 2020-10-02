Class {
	#name : #RiClassSearchPage,
	#superclass : #RiPackageSearchPage,
	#instVars : [
		'classNameInput'
	],
	#category : #'Rita-UI-Spec2-Search'
}

{ #category : #specs }
RiClassSearchPage class >> defaultSpec [
	^ super defaultSpec
		add: #classNameInput height: self labelledInputHeight;
		yourself
]

{ #category : #accessing }
RiClassSearchPage >> checkIfInvalid: aBlockClosure [
	super checkIfInvalid: aBlockClosure.
	classNameInput input text trimBoth
		ifEmpty: [ aBlockClosure value: 'Class name is empty' ]
]

{ #category : #initialization }
RiClassSearchPage >> initializePresenters [
	super initializePresenters.
	classNameInput := self
		instantiate:
			(SpLabelledPresenter
				label: 'Class name'
				input: self newTextInput
				description: 'The exact name of the class (case-sensitive)').
	
	self focusOrder add: classNameInput
]

{ #category : #accessing }
RiClassSearchPage >> pathIn: anIceLibgitRepository [
	^ anIceLibgitRepository log
		fileNameForPackageNamed: packageNameInput input text
		classNamed: classNameInput input text
		isTrait: false
		isMeta: false
]
