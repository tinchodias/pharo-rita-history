Class {
	#name : #RiCommitUserPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'avatarImage',
		'nameLabel'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiCommitUserPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #avatarImage withConstraints: [ :constraints | constraints width: 20 ];
		add: #nameLabel;
		yourself
		
]

{ #category : #initialization }
RiCommitUserPresenter >> initializePresenters [
	avatarImage := self newImage.
	nameLabel := self newLabel.
]

{ #category : #initialization }
RiCommitUserPresenter >> refreshOnModelUpdate [
	| signature avatar |
	signature := model at: #signature.
	avatar := model at: #avatar.
	
	avatarImage image: avatar.
	nameLabel label:
		('{1} ({3}) @ {4} ({2})' format: {
			signature name.
			model at: #roleName.
			signature email.
			signature dateAndTime})
]
