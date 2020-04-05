Class {
	#name : #RiCommitSummaryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'authorPanel',
		'commiterPanel',
		'commentLabel',
		'headerLabel'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiCommitSummaryPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #headerLabel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #authorPanel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #commiterPanel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #commentLabel;
		yourself
]

{ #category : #accessing }
RiCommitSummaryPresenter >> authorModel [
	^ self userModelFor: model author roleName: 'author'
]

{ #category : #accessing }
RiCommitSummaryPresenter >> committerModel [
	^ self userModelFor: model committer roleName: 'committer'
]

{ #category : #accessing }
RiCommitSummaryPresenter >> headerString [
	^ model shortId asString
]

{ #category : #initialization }
RiCommitSummaryPresenter >> initializePresenters [
	headerLabel := self newLabel.
	commentLabel := self newLabel.
	authorPanel := self instantiate: RiCommitUserPresenter.
	commiterPanel := self instantiate: RiCommitUserPresenter
]

{ #category : #accessing }
RiCommitSummaryPresenter >> refreshOnModelUpdate [
	headerLabel label: self headerString.
	commentLabel label: model comment.
	authorPanel model: self authorModel.
	commiterPanel model: self committerModel.
]

{ #category : #accessing }
RiCommitSummaryPresenter >> userModelFor: signature roleName: roleName [
	^ {
		#roleName -> roleName.
		#signature -> signature.
		#avatar -> (self iconNamed: #user).
		} asDictionary
]
