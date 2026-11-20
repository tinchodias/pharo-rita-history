"
I am the generic part of a git repository seen by Rita: I own the elements (commits and uncommitted working copies) and their marks, and I answer questions about the graph of commits. A subclass reads a concrete backend, such as Iceberg, and implements the hooks of #process.
"
Class {
	#name : 'RiRepository',
	#superclass : 'Object',
	#instVars : [
		'elementMarks',
		'elements',
		'elementById'
	],
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'processing' }
RiRepository >> addCommitElement: aRiCommit [
	"Add aRiCommit to my elements. Commits have to be added newest first."

	elements add: aRiCommit.
	elementById at: aRiCommit id put: aRiCommit
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

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiRepository >> elementById [

	^ elementById
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

{ #category : 'accessing' }
RiRepository >> fetch [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiRepository >> name [

	^ self subclassResponsibility
]

{ #category : 'diffing' }
RiRepository >> newDiffFrom: aSourceRiElement to: aTargetRiElement [
	"Answer a RiceDiff between two of my elements"

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiRepository >> openInNativeBrowser [

	^ self subclassResponsibility
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
	"Build my elements and marks by walking the repository, starting from the children-most leaves: branches and tags.
	The backend specific steps are the hooks #processTips, #processCommits, #processMarks, #processImageMark and #processWorkdirMark."

	elementMarks := OrderedCollection new.
	elements := OrderedCollection new.
	elementById := Dictionary new.
	self processTips.
	self processCommits.
	self processCommitGraph.
	self processMarks.
	self processImageMark.
	self processWorkdirMark
]

{ #category : 'processing' }
RiRepository >> processCommitGraph [
	"Connect all collected RiCommits in terms of child/parent. The parents are looked up by id in a dictionary, so no commit is read again from the repository. This cache made the opening of Pharo (38k commits) go from 7.5sec to 4sec"

	self commits do: [ :each |
		each ancestorIds collect: [ :ancestorId | elementById at: ancestorId ] thenDo: [ :ancestor |
			ancestor addChildren: each.
			each addAncestor: ancestor ] ]
]

{ #category : 'processing' }
RiRepository >> processCommits [
	"Hook: create the commit elements, newest first, and add each of them with #addCommitElement:."

	^ self subclassResponsibility
]

{ #category : 'processing' }
RiRepository >> processImageMark [
	"Hook: add a mark for the commit the running image is based on. Nothing to do by default."

	
]

{ #category : 'processing' }
RiRepository >> processMarks [
	"Hook: add the marks of the branches and the tags to the commit elements, and to my element marks."

	^ self subclassResponsibility
]

{ #category : 'processing' }
RiRepository >> processTips [
	"Hook: determine the branches and tags the commits are walked from. Nothing to do by default."

	
]

{ #category : 'processing' }
RiRepository >> processWorkdirMark [
	"Hook: add a mark for the changes of the working directory. Nothing to do by default."

	
]

{ #category : 'processing' }
RiRepository >> refresh [
	self reset; process
]

{ #category : 'dependencies' }
RiRepository >> release [

	^ self subclassResponsibility
]

{ #category : 'processing' }
RiRepository >> reset [

	elementById := elementMarks := elements := nil
]

{ #category : 'searching' }
RiRepository >> selectCommitsWithChangesAt: aPath [
	"Answer the commits that change aPath, newest first"

	^ self subclassResponsibility
]
