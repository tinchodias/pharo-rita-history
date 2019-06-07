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

{ #category : #private }
RiSummaryGraph >> postProcessElement: aRiSummaryElement [

	aRiSummaryElement commits do: [ :commit |
		commit ancestors do: [ :ancestor |
			| ancestorElement |
			ancestorElement := elementByCommit at: ancestor.
			(ancestorElement == aRiSummaryElement) ifFalse: [ 
				aRiSummaryElement addAncestor: ancestorElement ]
			] ]
]

{ #category : #processing }
RiSummaryGraph >> process [
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.
	
	"TODO: fix"
	repositoryModel elements
		select: [:each | each class = RiCommit ]
		thenDo: [ :each | self processCommit: each ].
	
	elements do: [ :each | self postProcessElement: each ].
]

{ #category : #private }
RiSummaryGraph >> processCommit: aRiCommit [

	| element |
	element := (aRiCommit marks notEmpty or: [ aRiCommit children isEmpty ])
		ifTrue: [ elements add: RiSummaryElement new ]
		ifFalse: [ elementByCommit at: aRiCommit children last ].
			
"			| childrenElements |
			childrenElements := (aRiCommit children collect: [:each | elementByCommit at: each ] as: Set) select: #hasMarks.
			childrenElements size = 1
				ifTrue: [ childrenElements anyOne ]
				ifFalse: [ elements add: RiSummaryElement new ] ].
"	
	element addCommit: aRiCommit.
	elementByCommit at: aRiCommit put: element.

]

{ #category : #accessing }
RiSummaryGraph >> repositoryModel [
	^ repositoryModel
]

{ #category : #accessing }
RiSummaryGraph >> repositoryModel: aRiRepositoryModel [
	repositoryModel := aRiRepositoryModel
]
