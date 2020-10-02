Class {
	#name : #RiPathSearchPage,
	#superclass : #RiSearchPage,
	#instVars : [
		'pathInput'
	],
	#category : #'Rita-UI-Spec2-Search'
}

{ #category : #specs }
RiPathSearchPage class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #pathInput height: self labelledInputHeight;
		yourself
]

{ #category : #accessing }
RiPathSearchPage >> checkIfInvalid: aBlockClosure [
	pathInput input text trimBoth
		ifEmpty: [ aBlockClosure value: 'Path is empty' ]
]

{ #category : #initialization }
RiPathSearchPage >> initializePresenters [
	pathInput := self
		instantiate:
			(SpLabelledPresenter
				label: 'Path'
				input: self newTextInput
				description: 'A relative path, from the root of the repository. Example: README.md')
]

{ #category : #accessing }
RiPathSearchPage >> pathIn: anIceLibgitRepository [ 
	^ pathInput input text
]
