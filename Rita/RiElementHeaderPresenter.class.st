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
RiElementHeaderPresenter >> stringForSignature: aLGitSignature role: aString [ 
	^ ('{2}: {1} ({3}) @ {4}' format: {
			aLGitSignature name.
			aString.
			aLGitSignature email.
			aLGitSignature dateAndTime asEmailString}).
]

{ #category : #accessing }
RiElementHeaderPresenter >> userModelFor: signature roleName: roleName [
	^ {
		#roleName -> roleName.
		#signature -> signature.
		#avatar -> (self iconNamed: #user).
		} asDictionary
]

{ #category : #visiting }
RiElementHeaderPresenter >> visitCommit: aRiCommit [ 
	| signaturesString |
	signaturesString := model committer = model author
		ifTrue: [ self stringForSignature: model author role: 'Author & Committer' ]
		ifFalse: [ 
			(self stringForSignature: model author role: 'Author'), ' - ',
			(self stringForSignature: model committer role: 'Committer'). ].
	
	headerText text: ('SHA: {1} - {2}
Comment: {3}' format: {model shortId. signaturesString. model comment trimBoth})

]

{ #category : #visiting }
RiElementHeaderPresenter >> visitUncommitedWorkingCopy: aRiUncommitedWorkingCopy [
	headerText text: 'Uncommitted changes in this image.'
]
