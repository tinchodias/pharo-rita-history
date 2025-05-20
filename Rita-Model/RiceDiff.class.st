"
I am a diff between two Iceberg Commitish's. I calculate a diff by:

 - Asking to the repository the list of changed files/packages between the two versions. These are obtained, for example, by the Monticello dirty flags and the list of modified files provided by Git.
 - Using that list, the diff calculates two trees of IceDefinition. Those trees are represented as compositions of IceNode.
 - Then, the two trees are diff'd (see #diff:with:), and a tree of differences is obtained. This tree is also a composition of IceNodes, but contains IceOperation objects instead (additions, deletions and modifications).

The diff is calculated from left to right. This means that the resulting operations are the operations to apply on the right tree (the destination) to obtain the same tree as in the left (the source).

I am created by doing one of the following:

- IceDiff from: aVersion to: anotherVersion.

- IceDiff new
	sourceVersion: aVersion;
	targetVersion: anotherVersion;
	build;
	yourself
"
Class {
	#name : 'RiceDiff',
	#superclass : 'Object',
	#instVars : [
		'tree',
		'source',
		'target',
		'writerClass',
		'mergedTree'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceDiff class >> from: sourceCommitish to: targetCommitish [
	
	^ self new
		sourceVersion: sourceCommitish;
		targetVersion: targetCommitish;
		build;
		yourself
]

{ #category : 'visiting' }
RiceDiff >> accept: aVisitor [
	
	^ tree accept: aVisitor
]

{ #category : 'building' }
RiceDiff >> build [

	self buildForChanges: (source changesTo: target)
]

{ #category : 'building' }
RiceDiff >> buildForAllFiles [

	| files changes |
	files := (source fileSystem childNames, target fileSystem childNames) asSet.
	changes := files collect: [ :each | IceGitChange on: each ].
	
	self buildForChanges: changes
]

{ #category : 'building' }
RiceDiff >> buildForChanges: aCollection [

	| leftTree rightTree |
	leftTree := RiceNode value: RiceRootDefinition new.
	rightTree := RiceNode value: RiceRootDefinition new.

	aCollection do: [ :change | 
		change accept: (RiceChangeImporter new
			version: source;
			diff: self;
			parentNode: leftTree;
			yourself).
			
		change accept: (RiceChangeImporter new
			version: target;
			diff: self;
			parentNode: rightTree;
			yourself) ] "displayingProgress: [ :change | change displayingProgressString ]".

	mergedTree := self mergedTreeOf: leftTree with: rightTree.
	tree := mergedTree select: [ :operation | operation hasChanges ].
]

{ #category : 'building' }
RiceDiff >> buildForPackages: aCollection [

	self buildForChanges: (aCollection collect: [ :package | RiceImageChange package: package ])
]

{ #category : 'building' }
RiceDiff >> buildFull [

	"Image changes should be processed before commit changes
	to take into account changes in the image"
	self buildForChanges: self imageChanges, (source referenceCommit changesTo: target) asArray
]

{ #category : 'testing' }
RiceDiff >> canRevertChanges [
	
	^ source canRevertChanges
]

{ #category : 'accessing' }
RiceDiff >> codeSubdirectoryNode [
	
	^ self repository subdirectory
		ifNotEmpty: [ tree firstNodeSuchThat: [ :definition | self isCodeSubdirectory: definition ] ]
		ifEmpty: [ tree ]
		
]

{ #category : 'copying' }
RiceDiff >> copyWithOnly: aCollection [ 
	
	| treeCopy selectedOperations |
	selectedOperations := aCollection collect: #value.
	treeCopy := tree select: [ :node | selectedOperations includes: node ].
	
	^ self class new
		sourceVersion: source;
		targetVersion: target;
		diffTree: treeCopy;
		yourself
]

{ #category : 'accessing' }
RiceDiff >> description [
	
	^ target description
]

{ #category : 'operations' }
RiceDiff >> diff: leftTree with: rightTree [

	^ (self mergedTreeOf: leftTree with: rightTree)
		select: [ :operation | operation hasChanges ]
]

{ #category : 'accessing' }
RiceDiff >> diffTree: anIceTreeDiff [

	tree := anIceTreeDiff
]

{ #category : 'building' }
RiceDiff >> imageChanges [

	^ self imageChangesForPackages: source loadedPackages
]

{ #category : 'building' }
RiceDiff >> imageChangesForPackages: aCollection [

	^ aCollection collect: [ :package | RiceImageChange package: package ] as: Array
]

{ #category : 'testing' }
RiceDiff >> includesPackageNamed: aString [
	^ self isEmpty not
		and: [ self codeSubdirectoryNode includesKey: aString ]
]

{ #category : 'testing' }
RiceDiff >> isCodeSubdirectory: aNode [
	
	| nodeLocation repositorySubdirectoryLocation |
	nodeLocation := self repository location resolve: aNode path.
	repositorySubdirectoryLocation := self repository subdirectoryReference.
	^ nodeLocation pathString = repositorySubdirectoryLocation pathString
]

{ #category : 'testing' }
RiceDiff >> isEmpty [
	
	^ tree isEmpty
]

{ #category : 'testing' }
RiceDiff >> isValidPackage: aFileReference [
	
	^ self writerClass isValidPackage: aFileReference
]

{ #category : 'accessing' }
RiceDiff >> mergedTree [
	^ mergedTree
]

{ #category : 'operations' }
RiceDiff >> mergedTreeOf: leftTree with: rightTree [
	
	^ leftTree
		mergeWith: rightTree
		onLeft: [ :definition | RiceAddition definition: definition ]
		onRight: [ :definition | RiceRemoval definition: definition ]
		onMerge: [ :left :right |
			left = right
				ifTrue: [ RiceNoModification definition: left ]
				ifFalse: [ RiceModification left: left right: right ] ]
]

{ #category : 'converting' }
RiceDiff >> packageNameFromDirectory: aString [ 
	
	^ self writerClass packageNameFromDirectory: aString
]

{ #category : 'accessing' }
RiceDiff >> packages [
	
	tree isEmpty ifTrue: [ ^ #( ) ].
	^ self codeSubdirectoryNode children
]

{ #category : 'accessing' }
RiceDiff >> repository [
	
	^ source repository
]

{ #category : 'accessing' }
RiceDiff >> sourceVersion [
	
	^ source
]

{ #category : 'accessing' }
RiceDiff >> sourceVersion: aCommitish [
	
	source := aCommitish
]

{ #category : 'accessing' }
RiceDiff >> targetVersion [
	
	^ target
]

{ #category : 'accessing' }
RiceDiff >> targetVersion: aCommitish [
	
	target := aCommitish
]

{ #category : 'accessing' }
RiceDiff >> tree [
	^ tree
]

{ #category : 'accessing' }
RiceDiff >> treeToShow [
	"Returns the tree to show in the UI.
	For a diff it is always the same tree.
	Polymorphic with an ice merge"
	^ self tree
]

{ #category : 'converting' }
RiceDiff >> writerClass [
	
	"I am cached per instance of diff because obtaining the writer class is an expensive operation (600ms per call)"
	^ writerClass ifNil: [ writerClass := self repository writerClass ]
]
