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
	
	| currentSegment fileReference filePath |
	currentSegment := path segments first.
	
	filePath := aNode path / currentSegment.
	fileReference := version fileSystem resolve: filePath.
		
	"Do not import if the file does not exist in git"
	fileReference exists
		ifFalse: [ ^ self ].

	"If I represent a package, let's do it and do nothing else.
	This could be optimized to add the exact methods and avoid MC diff afterwards"
	((diff isCodeSubdirectory: aNode)
		and: [ version writerClass isValidPackage: fileReference ])
			ifTrue: [ ^ self ensurePackageFromDirectory: fileReference inParentNode: aNode ].

	"If I do not represent a package, I may be a file or a directory that may (recursively) contain a method or a package.
	For now, we only support packages inside the declared subdirectory (or root otherwise).
	All other changes are simple directory/file changes"
	
	"If path = 1 this means it is not a directory"
	path size = 1
		ifTrue: [ 
				(fileReference exists and: [ fileReference isFile ]) ifTrue: [
				^ aNode addChild: (RiceFileDefinition named: currentSegment path: filePath fileReference: fileReference) ] ].
	
	path size > 1 ifTrue: [ | directoryReference directoryPath |
		directoryPath := aNode path / currentSegment.
		directoryReference := version fileSystem resolve: directoryPath.
			directoryReference exists ifTrue: [
				"Otherwise, we recursively create a directory structure"
				self nextPath importOn: (self ensureDirectory: fileReference inParentNode: aNode) ] ].
	
	"If path size = 0 we should stop recursion"
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

{ #category : 'accessing' }
RiceGitChangeImporter >> repository [
	
	^ diff repository
]

{ #category : 'accessing' }
RiceGitChangeImporter >> version: aVersion [
	
	version := aVersion
]
