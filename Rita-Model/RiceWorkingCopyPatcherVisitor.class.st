"
I visit a tree of changes and apply those changes to the working copy.
"
Class {
	#name : #RiceWorkingCopyPatcherVisitor,
	#superclass : #RiceTreeVisitor,
	#instVars : [
		'repository',
		'loader'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceWorkingCopyPatcherVisitor class >> on: aRepository [
	^ self new 
		repository: aRepository;
		yourself
]

{ #category : #initialization }
RiceWorkingCopyPatcherVisitor >> initialize [
	super initialize.
	loader := MCPackageLoader new
]

{ #category : #loading }
RiceWorkingCopyPatcherVisitor >> load [
	loader load
]

{ #category : #actions }
RiceWorkingCopyPatcherVisitor >> removeClass: anIceClassDefinition [ 
	
	repository workingCopy removeClassNamed: anIceClassDefinition name
]

{ #category : #removing }
RiceWorkingCopyPatcherVisitor >> removeFile: anIceFileDefinition [ 
	"I do not remove nothing from the file in the image"
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> removeFileReferenceInPath: anUndefinedObject [ 
	
	"I do not remove nothing from the file in the image"
]

{ #category : #actions }
RiceWorkingCopyPatcherVisitor >> removeMethod: anIceMethodDefinition [ 

	repository workingCopy removeMethod: anIceMethodDefinition
]

{ #category : #operations }
RiceWorkingCopyPatcherVisitor >> removePackage: anIcePackageDefinition [ 
	
	repository workingCopy unloadPackageNamed: anIcePackageDefinition name
]

{ #category : #accessing }
RiceWorkingCopyPatcherVisitor >> repository [
	^ repository
]

{ #category : #accessing }
RiceWorkingCopyPatcherVisitor >> repository: anObject [
	repository := anObject
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitAddition: anIceAddition [ 
	
	repository workingCopy applyDefinition: anIceAddition definition inNode: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitClassDefinition: anIceClassDefinition [ 
	
	repository workingCopy applyDefinition: anIceClassDefinition inNode: currentNode.
	self visitChildrenOf: currentNode.
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitContainedDefinition: anIceContainedDefinition [ 

	repository workingCopy applyDefinition: anIceContainedDefinition containerIceDefinition inNode: currentNode parent.
	self visitChildrenOf: currentNode.
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitDirectoryDefinition: anIceDirectoryDefinition [

	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitExtensionDefinition: anIceExtensionDefinition [ 
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitFileNode: anIceFileDefinition [
	
	"Ignore files, they are not loaded in the image"
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitMethodNode: anIceMethodDefinition [ 

	repository workingCopy applyDefinition: anIceMethodDefinition inNode: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitModification: anIceModification [ 
	
	anIceModification definition accept: self
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitNoModification: anIceNoModification [ 

	anIceNoModification definition accept: self
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitNonConflictingOperation: anIceNonConflictingOperation [ 
	
	^ anIceNonConflictingOperation chosenOperation accept: self
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitPackage: anIcePackageDefinition [
	
	(self repository packageNamed: anIcePackageDefinition name) isLoaded
		ifFalse: [ ^ self ].
	
	currentNode accept: (IceMCSnapshotPatchVisitor new
		patcher: loader;
		yourself).
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitPropertyDefinition: anIceContainedDefinition [

	^ self visitContainedDefinition: anIceContainedDefinition
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitRemoval: anIceRemoval [ 
	
	anIceRemoval definition removeFrom: self.
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitRootDefinition: anIceRootDefinition [ 
	
	self visitChildrenOf: currentNode
]

{ #category : #visiting }
RiceWorkingCopyPatcherVisitor >> visitVariableDefinition: anIceContainedDefinition [

	^ self visitContainedDefinition: anIceContainedDefinition
]
