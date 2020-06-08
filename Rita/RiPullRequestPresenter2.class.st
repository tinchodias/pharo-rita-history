Class {
	#name : #RiPullRequestPresenter2,
	#superclass : #RiPresenter,
	#instVars : [
		'textPresenter',
		'printer'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPullRequestPresenter2 class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #textPresenter;
		yourself
]

{ #category : #initialization }
RiPullRequestPresenter2 >> initializePresenters [
	textPresenter := self newText.
	printer := RiDateAndTimePrinter new
]

{ #category : #initialization }
RiPullRequestPresenter2 >> refreshOnModelUpdate [
	| aPR items |
	aPR := model at: #pullRequest.
	items := {aPR}, aPR comments.
	textPresenter text: (self textForAll: items)
]

{ #category : #initialization }
RiPullRequestPresenter2 >> textFor: aPRComment [
	| timestamp text timestampHumanReadable |
	timestamp := aPRComment createdAt asDateAndTime.
	timestampHumanReadable := printer stringFor: timestamp.

	text := aPRComment author asText allBold.
	text
		append: ' commented on ' , timestampHumanReadable;
		append: String lf;
		append: (MicroDownParser asText: aPRComment body).
	^ text
]

{ #category : #initialization }
RiPullRequestPresenter2 >> textForAll: aListOfPRComments [
	^ Text
		streamContents: [ :stream | 
			aListOfPRComments
				do: [ :each | stream nextPutAll: (self textFor: each) ] ]
]
