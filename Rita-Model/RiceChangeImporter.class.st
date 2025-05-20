"
I am a visitor that imports changes from different sources into a tree.

I receive the node where I have to work on, a version, and the I can be visited by several sources (like git or image changes). 

I work recursively: I create new instances of myself to build the children nodes of my node.
"
Class {
	#name : 'RiceChangeImporter',
	#superclass : 'Object',
	#instVars : [
		'parentNode',
		'sourceSnapshot',
		'targetSnapshot',
		'diff',
		'operation',
		'version'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'importing' }
RiceChangeImporter >> addFileNamed: aString path: aRelativePath contents: aByteArray [ 

	| fileParentNode |

	fileParentNode := parentNode.
	aRelativePath segments allButLastDo: [ :each | 
		fileParentNode := (fileParentNode includesKey: each)
			ifTrue: [ fileParentNode / each ]
			ifFalse: [ fileParentNode addChild: (RiceDirectoryDefinition named: each path: aRelativePath parent) ].
		self assert: fileParentNode value isDirectoryDefinition ].

	fileParentNode addChild: (RiceFileDefinition
		named: aString
		path: aRelativePath
		contents: aByteArray).
]

{ #category : 'accessing' }
RiceChangeImporter >> diff: anIceDiff [ 
	diff := anIceDiff
]

{ #category : 'private' }
RiceChangeImporter >> ensureDirectoryAtPath: aPathSegments inNode: aNode [

	| firstChild |
	aPathSegments ifEmpty: [ ^ aNode ].
	firstChild := self ensureDirectoryNamed: aPathSegments first inNode: aNode.
	^ self ensureDirectoryAtPath: aPathSegments allButFirst inNode: firstChild
]

{ #category : 'private' }
RiceChangeImporter >> ensureDirectoryNamed: aName inNode: aNode [

	aNode childAt: aName ifPresent: [ :node |
		self assert: node value isDirectoryDefinition.
		^ node ].
	^ aNode addChild: (RiceDirectoryDefinition named: aName path: aNode path / aName)
]

{ #category : 'private' }
RiceChangeImporter >> ensureSourceCodeParentNodeIn: aNode [
	
	^ self
		ensureDirectoryAtPath: diff repository subdirectoryPath segments
		inNode: aNode
]

{ #category : 'accessing' }
RiceChangeImporter >> parentNode: anIcePackageNode [ 
	parentNode := anIcePackageNode
]

{ #category : 'accessing' }
RiceChangeImporter >> version: aVersion [ 
	
	version := aVersion
]

{ #category : 'visiting' }
RiceChangeImporter >> visitCypressPropertiesChange: anIceCypressPropertiesChange [ 
	
	version properties addToChangeBuilder: self
]

{ #category : 'as yet unclassified' }
RiceChangeImporter >> visitGitChange: anIceGitChange [ 

	| importer |
	importer := IceGitChangeImporter new
		path: anIceGitChange path;
		diff: diff;
		version: version;
		yourself.
	importer importOn: parentNode.
]

{ #category : 'visiting' }
RiceChangeImporter >> visitImageChange: anIceImageChange [ 

	| importer |
	importer := RiceMCPackageImporter new
		package: anIceImageChange package;
		version: version;
		yourself.
	^ importer importOn: (self ensureSourceCodeParentNodeIn: parentNode)
]

{ #category : 'as yet unclassified' }
RiceChangeImporter >> visitMemoryChange: anIceMemoryChange [ 
	
	| importer |
	importer := RiceMCPackageImporter new
		package: anIceMemoryChange package;
		version: version;
		yourself.
	^ importer importOn: parentNode
]

{ #category : 'visiting' }
RiceChangeImporter >> visitProjectChange: anIceProjectChange [ 
	
	"Import the project file extracted from the commit without utterly post-treatment to create the new project file"
	
	version project addToChangeBuilder: self
]
