Class {
	#name : #RiPRHeaderPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'headerText'
	],
	#category : #'Rita-UI-PullRequests'
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
	model accept: self
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

{ #category : #visiting }
RiPRHeaderPresenter >> visitCommit: aRiCommit [ 
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
