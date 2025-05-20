"
I represent a directory inside the iceberg repository. 

My contents is an empty string.

See my superclasses for more information.
"
Class {
	#name : #RiceDirectoryDefinition,
	#superclass : #RiceFileSystemDefinition,
	#category : #'Rita-Model-Changes'
}

{ #category : #visiting }
RiceDirectoryDefinition >> accept: aVisitor [
	
	^ aVisitor visitDirectoryDefinition: self
]

{ #category : #accessing }
RiceDirectoryDefinition >> contents [
	
	^ ''
]

{ #category : #'as yet unclassified' }
RiceDirectoryDefinition >> icon [
	^ self iconNamed: #emptyPackage
]

{ #category : #testing }
RiceDirectoryDefinition >> isDirectoryDefinition [
	
	^ true
]
