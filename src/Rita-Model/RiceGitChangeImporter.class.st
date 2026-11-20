Class {
	#name : 'RiceGitChangeImporter',
	#superclass : 'Object',
	#instVars : [
		'path',
		'diff',
		'version'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'accessing' }
RiceGitChangeImporter >> diff: anIceDiff [ 
	diff := anIceDiff
]

{ #category : 'building' }
RiceGitChangeImporter >> ensureDirectory: aFileReference inParentNode: aNode [
	
	aNode childAt: aFileReference basename ifPresent: [ :node |
		self assert: node value isDirectoryDefinition.
		^ node ].
	^ aNode addChild: (RiceDirectoryDefinition named: aFileReference basename path: aNode path / aFileReference basename)
]

{ #category : 'building' }
RiceGitChangeImporter >> ensurePackageFromDirectory: aFileReference inParentNode: aParentNode [
	
	| importer packageName package |
	
	packageName := version writerClass packageNameFromDirectory: aFileReference.
	
	"Package already exists"
	(aParentNode includesKey: packageName)
		ifTrue: [ ^ self ].
	
	package := IcePackage
		named: packageName
		repository: self repository.
	
	importer := RiceMCPackageImporter new
		package: package;
		version: version;
		yourself.
	^ importer importOn: aParentNode
]

{ #category : 'importing' }
RiceGitChangeImporter >> importOn: aNode [

	| currentSegment fileReference filePath directoryPath directoryReference |
	currentSegment := path segments first.

	filePath := aNode path / currentSegment.
	fileReference := version fileSystem resolve: filePath.

	"Do not import if the file does not exist in git"
	fileReference exists ifFalse: [ ^ self ].

	"If I represent a package, let's import it and do nothing else. Commits import only the changed file of the package."
	((diff isCodeSubdirectory: aNode) and: [ version writerClass isValidPackage: fileReference ]) ifTrue: [ ^ self importPackageDirectory: fileReference onto: aNode ].

	"If I do not represent a package, I may be a file or a directory that may (recursively) contain a method or a package.
	For now, we only support packages inside the declared subdirectory (or root otherwise).
	All other changes are simple directory/file changes"

	"If path = 1 this means it is not a directory"
	path size = 1 ifTrue: [ (fileReference exists and: [ fileReference isFile ]) ifTrue: [ ^ aNode addChild: (RiceFileDefinition named: currentSegment path: filePath fileReference: fileReference) ] ].

	path size > 1 ifFalse: [ ^ self ].

	directoryPath := aNode path / currentSegment.
	directoryReference := version fileSystem resolve: directoryPath.
	directoryReference exists ifTrue: [ "Otherwise, we recursively create a directory structure" self nextPath importOn: (self ensureDirectory: fileReference inParentNode: aNode) ]
	
	 "If path size = 0 we should stop recursion"
]

{ #category : 'building' }
RiceGitChangeImporter >> importPackageDirectory: aPackageDirectory onto: aParentNode [
	"Import the package at aPackageDirectory. Commits are read one changed file at a time: reading a whole package is slow, and the rest of the package is unchanged. Other versions (the working copy) read the whole package."

	(self readsFilesOneByOne and: [ path segments size = 2 ]) ifFalse: [ ^ self ensurePackageFromDirectory: aPackageDirectory inParentNode: aParentNode ].

	^ (RiceMCPackageImporter new
		   package: (IcePackage named: (version writerClass packageNameFromDirectory: aPackageDirectory) repository: self repository);
		   version: version;
		   yourself) importFileNamed: path segments last onto: aParentNode
]

{ #category : 'building' }
RiceGitChangeImporter >> nextPath [

	^ self class new
		path: (RelativePath withAll: path segments allButFirst);
		diff: diff;
		version: version;
		yourself.
]

{ #category : 'accessing' }
RiceGitChangeImporter >> path: aRelativePath [ 
	path := aRelativePath
]

{ #category : 'testing' }
RiceGitChangeImporter >> readsFilesOneByOne [
	"Answer whether my version is a commit stored in Tonel, whose package files can be read one by one. The working copy and the other formats read whole packages."

	^ version class == IceGitCommit and: [ version writerClass == IceLibgitTonelWriter ]
]

{ #category : 'accessing' }
RiceGitChangeImporter >> repository [
	
	^ diff repository
]

{ #category : 'accessing' }
RiceGitChangeImporter >> version: aVersion [
	
	version := aVersion
]
