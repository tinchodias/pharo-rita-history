Class {
	#name : #RiElementHeaderPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'headerText'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiElementHeaderPresenter class >> defaultSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerText;
		yourself
]

{ #category : #initialization }
RiElementHeaderPresenter >> initializePresenters [
	headerText := self newText
		beNotEditable;
		yourself
]

{ #category : #accessing }
RiElementHeaderPresenter >> refreshOnModelUpdate [
	model accept: self
]

{ #category : #private }
RiElementHeaderPresenter >> textForSignature: aLGitSignature role: aString [ 
	^ Text streamContents: [ :stream |
		stream
			nextPutAll: aString asText allBold;
			nextPutAll: ': ';
			nextPutAll: ('{1} ({2}) - {3}' format: {
				aLGitSignature name.
				aLGitSignature email.
				aLGitSignature dateAndTime asEmailString}) ]
]

{ #category : #visiting }
RiElementHeaderPresenter >> visitCommit: aRiCommit [ 
	| signaturesText text |
	signaturesText := model committer = model author
		ifTrue: [ self textForSignature: model author role: 'Author & Committer' ]
		ifFalse: [ 
			(self textForSignature: model author role: 'Author'), ' - ',
			(self textForSignature: model committer role: 'Committer'). ].
	
	text := Text streamContents: [ :stream |
		stream
			nextPutAll: 'SHA: ' asText allBold; 
			nextPutAll: model shortId;
			nextPutAll: ' - ';
			nextPutAll: signaturesText;
			cr;
			nextPutAll: 'Comment: ' asText allBold;
			nextPutAll: model comment trimBoth ].
	
	headerText text: text
]

{ #category : #visiting }
RiElementHeaderPresenter >> visitUncommitedWorkingCopy: aRiUncommitedWorkingCopy [
	headerText text: 'Uncommitted changes in this image.'
]
