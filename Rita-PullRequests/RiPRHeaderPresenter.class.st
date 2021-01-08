Class {
	#name : #RiPRHeaderPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'headerText'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiPRHeaderPresenter class >> defaultSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerText;
		yourself
]

{ #category : #initialization }
RiPRHeaderPresenter >> initializePresenters [

	headerText := self newText
		beNotEditable;
		yourself
]

{ #category : #accessing }
RiPRHeaderPresenter >> refreshOnModelUpdate [

	| text pr |
	pr := model at: #pullRequest.
	text := Text streamContents: [ :stream |
		stream
			nextPutAll: 'Author: ' asText allBold;
			nextPutAll: pr author;
			nextPutAll: ' - ';
			nextPutAll: 'State: ' asText allBold; 
			nextPutAll: pr state ].
	
	headerText text: text
]

{ #category : #private }
RiPRHeaderPresenter >> textForSignature: aLGitSignature role: aString [ 

	^ Text streamContents: [ :stream |
		stream
			nextPutAll: aString asText allBold;
			nextPutAll: ': ';
			nextPutAll: ('{1} ({2}) - {3}' format: {
				aLGitSignature name.
				aLGitSignature email.
				aLGitSignature dateAndTime asEmailString}) ]
]
