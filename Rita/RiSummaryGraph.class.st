Class {
	#name : #RiSummaryGraph,
	#superclass : #Object,
	#instVars : [
		'repositoryModel',
		'elements',
		'elementByCommit'
	],
	#category : #'Rita-Summary'
}

{ #category : #accessing }
RiSummaryGraph >> elements [
	^ elements
]

{ #category : #processing }
RiSummaryGraph >> process [
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.
	
	repositoryModel elements do: [ :each | self processElement: each ]
]

{ #category : #private }
RiSummaryGraph >> processElement: aRiCommit [

	| element |
	aRiCommit class = RiCommit ifFalse: [ ^self "skip... TODO" ].
	
	element := (aRiCommit marks notEmpty or: [ aRiCommit children isEmpty ])
		ifTrue: [ elements add: RiSummaryElement new ]
		ifFalse: [
			aRiCommit children size = 1
				ifTrue: [ elementByCommit at: aRiCommit children anyOne ]
				ifFalse: [ elements add: RiSummaryElement new ] ].
	
	element addCommit: aRiCommit.
	elementByCommit at: aRiCommit put: element.

]

{ #category : #accessing }
RiSummaryGraph >> repositoryModel: aRiRepositoryModel [
	repositoryModel := aRiRepositoryModel
]
