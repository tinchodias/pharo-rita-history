"
I represent a file inside the iceberg repository. 

My contents are the contents of the file, utf8 decoded.

See my superclasses for more information.
"
Class {
	#name : 'RiceFileDefinition',
	#superclass : 'RiceFileSystemDefinition',
	#instVars : [
		'contents'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceFileDefinition class >> named: aString path: aPath contents: contents [
	
	^ (self named: aString path: aPath)
		basicContents: contents
		yourself
]

{ #category : 'instance creation' }
RiceFileDefinition class >> named: aString path: aPath fileReference: aFileReference [
	^ self
		named: aString
		path: aPath
		contents: (aFileReference binaryReadStreamDo: [ :each | each upToEnd ])
]

{ #category : 'comparing' }
RiceFileDefinition >> = anotherDefinition [

	^ super = anotherDefinition and: [ contents = anotherDefinition basicContents ]
]

{ #category : 'visiting' }
RiceFileDefinition >> accept: aVisitor [
	
	^ aVisitor visitFileNode: self
]

{ #category : 'comparing' }
RiceFileDefinition >> basicContents [

	^ contents
]

{ #category : 'accessing' }
RiceFileDefinition >> basicContents: anObject [

	contents := anObject
]

{ #category : 'accessing' }
RiceFileDefinition >> contents [
	"Contents for display purposes.
	If the file is binary (or could not detect as utf8 file) then just return an hexa dump representation of the contents
	If the file is in utf8 decode it and show the text"

	^ self isBinary
		ifTrue: [ String streamContents: [ :stream | contents hexDumpOn: stream max: Float infinity ] ]
		ifFalse: [ contents utf8Decoded ]
]

{ #category : 'accessing' }
RiceFileDefinition >> contents: anObject [

	contents := anObject
]

{ #category : 'comparing' }
RiceFileDefinition >> hash [
	
	^ self contents hash
]

{ #category : 'as yet unclassified' }
RiceFileDefinition >> icon [
	^ self iconNamed: #book
]

{ #category : 'testing' }
RiceFileDefinition >> isBinary [
	
	[contents utf8Decoded] on: ZnInvalidUTF8 do: [ ^ true ].
	^ false
]

{ #category : 'testing' }
RiceFileDefinition >> isFileDefinition [
	
	^ true
]

{ #category : 'operations' }
RiceFileDefinition >> removeFrom: aVisitor [ 
	aVisitor removeFile: self
]
