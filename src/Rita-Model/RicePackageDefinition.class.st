"
I represent a package inside the iceberg repository. How I am built depends on the repository format (e.g., tonel or filetree).

My contents are the tags defined in the package.

See my superclasses for more information.
"
Class {
	#name : 'RicePackageDefinition',
	#superclass : 'RiceDefinition',
	#instVars : [
		'package',
		'categories',
		'path'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RicePackageDefinition >> accept: aVisitor [
	
	^ aVisitor visitPackage: self
]

{ #category : 'as yet unclassified' }
RicePackageDefinition >> canBeBrowsed [
	
	^ self packageOrganizer includesPackageNamed: name
]

{ #category : 'as yet unclassified' }
RicePackageDefinition >> canBrowseReferences [
	
	^ false
]

{ #category : 'accessing' }
RicePackageDefinition >> categories [
	^ categories
]

{ #category : 'accessing' }
RicePackageDefinition >> categories: aCollection [

	categories := aCollection
]

{ #category : 'accessing' }
RicePackageDefinition >> contents [
	
	^ String streamContents: [ :stream |
		stream nextPutAll:	'Package tags: '.
		categories do: [ :elem | 
			stream nextPutAll: String crlf;
				nextPutAll: String tab;
				nextPutAll: elem.
	]]
]

{ #category : 'as yet unclassified' }
RicePackageDefinition >> icon [
	^ self iconNamed: #package
]

{ #category : 'initialization' }
RicePackageDefinition >> initialize [

	super initialize.
	categories := #()
]

{ #category : 'testing' }
RicePackageDefinition >> isPackageDefinition [
	
	^ true
]

{ #category : 'accessing' }
RicePackageDefinition >> package [
	
	^ package
]

{ #category : 'accessing' }
RicePackageDefinition >> path [
	^ path
]

{ #category : 'accessing' }
RicePackageDefinition >> path: aRelativePath [ 
	
	path := aRelativePath
]
