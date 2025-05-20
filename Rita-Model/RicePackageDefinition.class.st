"
I represent a package inside the iceberg repository. How I am built depends on the repository format (e.g., tonel or filetree).

My contents are the tags defined in the package.

See my superclasses for more information.
"
Class {
	#name : #RicePackageDefinition,
	#superclass : #RiceDefinition,
	#instVars : [
		'package',
		'categories',
		'path'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #visiting }
RicePackageDefinition >> accept: aVisitor [
	
	^ aVisitor visitPackage: self
]

{ #category : #patching }
RicePackageDefinition >> addModification: anotherIceModification toPatcher: aMCPatcher [ 

	"In MC there is no such thing as a MCPackage definition.
	Instead, we should manage organization definitions.
	The problem is that they have no identity: they do not know the package they belong to.
	Then, if we just apply this modification, we end up just adding a new definition (and having both).
	To solve this, we remove the old organization and add the new one explicitly."

	aMCPatcher removeDefinition: anotherIceModification asMCDefinition.
	^ aMCPatcher addDefinition: self asMCDefinition
]

{ #category : #patching }
RicePackageDefinition >> addToPatcher: aPatcher [
	
	aPatcher addDefinition: (MCOrganizationDefinition categories: ({name}, categories))
]

{ #category : #accessing }
RicePackageDefinition >> asMCDefinition [
	
	^ MCOrganizationDefinition categories: categories
]

{ #category : #'as yet unclassified' }
RicePackageDefinition >> canBeBrowsed [
	
	^ RPackage organizer includesPackageNamed: name
]

{ #category : #'as yet unclassified' }
RicePackageDefinition >> canBrowseReferences [
	
	^ false
]

{ #category : #accessing }
RicePackageDefinition >> categories [
	^ categories
]

{ #category : #accessing }
RicePackageDefinition >> categories: aCollection [

	categories := aCollection
]

{ #category : #accessing }
RicePackageDefinition >> contents [
	
	^ String streamContents: [ :stream |
		stream nextPutAll:	'Package tags: '.
		categories do: [ :elem | 
			stream nextPutAll: String crlf;
				nextPutAll: String tab;
				nextPutAll: elem.
	]]
]

{ #category : #'as yet unclassified' }
RicePackageDefinition >> icon [
	^ self iconNamed: #package
]

{ #category : #initialization }
RicePackageDefinition >> initialize [

	super initialize.
	categories := #()
]

{ #category : #testing }
RicePackageDefinition >> isPackageDefinition [
	
	^ true
]

{ #category : #accessing }
RicePackageDefinition >> package [
	
	^ package
]

{ #category : #accessing }
RicePackageDefinition >> path [
	^ path
]

{ #category : #accessing }
RicePackageDefinition >> path: aRelativePath [ 
	
	path := aRelativePath
]

{ #category : #operations }
RicePackageDefinition >> removeFrom: aVisitor [ 
	aVisitor removePackage: self
]

{ #category : #patching }
RicePackageDefinition >> removeFromPatcher: aPatcher [
	
	aPatcher removeDefinition: (MCOrganizationDefinition categories: categories)
]
