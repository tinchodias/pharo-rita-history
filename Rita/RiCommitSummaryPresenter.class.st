Class {
	#name : #RiCommitSummaryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'authorPanel',
		'headerLabel',
		'committerPanel',
		'headerText'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiCommitSummaryPresenter class >> defaultSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerText;
		yourself
]

{ #category : #initialization }
RiCommitSummaryPresenter >> initializePresenters [
	headerText := self newText
		beNotEditable;
		yourself
]

{ #category : #accessing }
RiCommitSummaryPresenter >> refreshOnModelUpdate [
	model accept: self
]

{ #category : #private }
RiCommitSummaryPresenter >> stringForSignature: aLGitSignature role: aString [ 
	^ ('{2}: {1} ({3}) @ {4}' format: {
			aLGitSignature name.
			aString.
			aLGitSignature email.
			aLGitSignature dateAndTime asEmailString}).
]

{ #category : #accessing }
RiCommitSummaryPresenter >> userModelFor: signature roleName: roleName [
	^ {
		#roleName -> roleName.
		#signature -> signature.
		#avatar -> (self iconNamed: #user).
		} asDictionary
]

{ #category : #visiting }
RiCommitSummaryPresenter >> visitCommit: aRiCommit [ 
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
RiCommitSummaryPresenter >> visitUncommitedWorkingCopy: aRiUncommitedWorkingCopy [
	headerLabel text: 'Uncommitted changes in this image.'
]
