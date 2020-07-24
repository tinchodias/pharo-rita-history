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
		'iceRepository',
		'tips'
	],
	#category : #'Rita-Core'
}

{ #category : #'instance creation' }
RiRepository class >> iceRepository: anIceLibgitRepository [
	^ self new
		iceRepository: anIceLibgitRepository;
		yourself
]

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

{ #category : #processing }
RiRepository >> ensureProcessed [
	elements ifNil: [ self process ]
]

{ #category : #'as yet unclassified' }
RiRepository >> fetch [
	iceRepository fetch
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

{ #category : #printing }
RiRepository >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : #processing }
RiRepository >> process [

	self processTips.

	"Determine the commit graph."
	self processCommits.
	self processCommitGraph.

	"Add our marks to the commit elements."
	tips do: [ :each | self processMark: each ].

	"Add new non-commit elements to the list, if needed."
	self processImageMark.
	self processWorkdirMark.

]

{ #category : #processing }
RiRepository >> processCommitGraph [
	"Connect all collected RiCommits in terms of child/parent."

	elementByCommit valuesDo: [ :each | 
		each ancestors do: [ :ancestor |
			ancestor addChildren: each ] ]
]

{ #category : #processing }
RiRepository >> processCommits [
	"Determine the commits in the proper order via Libgit's revwalk."

	| walk |
	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.

	self processTips.
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

]

{ #category : #accessing }
RiRepository >> processImageMark [

	| aRiCommit |
	iceRepository hasLoadedPackages ifFalse: [ ^self ].
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

{ #category : #processing }
RiRepository >> processTips [

	| branches |
	"Note: /HEAD branches were problematic. And they are unneeded... right?"
	branches := iceRepository allBranches
		reject: [ :each | each name endsWith: '/HEAD' ].

	tips := branches , iceRepository tags
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

{ #category : #accessing }
RiRepository >> tips [
	^ tips
]
