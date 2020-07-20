Class {
	#name : #RiCommitSummaryPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'authorPanel',
		'commentLabel',
		'headerLabel',
		'committerPanel'
	],
	#category : #'Rita-UI'
}

{ #category : #specs }
RiCommitSummaryPresenter class >> defaultSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerLabel
			withConstraints: [ :constraints | constraints height: 25 ];
		yourself
]

{ #category : #specs }
RiCommitSummaryPresenter class >> doubleUserSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerLabel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #authorPanel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #committerPanel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #commentLabel;
		yourself
]

{ #category : #specs }
RiCommitSummaryPresenter class >> singleUserSpec [
	<spec>
	^ SpBoxLayout newVertical
		add: #headerLabel
			withConstraints: [ :constraints | constraints height: 25 ];
		add: #authorPanel
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
	committerPanel := self instantiate: RiCommitUserPresenter.
]

{ #category : #accessing }
RiCommitSummaryPresenter >> isCommitterDifferentFromAuthor [
	^ model committer ~= model author
]

{ #category : #accessing }
RiCommitSummaryPresenter >> refreshOnModelUpdate [
	model accept: self
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
	| spec |
	spec := self isCommitterDifferentFromAuthor
		ifTrue: [ self class doubleUserSpec ]
		ifFalse: [ self class singleUserSpec ].
	self layout: spec.

	headerLabel label: self headerString.
	commentLabel label: model comment.
	authorPanel model: self authorModel.
	committerPanel model: self committerModel
]

{ #category : #visiting }
RiCommitSummaryPresenter >> visitUncommitedWorkingCopy: aRiUncommitedWorkingCopy [
	self layout: self class defaultSpec.
	headerLabel label: self headerString
]
