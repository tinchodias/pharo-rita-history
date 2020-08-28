Class {
	#name : #RiOldPullRequestPresenter,
	#superclass : #RiPresenter,
	#instVars : [
		'table'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #specs }
RiOldPullRequestPresenter class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #table;
		yourself
]

{ #category : #initialization }
RiOldPullRequestPresenter >> initializePresenters [

	table := self newTable
		hideColumnHeaders;
		addColumn: (SpImageTableColumn evaluated: #second);
		whenBuiltDo: [ :ann | 
			ann widget beRowNotHomogeneous.
			RiMultipleDiffDataSource adoptInstance: ann widget dataSource ];
		yourself
]

{ #category : #initialization }
RiOldPullRequestPresenter >> morphFor: aPRComment [

	| aesthetics timestamp timestampHumanReadable |
	self flag: #todo.	
	aesthetics := RiAestheticsModel new.
"	aesthetics := model at: #aesthetics."
	timestamp := aPRComment creationDateAndTime.
" 	timestampHumanReadable := timestamp epiceaBrowsersAsString."
	timestampHumanReadable := RiDateAndTimePrinter new stringFor: timestamp.

	^ aesthetics columnMorphWithAll: {
			aPRComment author asMorph.
			timestampHumanReadable asMorph.
			(MicroDownParser asText: aPRComment body) asMorph.
		}
]

{ #category : #initialization }
RiOldPullRequestPresenter >> refreshOnModelUpdate [
	| aPR items |
	aPR := model at: #pullRequest.
	items := {aPR}, aPR comments.
"	(IceGitHubAPI new getPaginated: aPR urlToComments) all."

	table items: (items
		collect: [ :each | { each. self morphFor: each } ])

]
