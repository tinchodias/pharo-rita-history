Class {
	#name : #RiPackageSearchPage,
	#superclass : #RiSearchPage,
	#instVars : [
		'packageNameInput'
	],
	#category : #'Rita-UI-Spec2-Search'
}

{ #category : #specs }
RiPackageSearchPage class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #packageNameInput height: self labelledInputHeight;
		yourself
]

{ #category : #accessing }
RiPackageSearchPage >> checkIfInvalid: aBlockClosure [
	packageNameInput input text trimBoth
		ifEmpty: [ aBlockClosure value: 'Package name is empty' ]
]

{ #category : #initialization }
RiPackageSearchPage >> initializePresenters [
	packageNameInput := self
		instantiate:
			(SpLabelledPresenter
				label: 'Package'
				input: self newTextInput
				description: 'The exact name of the package (case-sensitive)').
				
	self focusOrder add: packageNameInput
]

{ #category : #accessing }
RiPackageSearchPage >> pathIn: anIceLibgitRepository [ 
	^ anIceLibgitRepository log fileNameForPackageNamed: packageNameInput input text
]
