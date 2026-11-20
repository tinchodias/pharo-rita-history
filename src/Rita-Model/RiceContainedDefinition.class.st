"
I am an abstract class that represents a sub-definition of either a IceClassDefinition or an IceTraitDefinition.

My instances only have meaning as elements of the container. 
"
Class {
	#name : 'RiceContainedDefinition',
	#superclass : 'RiceCodeDefinition',
	#instVars : [
		'containerDefinition'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'comparing' }
RiceContainedDefinition >> = anotherDefinition [
	"Answer whether the receiver and anObject represent the same object."

	^ super = anotherDefinition
		and: [ containerDefinition name = anotherDefinition containerIceDefinition name ]
]

{ #category : 'visiting' }
RiceContainedDefinition >> accept: aVisitor [
	^ aVisitor visitContainedDefinition: self
]

{ #category : 'accessing' }
RiceContainedDefinition >> browse [
	self containerIceDefinition browse
]

{ #category : 'accessing' }
RiceContainedDefinition >> containerIceDefinition [
	^ containerDefinition
]

{ #category : 'accessing' }
RiceContainedDefinition >> containerIceDefinition: anObject [
	containerDefinition := anObject
]

{ #category : 'accessing' }
RiceContainedDefinition >> contents [
	
	^ self subclassResponsibility
]

{ #category : 'comparing' }
RiceContainedDefinition >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: containerDefinition hash
]

{ #category : 'accessing' }
RiceContainedDefinition >> icon [
	^ self iconNamed: #menuPin
]

{ #category : 'testing' }
RiceContainedDefinition >> isLowImpactAppliedTo: anIcePropertyDefinition [ 
	^ false
]
