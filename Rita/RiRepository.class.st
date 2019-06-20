"
This is a model of a IceLibGitRepository.
"
Class {
	#name : #RiRepository,
	#superclass : #Object,
	#instVars : [
		'elements',
		'elementByCommit',
		'elementMarks',
		'iceRepository'
	],
	#category : #'Rita-Core'
}

{ #category : #accessing }
RiRepository >> elementByCommit [
	^ elementByCommit
]

{ #category : #accessing }
RiRepository >> elementMarks [
	^ elementMarks
]

{ #category : #accessing }
RiRepository >> elements [
	^ elements
]

{ #category : #accessing }
RiRepository >> iceRepository [
	^ iceRepository
]

{ #category : #accessing }
RiRepository >> iceRepository: anIceLibgitRepository [
	iceRepository := anIceLibgitRepository
]

{ #category : #processing }
RiRepository >> process [

	| walk marks |
	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.
	marks := iceRepository tags, iceRepository localBranches, iceRepository remoteTrackedBranches.

	"Determine the commits in the proper order via Libgit's revwalk."
	walk := iceRepository newCommitWalk.
	walk revwalk
		beSortedByCommitTime;
		beSortedParentsBeforeChildren.
	(marks collect: #commit as: Set) do: [ :each | walk fromCommit: each ].
	walk commitsDo: [:each |
		| newCommit |
		newCommit := RiCommit repository: self iceCommit: each.
		elements add: newCommit.
		elementByCommit at: each put: newCommit ].
	self processCommitChildren.

	"Add our marks to the commit elements."
	marks do: [ :each | self processMark: each ].

	"Add new non-commit elements to the list, if needed."
	self processImageMark.
	self processDiskMark.

]

{ #category : #processing }
RiRepository >> processCommitChildren [

	elementByCommit valuesDo: [ :each | 
		each ancestors do: [ :ancestor |
			ancestor addChildren: each ] ]
]

{ #category : #accessing }
RiRepository >> processDiskMark [

"	| aRiCommit |
	aRiCommit := elementByCommit at: iceRepository headCommit.
	aRiCommit addMark: (RiImageMark new element: aRiCommit; yourself).
"
	self flag: #todo. "(1) It's not IMAGE, and (2) it can be dirty on disk"
]

{ #category : #accessing }
RiRepository >> processImageMark [

	| aRiCommit |
	aRiCommit := elementByCommit at: iceRepository workingCopy referenceCommit.
	
	iceRepository workingCopy isModified
		ifTrue: [
			| tmp |
			tmp := RiUncommitedWorkingCopy new referenceCommit: aRiCommit.
			elements
				add: tmp
				before: aRiCommit.
			aRiCommit := tmp ].

	aRiCommit addMark: (RiImageMark new element: aRiCommit; yourself).

]

{ #category : #private }
RiRepository >> processMark: anIceCommitish [ 

	| element mark |
	element := elementByCommit at: anIceCommitish commit.

	anIceCommitish isTag ifTrue: [ 
		mark := RiTagMark new tag: anIceCommitish; yourself.
		element addMark: mark.
		elementMarks add: mark.
		^ self ].

	self assert: anIceCommitish isBranch.

	mark := element marks
		detect: [ :each | each isBranchMark and: [ each shortname = anIceCommitish shortname ] ]
		ifNone: [ element addMark: RiBranchMark new ].
	
	anIceCommitish isLocal
		ifTrue: [ mark local: anIceCommitish ]
		ifFalse: [ mark remote: anIceCommitish ].
		
	elementMarks add: mark.

]
