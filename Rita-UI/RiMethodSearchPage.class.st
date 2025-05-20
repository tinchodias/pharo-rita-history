Class {
	#name : 'RiMethodSearchPage',
	#superclass : 'RiClassSearchPage',
	#instVars : [
		'methodSelectorInput'
	],
	#category : 'Rita-UI-Spec2-Search',
	#package : 'Rita-UI',
	#tag : 'Spec2-Search'
}

{ #category : 'specs' }
RiMethodSearchPage class >> defaultLayout [
	^ super defaultLayout
		add: #methodSelectorInput height: self labelledInputHeight;
		yourself
]

{ #category : 'accessing' }
RiMethodSearchPage >> checkIfInvalid: aBlockClosure [
	super checkIfInvalid: aBlockClosure.
	methodSelectorInput input text trimBoth
		ifEmpty: [ aBlockClosure value: 'Method selector is empty' ]
]

{ #category : 'initialization' }
RiMethodSearchPage >> initializePresenters [
	super initializePresenters.
	methodSelectorInput := self
		instantiate:
			(SpLabelledPresenter
				label: 'Selector'
				input: self newTextInput
				description: 'The exact selector of the method (case-sensitive)').
				
	self focusOrder add: methodSelectorInput
]

{ #category : 'accessing' }
RiMethodSearchPage >> pathIn: anIceLibgitRepository [
	^ anIceLibgitRepository log
		fileNameForPackageNamed: packageNameInput input text
		classNamed: classNameInput input text
		isTrait: false
		isMeta: false
		selector: methodSelectorInput input text
]
