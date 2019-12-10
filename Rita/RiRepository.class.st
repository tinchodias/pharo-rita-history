"
I enrich a IceLibGitRepository object with RiElements.
"
Class {
	#name : #RiRepository,
	#superclass : #Object,
	#instVars : [
		'elementByCommit',
		'elementMarks',
		'elements',
		'iceRepository'
	],
	#category : #'Rita-Core'
}

{ #category : #accessing }
RiRepository >> commits [
	^ elements reject: #isUncommited
]

{ #category : #accessing }
RiRepository >> description [
	^ iceRepository description
]

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

{ #category : #accessing }
RiRepository >> name [
	^ iceRepository name
]

{ #category : #actions }
RiRepository >> openInNativeBrowser [
	iceRepository location openInNativeBrowser
]

{ #category : #processing }
RiRepository >> process [

	| walk tips |
	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.
	
	"Note: HEAD branches were problematic. They are also uneeded, right?"
	tips := iceRepository allBranches reject: [ :each | each name endsWith: '/HEAD' ].
	tips := tips, iceRepository tags.

	"Determine the commits in the proper order via Libgit's revwalk."
	walk := iceRepository newCommitWalk.
	walk revwalk
		beSortedByCommitTime;
		beSortedParentsBeforeChildren.
	tips collect: #commitId thenDo: [ :each | walk fromLGitId: each ].
	walk commitsDo: [:each |
		| newCommit |
		newCommit := RiCommit repository: self iceCommit: each.
		elements add: newCommit.
		elementByCommit at: each put: newCommit ].
	self processCommitChildren.

	"Add our marks to the commit elements."
	tips do: [ :each | self processMark: each ].

	"Add new non-commit elements to the list, if needed."
	self processImageMark.
	self processWorkdirMark.

]

{ #category : #processing }
RiRepository >> processCommitChildren [

	elementByCommit valuesDo: [ :each | 
		each ancestors do: [ :ancestor |
			ancestor addChildren: each ] ]
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

{ #category : #accessing }
RiRepository >> processWorkdirMark [

	| aRiCommit diff |
	aRiCommit := elementByCommit at: iceRepository headCommit.
	
	diff := (LGitDiff of: iceRepository repositoryHandle)
		diffIndexToWorkDir;
		yourself.

	diff numberOfDeltas > 0 ifTrue: [
		| tmp |
		tmp := RiUncommitedWorkingCopy new referenceCommit: aRiCommit.
		elements
			add: tmp
			before: aRiCommit.
		aRiCommit := tmp ].

	aRiCommit addMark: (RiWorkdirMark new element: aRiCommit; yourself).

]
