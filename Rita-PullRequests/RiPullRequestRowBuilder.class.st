Class {
	#name : #RiPullRequestRowBuilder,
	#superclass : #RiRowBuilder,
	#instVars : [
		'datePrinter'
	],
	#category : #'Rita-PullRequests-UI'
}

{ #category : #accessing }
RiPullRequestRowBuilder >> initialize [

	super initialize.
	datePrinter := RiDatePrinter new
]

{ #category : #accessing }
RiPullRequestRowBuilder >> morphAt: item [

	| row |
	row := RiRowMorph new.
	row addItemLeft: (('#{1} {2}' format: {item number. item title}) asMorph hResizing: #spaceFill).
	row addItemRight: ('  {1}     ' format: { self timestampStringFor: item }) asMorph.
	^ row

]

{ #category : #accessing }
RiPullRequestRowBuilder >> timestampStringFor: item [

	^ datePrinter stringFor: item creationDateAndTime asDate
]
