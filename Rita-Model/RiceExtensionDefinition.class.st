"
I represent a container of method extensions read from an Iceberg repository, either from a commit or from the working directory in disk.
The package containing this definition will have as many instances of myself as different classes are extended.

My contents is just an empty string as the extended class/trait is not defined in the package.

See my superclasses for more information.
"
Class {
	#name : #RiceExtensionDefinition,
	#superclass : #RiceMethodContainerDefinition,
	#instVars : [
		'packageName'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceExtensionDefinition class >> named: aString packageName: aName [
	^ self new
		name: aString;
		packageName: aName;
		yourself
]

{ #category : #comparing }
RiceExtensionDefinition >> = otherExtension [
	^ self species = otherExtension species 
		and: [ self name = otherExtension name ]
]

{ #category : #visiting }
RiceExtensionDefinition >> accept: aVisitor [

	^ aVisitor visitExtensionDefinition: self
]

{ #category : #patching }
RiceExtensionDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [

	"Do nothing. Monticello does not have definitions for extensions"
]

{ #category : #patching }
RiceExtensionDefinition >> addToPatcher: aMCPatcher [ 
	
	"Monticello does not reify extensions"
]

{ #category : #accessing }
RiceExtensionDefinition >> contents [
	^ ''
]

{ #category : #comparing }
RiceExtensionDefinition >> hash [
	^ self name hash
]

{ #category : #'as yet unclassified' }
RiceExtensionDefinition >> icon [
	^ self iconNamed: #group
]

{ #category : #testing }
RiceExtensionDefinition >> isExtensionDefinition [
	
	^ true
]

{ #category : #comparing }
RiceExtensionDefinition >> key [
	^ super key, ' (extension)'
]

{ #category : #accessing }
RiceExtensionDefinition >> packageName [
	^ packageName
]

{ #category : #accessing }
RiceExtensionDefinition >> packageName: anObject [
	packageName := anObject
]

{ #category : #patching }
RiceExtensionDefinition >> removeFrom: aPatcher [
	
	"Do nothing. Do not remove extensions"
]

{ #category : #patching }
RiceExtensionDefinition >> removeFromPatcher: aMCPatcher [ 
	
	"Monticello does not reify extensions"
]
