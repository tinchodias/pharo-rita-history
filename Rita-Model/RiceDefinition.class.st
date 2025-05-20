"
I represent the definition of an element in an Iceberg repository. My subclasses represent more concretely classes, traits, extensions, methods and files.

I am used to easily read and write from a repository working copy or commit. The Filetree or Tonel parser create IceDefinitions that are later on used to browse, generate diffs, or merges.

My main API is used to show myself in a diff or merge browser:

 - contents: textual value of the definition (e.g., the code of a class or a method, the contents of a file)
 - icon: the preferred icon to show this entity
 - accept: visitor API
 - is* to test which of my subclasses you're working with

I am also used for comparison to build diffs. See my definitions of equality along my subclasses.
"
Class {
	#name : #RiceDefinition,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceDefinition class >> named: aString [ 
	
	^ self new
		name: aString;
		yourself
]

{ #category : #comparing }
RiceDefinition >> = anotherDefinition [

	^ self species = anotherDefinition species
		and: [ name = anotherDefinition name ]
]

{ #category : #visiting }
RiceDefinition >> accept: aVisitor [
	
	self subclassResponsibility
]

{ #category : #accessing }
RiceDefinition >> contents [
	
	self subclassResponsibility
]

{ #category : #'morphic-compatibility' }
RiceDefinition >> contextClass [
	
	^ nil
]

{ #category : #comparing }
RiceDefinition >> hash [

	^ self name hash
]

{ #category : #'as yet unclassified' }
RiceDefinition >> icon [
	
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
RiceDefinition >> iconNamed: aSymbol [
	^ Smalltalk ui icons iconNamed: aSymbol
]

{ #category : #testing }
RiceDefinition >> isClassDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isDirectoryDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isExtensionDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isFileDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isMethodDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isPackageDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isRootDefinition [
	
	^ false
]

{ #category : #testing }
RiceDefinition >> isTraitDefinition [
	
	^ false
]

{ #category : #accessing }
RiceDefinition >> key [
	
	^ name
]

{ #category : #accessing }
RiceDefinition >> name [
	
	^ name
]

{ #category : #accessing }
RiceDefinition >> name: aString [ 
	
	name := aString
]

{ #category : #printing }
RiceDefinition >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: name;
		nextPut: $)
]

{ #category : #visiting }
RiceDefinition >> removeFrom: aVisitor [
	
	self subclassResponsibility
]
