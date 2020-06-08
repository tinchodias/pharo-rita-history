Class {
	#name : #RiPullRequestPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
	],
	#category : #'Rita-UI-PullRequests'
}

{ #category : #specs }
RiPullRequestPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #initialization }
RiPullRequestPresenter >> initializePresenters [

	table := self newTable
		hideColumnHeaders;
		addColumn: (SpImageTableColumn evaluated: #second);
		whenBuiltDo: [ :ann | 
			ann widget beRowNotHomogeneous.
			RiMultipleDiffDataSource adoptInstance: ann widget dataSource ];
		yourself
]

{ #category : #initialization }
RiPullRequestPresenter >> morphFor: aPRComment [

	| aesthetics timestamp timestampHumanReadable |
	self flag: #todo.	
	aesthetics := RiAestheticsModel new.
"	aesthetics := model at: #aesthetics."
	timestamp := aPRComment createdAt asDateAndTime.
" 	timestampHumanReadable := timestamp epiceaBrowsersAsString."
	timestampHumanReadable := RiDateAndTimePrinter new stringFor: timestamp.

	^ aesthetics columnMorphWithAll: {
			aPRComment author asMorph.
			timestampHumanReadable asMorph.
			(MicroDownParser asText: aPRComment body) asMorph.
		}
]

{ #category : #initialization }
RiPullRequestPresenter >> refreshOnModelUpdate [
	| aPR items |
	aPR := model at: #pullRequest.
	items := {aPR}, aPR comments.
"	(IceGitHubAPI new getPaginated: aPR urlToComments) all."

	table items: (items
		collect: [ :each | { each. self morphFor: each } ])

]
