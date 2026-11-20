"
I enrich a IceLibGitRepository object with RiElements.
"
Class {
	#name : 'RiRepository',
	#superclass : 'Object',
	#instVars : [
		'elementByCommit',
		'elementMarks',
		'elements',
		'iceRepository',
		'iceBranches',
		'iceTags'
	],
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'instance creation' }
RiRepository class >> iceRepository: anIceLibgitRepository [
	^ self basicNew
		initializeWithIceRepository: anIceLibgitRepository;
		yourself
]

{ #category : 'accessing' }
RiRepository >> ancestorsOrSelfOf: aRiElement [
	"Answer an IdentitySet holding aRiElement and all its ancestors, visiting each element once."

	| result pending |
	result := IdentitySet new.
	pending := OrderedCollection with: aRiElement.
	[ pending isEmpty ] whileFalse: [
			| element |
			element := pending removeLast.
			(result includes: element) ifFalse: [
					result add: element.
					pending addAll: element ancestors ] ].
	^ result
]

{ #category : 'accessing' }
RiRepository >> commitAtSha: hexString [
	^ self commits detect: [ :each | each id = hexString ]
]

{ #category : 'accessing' }
RiRepository >> commits [
	^ elements reject: #isUncommited
]

{ #category : 'accessing' }
RiRepository >> description [
	^ iceRepository description
]

{ #category : 'accessing' }
RiRepository >> elementByCommit [
	^ elementByCommit
]

{ #category : 'accessing' }
RiRepository >> elementMarks [
	^ elementMarks
]

{ #category : 'accessing' }
RiRepository >> elements [
	^ elements
]

{ #category : 'accessing' }
RiRepository >> elementsFrom: aRiElement downTo: aBoundRiElementOrNil [
	"Answer my elements that are aRiElement or one of its ancestors, in my order (newest first).
	When aBoundRiElementOrNil is not nil, also exclude it and its ancestors, so I answer the range strictly above the bound, up to aRiElement included."

	| scopeElements |
	scopeElements := self ancestorsOrSelfOf: aRiElement.
	aBoundRiElementOrNil ifNotNil: [ :bound | scopeElements removeAll: (self ancestorsOrSelfOf: bound) ].
	^ self elements select: [ :element | scopeElements includes: element ]
]

{ #category : 'processing' }
RiRepository >> ensureProcessed [
	elements ifNil: [ self process ]
]

{ #category : 'actions' }
RiRepository >> fetch [
	iceRepository fetch
]

{ #category : 'accessing' }
RiRepository >> iceRepository [
	^ iceRepository
]

{ #category : 'accessing' }
RiRepository >> initializeWithIceRepository: anIceLibgitRepository [
	self initialize.
	iceRepository := anIceLibgitRepository
]

{ #category : 'accessing' }
RiRepository >> name [
	^ iceRepository name
]

{ #category : 'private' }
RiRepository >> newIceCommitWalk [
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

{ #category : 'actions' }
RiRepository >> openInNativeBrowser [
	iceRepository location openInNativeBrowser
]

{ #category : 'accessing' }
RiRepository >> previousReleaseElementOf: aRiElement [
	"Answer the previous release of aRiElement: the newest of its ancestors that is the commit of one of my tags (a release), or nil if there is none."

	| tagTipElements ancestors |
	tagTipElements := IdentitySet withAll: (self elementMarks
			                   select: #isTagMark
			                   thenCollect: #element).
	ancestors := self ancestorsOrSelfOf: aRiElement.
	^ self elements
		  detect: [ :element | element ~~ aRiElement and: [ (ancestors includes: element) and: [ tagTipElements includes: element ] ] ]
		  ifNone: [ nil ]
]

{ #category : 'printing' }
RiRepository >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: self name;
		nextPut: $)
]

{ #category : 'processing' }
RiRepository >> process [
	"Build my elements and marks by walking the repository,
	starting from the children-most leaves: branches and tags."

	"Note: /HEAD branches were problematic, and they seem to be unwanted"
	iceBranches := iceRepository allBranches reject: [ :each |
			each isUnbornBranch or: [
			each name endsWith: '/HEAD' ] ].
	iceTags := iceRepository tags.

	"Determine the commit graph."
	self processCommits.
	self processCommitGraph.

	"Add our marks to the commit elements."
	iceBranches do: [ :each | self processBranchMark: each ].
	iceTags do: [ :each | self processTagMark: each ].

	"Add new non-commit elements to the list, if needed."
	self processImageMark.
	self processWorkdirMark.

]

{ #category : 'private' }
RiRepository >> processBranchMark: anIceCommitish [ 

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

{ #category : 'private' }
RiRepository >> processCommitGraph [
	"Connect all collected RiCommits in terms of child/parent. The parents are looked up by id in a dictionary, so no commit is read again from the repository. This cache made the opening of Pharo (38k commits) go from 7.5sec to 4sec"

	| elementById |
	elementById := Dictionary new.
	elementByCommit keysAndValuesDo: [ :commit :element | elementById at: commit id put: element ].
	self commits do: [ :each |
			each iceGitCommit ancestorIds
				collect: [ :ancestorId | elementById at: ancestorId ]
				thenDo: [ :ancestor |
						ancestor addChildren: each.
						each addAncestor: ancestor ] ]
]

{ #category : 'private' }
RiRepository >> processCommits [
	"Determine the commits in the proper order via Libgit's revwalk."

	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementByCommit := Dictionary new.

	iceRepository head isUnbornBranch ifTrue: [ ^ self ].

	self withIceCommitWalkDo: [ :walk |
			walk commitsDo: [ :each |
					| newCommit |
					newCommit := RiCommit repository: self iceGitCommit: each.
					elements add: newCommit.
					elementByCommit at: each put: newCommit ] ]
]

{ #category : 'accessing' }
RiRepository >> processImageMark [
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

{ #category : 'private' }
RiRepository >> processTagMark: anIceCommitish [ 

	| element mark |
	element := elementByCommit at: anIceCommitish commit.

	mark := RiTagMark new tag: anIceCommitish; yourself.

	element addMark: mark.
	elementMarks add: mark

]

{ #category : 'accessing' }
RiRepository >> processWorkdirMark [
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

{ #category : 'processing' }
RiRepository >> refresh [
	self reset; process
]

{ #category : 'processing' }
RiRepository >> reset [
	elementByCommit := elementMarks := elements := iceBranches := iceTags := nil
]

{ #category : 'accessing' }
RiRepository >> selectLibgitCommitsWithChangesAt: aPath [
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
RiRepository >> withIceCommitWalkDo: aBlock [
	"Evaluate aBlock with a new IceCommitWalk, then close the walk even if the block fails, so its libgit2 revwalk is freed without waiting for the garbage collector."

	| walk |
	walk := self newIceCommitWalk.
	^ [ aBlock value: walk ] ensure: [ walk close ]
]
