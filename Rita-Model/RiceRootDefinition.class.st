"
I am an IceDefinition representing the repository root. I contain all packages, directories and files of the repository. I'm not meant to be shown.

See my superclasses for more information.
"
Class {
	#name : #RiceRootDefinition,
	#superclass : #RiceDefinition,
	#category : #'Rita-Model-Changes'
}

{ #category : #visiting }
RiceRootDefinition >> accept: aVisitor [
	
	^ aVisitor visitRootDefinition: self
]

{ #category : #initialization }
RiceRootDefinition >> initialize [
	super initialize.
	name := ''.
]

{ #category : #testing }
RiceRootDefinition >> isRootDefinition [
	
	^ true
]
