"
I am an abstract class representing a non-code element read from an Iceberg repository, either from a commit or from the working directory in disk.

My concrete subclasses represent directories and files.

See my superclasses for more information.
"
Class {
	#name : #RiceFileSystemDefinition,
	#superclass : #RiceDefinition,
	#instVars : [
		'path',
		'fileReference'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceFileSystemDefinition class >> named: aString path: aPath [
	
	^ (self named: aString)
		path: aPath
		yourself
]

{ #category : #'as yet unclassified' }
RiceFileSystemDefinition >> canBeBrowsed [
	
	"It can always be browsed through the libgit file system"
	^ true
]

{ #category : #'as yet unclassified' }
RiceFileSystemDefinition >> canBrowseReferences [
	
	"We do not track file references..."
	^ false
]

{ #category : #accessing }
RiceFileSystemDefinition >> fileReference [

	^ fileReference
]

{ #category : #accessing }
RiceFileSystemDefinition >> fileReference: aFileReference [

	fileReference := aFileReference 
]

{ #category : #testing }
RiceFileSystemDefinition >> isLowImpactAppliedTo: anIceFileDefinition [
	"May be arbitrary: We assume it doesn't affect behavior of code entities."

	^ true
]

{ #category : #accessing }
RiceFileSystemDefinition >> path [
	^ path
]

{ #category : #accessing }
RiceFileSystemDefinition >> path: anObject [
	path := anObject
]

{ #category : #visiting }
RiceFileSystemDefinition >> removeFrom: aVisitor [
	
	aVisitor removeFileReferenceInPath: self path
]
