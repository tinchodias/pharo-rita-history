"
This is a model of a IceLibGitRepository.
"
Class {
	#name : #RiRepositoryModel,
	#superclass : #Object,
	#instVars : [
		'repository',
		'elements',
		'workingCopyElement',
		'elementByCommit',
		'elementMarks'
	],
	#category : #'Rita-Core'
}

{ #category : #accessing }
RiRepositoryModel >> elementByCommit [
	^ elementByCommit
]

{ #category : #accessing }
RiRepositoryModel >> elementMarks [
	^ elementMarks
]

{ #category : #accessing }
RiRepositoryModel >> elements [
	^ elements
]

{ #category : #processing }
RiRepositoryModel >> process [

	| walk marks |
	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.
	marks := repository tags, repository localBranches, repository remoteTrackedBranches.

	"Determine the commits in the proper order via Libgit's revwalk."
	walk := repository newCommitWalk.
	walk revwalk
		beSortedByCommitTime;
		beSortedParentsBeforeChildren.
	(marks collect: #commit as: Set) do: [ :each | walk fromCommit: each ].
	walk commitsDo: [:each |
		| newCommit |
		newCommit := RiCommit model: self commit: each.
		elements add: newCommit.
		elementByCommit at: each put: newCommit ].
	self processCommitChildren.

	"Add our marks to the commit elements."
	marks do: [ :each | self processMark: each ].

	"Add new non-commit elements to the list, if needed."
	self processWorkingCopy.
	self processWorkingTree.

]

{ #category : #processing }
RiRepositoryModel >> processCommitChildren [

	elementByCommit valuesDo: [ :each | 
		each ancestors do: [ :ancestor |
			ancestor addChildren: each ] ]
]

{ #category : #private }
RiRepositoryModel >> processMark: anIceCommitish [ 

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
RiRepositoryModel >> processWorkingCopy [

	workingCopyElement := elementByCommit at: repository workingCopy referenceCommit.
	workingCopyElement addMark: (RiWorkingCopyMark new element: workingCopyElement; yourself).

	repository workingCopy isModified ifTrue: [
		elements
			add: (RiWorkingCopyChanges new ancestorWorkingCopyElement: workingCopyElement)
			before: workingCopyElement ].

]

{ #category : #accessing }
RiRepositoryModel >> processWorkingTree [

"	workingCopyElement := elements detect: [ :each |
		each isCommitElement and: [ each commit = repository headCommit ] ].
"
]

{ #category : #accessing }
RiRepositoryModel >> repository [
	^ repository
]

{ #category : #accessing }
RiRepositoryModel >> repository: anIceLibgitRepository [
	repository := anIceLibgitRepository
]
