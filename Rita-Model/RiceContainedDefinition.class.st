"
I am an abstract class that represents a sub-definition of either a IceClassDefinition or an IceTraitDefinition.

My instances only have meaning as elements of the container. 
"
Class {
	#name : #RiceContainedDefinition,
	#superclass : #RiceCodeDefinition,
	#instVars : [
		'containerDefinition'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #comparing }
RiceContainedDefinition >> = anotherDefinition [
	"Answer whether the receiver and anObject represent the same object."

	^ super = anotherDefinition
		and: [ containerDefinition name = anotherDefinition containerIceDefinition name ]
]

{ #category : #visiting }
RiceContainedDefinition >> accept: aVisitor [
	^ aVisitor visitContainedDefinition: self
]

{ #category : #patching }
RiceContainedDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [

(aMCPatcher isKindOf: MCPackageLoader) ifTrue: [ ^self "containerMCDefinition did it" ].

	aMCPatcher definitionIndex
		definitionLike: anotherIceDefinition containerMCDefinition
		ifPresent: [ :currentDefinition | 
			aMCPatcher addDefinition: (self addedIn: currentDefinition) ]
		ifAbsent: [ self error ].

]

{ #category : #patching }
RiceContainedDefinition >> addToPatcher: aMCPatcher [ 

	(aMCPatcher isKindOf: MCPackageLoader) ifTrue: [
		^ self "containerIceDefinition is just fine" ].

	aMCPatcher definitionIndex
		definitionLike: self containerIceDefinition asMCDefinition
		ifPresent: [ :currentDefinition |
			aMCPatcher addDefinition: (self addedIn: currentDefinition) ]
		ifAbsent: [ self error ].

]

{ #category : #patching }
RiceContainedDefinition >> addedIn: aMCDefinition [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiceContainedDefinition >> browse [
	self containerIceDefinition browse
]

{ #category : #accessing }
RiceContainedDefinition >> containerIceDefinition [
	^ containerDefinition
]

{ #category : #accessing }
RiceContainedDefinition >> containerIceDefinition: anObject [
	containerDefinition := anObject
]

{ #category : #accessing }
RiceContainedDefinition >> containerMCDefinition [
	^ containerDefinition asMCDefinition
]

{ #category : #accessing }
RiceContainedDefinition >> contents [
	
	^ self subclassResponsibility
]

{ #category : #comparing }
RiceContainedDefinition >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: containerDefinition hash
]

{ #category : #accessing }
RiceContainedDefinition >> icon [
	^ self iconNamed: #menuPin
]

{ #category : #testing }
RiceContainedDefinition >> isLowImpactAppliedTo: anIcePropertyDefinition [ 
	^ false
]

{ #category : #patching }
RiceContainedDefinition >> removeFrom: aPatcher [
	(self className , 'removeFrom: ' , aPatcher asString) traceCr
]

{ #category : #patching }
RiceContainedDefinition >> removeFromPatcher: aMCPatcher [ 
	
	self subclassResponsibility
]
