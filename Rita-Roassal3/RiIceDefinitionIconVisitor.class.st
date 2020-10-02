Class {
	#name : #RiIceDefinitionIconVisitor,
	#superclass : #Object,
	#instVars : [
		'aesthetics'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiIceDefinitionIconVisitor class >> newForAesthetics: aRiAestheticsModel [
	^ self basicNew
		initializeForAesthetics: aRiAestheticsModel;
		yourself
]

{ #category : #initialization }
RiIceDefinitionIconVisitor >> initializeForAesthetics: aRiAestheticsModel [ 
	self initialize.
	aesthetics := aRiAestheticsModel.

]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitClassDefinition: anIceClassDefinition [
	^ self iconNamed: #class
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitDirectoryDefinition: d [
	^ self iconNamed: #emptyPackage
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitExtensionDefinition: anIceExtensionDefinition [
	^ self iconNamed: #group
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitFileNode: anIceFileDefinition [
	^ self iconNamed: #book
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitMethodNode: anIceMethodDefinition [
	^ self iconNamed: #tinyMenu
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitPackage: anIcePackageDefinition [
	^ self iconNamed: #package
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitPropertyDefinition: anIcePropertyDefinition [ 
	^ aesthetics iconForClassPropertyDefinition: anIcePropertyDefinition
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitTraitDefinition: anIceTraitDefinition [
	^ self iconNamed: #trait
]

{ #category : #visiting }
RiIceDefinitionIconVisitor >> visitVariableDefinition: anIceVariableDefinition [
	^ aesthetics iconForClassVariableDefinition: anIceVariableDefinition
]
