"
I am a RiRepository that reads an IceLibgitRepository of Iceberg. I build the commit elements by walking the revisions of libgit, and I add the marks of the branches and tags, of the image and of the working directory.
"
Class {
	#name : 'RiIcebergRepository',
	#superclass : 'RiRepository',
	#instVars : [
		'iceRepository',
		'iceBranches',
		'iceTags',
		'elementByCommit'
	],
	#category : 'Rita-Iceberg-Repository',
	#package : 'Rita-Iceberg',
	#tag : 'Repository'
}

{ #category : 'instance creation' }
RiIcebergRepository class >> iceRepository: anIceLibgitRepository [
	^ self basicNew
		initializeWithIceRepository: anIceLibgitRepository;
		yourself
]

{ #category : 'accessing' }
RiIcebergRepository >> description [
	^ iceRepository description
]

{ #category : 'accessing' }
RiIcebergRepository >> elementByCommit [

	^ elementByCommit
]

{ #category : 'accessing' }
RiIcebergRepository >> fetch [
	iceRepository fetch
]

{ #category : 'diffing' }
RiIcebergRepository >> iceObjectFor: aRiElement [
	"Answer the Iceberg object that stands for aRiElement: its commit, or the working copy when it is not committed"

	^ aRiElement isUncommited ifTrue: [ iceRepository workingCopy ] ifFalse: [ aRiElement iceGitCommit ]
]

{ #category : 'accessing' }
RiIcebergRepository >> iceRepository [
	^ iceRepository
]

{ #category : 'accessing' }
RiIcebergRepository >> initializeWithIceRepository: anIceLibgitRepository [
	self initialize.
	iceRepository := anIceLibgitRepository
]

{ #category : 'accessing' }
RiIcebergRepository >> name [
	^ iceRepository name
]

{ #category : 'diffing' }
RiIcebergRepository >> newDiffFrom: aSourceRiElement to: aTargetRiElement [

	^ RiceDiff from: (self iceObjectFor: aSourceRiElement) to: (self iceObjectFor: aTargetRiElement)
]

{ #category : 'private' }
RiIcebergRepository >> newIceCommitWalk [
	"Answer a IceLibgitCommitWalk. Requires that #processTips was executed before."

	| walk |
	walk := iceRepository newCommitWalk.
	walk revwalk
		beSortedByCommitTime;
		beSortedParentsBeforeChildren.

	iceBranches do: [ :each | walk fromBranch: each ].
	iceTags do: [ :each | walk fromTag: each ].

	^ walk
]

{ #category : 'accessing' }
RiIcebergRepository >> openInNativeBrowser [
	iceRepository location openInNativeBrowser
]

{ #category : 'private' }
RiIcebergRepository >> processBranchMark: anIceCommitish [ 

	| element mark |
	element := elementByCommit at: anIceCommitish commit.

	mark := element marks
		detect: [ :each |
			each isBranchMark and: [
			each shortname = anIceCommitish shortname ] ]
		ifNone: [ element addMark: RiBranchMark new ].
	
	anIceCommitish isLocal
		ifTrue: [ mark local: anIceCommitish ]
		ifFalse: [ mark remote: anIceCommitish ].
		
	elementMarks add: mark

]

{ #category : 'processing' }
RiIcebergRepository >> processCommits [
	"Determine the commits in the proper order via Libgit's revwalk."

	elementByCommit := Dictionary new.
	iceRepository head isUnbornBranch ifTrue: [ ^ self ].

	self withIceCommitWalkDo: [ :walk |
		walk commitsDo: [ :each |
			| newCommit |
			newCommit := RiIcebergCommit repository: self iceGitCommit: each.
			self addCommitElement: newCommit.
			elementByCommit at: each put: newCommit ] ]
]

{ #category : 'processing' }
RiIcebergRepository >> processImageMark [
	"Add an IMAGE mark to the commit my working copy is based on, or to an uncommitted working copy when it is modified.
	When the reference commit is unknown (e.g. it is not present in the local clone), there is nothing to mark."

	| aRiCommit |
	iceRepository hasLoadedPackages ifFalse: [ ^ self ].

	aRiCommit := elementByCommit at: iceRepository workingCopy referenceCommit ifAbsent: [ ^ self ].

	iceRepository workingCopy isModified ifTrue: [
			| tmp |
			tmp := RiUncommitedWorkingCopy new referenceCommit: aRiCommit.
			elements add: tmp before: aRiCommit.
			aRiCommit := tmp ].

	aRiCommit addMark: (RiImageMark new
			 element: aRiCommit;
			 yourself)
]

{ #category : 'private' }
RiIcebergRepository >> processMark: anIceCommitish [ 

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

{ #category : 'processing' }
RiIcebergRepository >> processMarks [

	iceBranches do: [ :each | self processBranchMark: each ].
	iceTags do: [ :each | self processTagMark: each ]
]

{ #category : 'private' }
RiIcebergRepository >> processTagMark: anIceCommitish [ 

	| element mark |
	element := elementByCommit at: anIceCommitish commit.

	mark := RiTagMark new tag: anIceCommitish; yourself.

	element addMark: mark.
	elementMarks add: mark

]

{ #category : 'processing' }
RiIcebergRepository >> processTips [
	"Note: /HEAD branches were problematic, and they seem to be unwanted"

	iceBranches := iceRepository allBranches reject: [ :each | each isUnbornBranch or: [ each name endsWith: '/HEAD' ] ].
	iceTags := iceRepository tags
]

{ #category : 'processing' }
RiIcebergRepository >> processWorkdirMark [
	"Add a WORKDIR mark to the commit of my HEAD, or to an uncommitted working copy when there are changes in the working directory.
	When the HEAD commit is unknown (e.g. it is not present in the local clone), there is nothing to mark."

	| aRiCommit diff |
	iceRepository headCommit isNoCommit ifTrue: [ ^ self ].

	aRiCommit := elementByCommit at: iceRepository headCommit ifAbsent: [ ^ self ].

	diff := (LGitDiff of: iceRepository repositoryHandle)
		        diffIndexToWorkDir;
		        yourself.

	diff numberOfDeltas > 0 ifTrue: [
			| tmp |
			tmp := RiUncommitedWorkingCopy new referenceCommit: aRiCommit.
			elements add: tmp before: aRiCommit.
			aRiCommit := tmp ].

	aRiCommit addMark: (RiWorkdirMark new
			 element: aRiCommit;
			 yourself)
]

{ #category : 'dependencies' }
RiIcebergRepository >> release [

	iceRepository free
]

{ #category : 'processing' }
RiIcebergRepository >> reset [

	super reset.
	elementByCommit := iceBranches := iceTags := nil
]

{ #category : 'searching' }
RiIcebergRepository >> selectCommitsWithChangesAt: aPath [
	"Based on IceLog>>#collectCommitsFor:path:"

	| pathSpec diffOptions results |
	pathSpec := LGitPathSpec withAll: { aPath }.
	diffOptions := LGitDiffOptions defaults.
	diffOptions pathspec: (LGitStringArray withAll: { aPath }).

	results := OrderedCollection new.
	self withIceCommitWalkDo: [ :walk |
			walk commitsDo: [ :each |
					| tree commit |
					commit := each libgitCommit.
					tree := commit tree.
					commit numberOfParents = 0
						ifTrue: [ (tree matchesPathSpec: pathSpec) ifTrue: [ results add: (self commitAtSha: commit id hexString) ] ]
						ifFalse: [
								| parent diff |
								parent := commit parentAt: 1.
								diff := tree diffTo: parent tree options: diffOptions.
								diff numberOfDeltas > 0 ifTrue: [ results add: (self commitAtSha: commit id hexString) ] ] ] ].

	^ results
]

{ #category : 'private' }
RiIcebergRepository >> withIceCommitWalkDo: aBlock [
	"Evaluate aBlock with a new IceCommitWalk, then close the walk even if the block fails, so its libgit2 revwalk is freed without waiting for the garbage collector."

	| walk |
	walk := self newIceCommitWalk.
	^ [ aBlock value: walk ] ensure: [ walk close ]
]
