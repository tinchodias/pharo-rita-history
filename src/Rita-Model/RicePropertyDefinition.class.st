"
I represent a property of an IceClassDefinition or IceTraitDefinition. For example, the comment.

A property has a name and a value, and only its value can change. Properties cann't be removed from the container.
"
Class {
	#name : 'RicePropertyDefinition',
	#superclass : 'RiceContainedDefinition',
	#instVars : [
		'propertyValue'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'comparing' }
RicePropertyDefinition >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	^ super = anObject and: [ self propertyValue = anObject propertyValue ]
]

{ #category : 'visiting' }
RicePropertyDefinition >> accept: aVisitor [
	^ aVisitor visitPropertyDefinition: self
]

{ #category : 'patching' }
RicePropertyDefinition >> addedIn: aMCDefinition [

	^ aMCDefinition copy
		basicAtPropertyNamed: self propertyName
			put: self propertyValue;
		yourself
]

{ #category : 'accessing' }
RicePropertyDefinition >> contents [
	^ self propertyValue asString
]

{ #category : 'comparing' }
RicePropertyDefinition >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: self propertyValue hash
]

{ #category : 'testing' }
RicePropertyDefinition >> isDefaultValue [
	name = #superclassName ifTrue: [ 
		^ self propertyValue = #Object ].

	name = #type ifTrue: [
		^ self propertyValue = #normal ].

	name = #comment ifTrue: [ 
		^ self propertyValue isNil or: [ self propertyValue isEmpty ] ].

	(#(traitComposition classTraitComposition) includes: name) ifTrue: [ 
		^ self propertyValue = '{}' ].
	
	^ false
]

{ #category : 'testing' }
RicePropertyDefinition >> isLowImpactAppliedTo: anIcePropertyDefinition [ 
	^ #(category comment commentStamp timeStamp) includes: self propertyName
]

{ #category : 'accessing' }
RicePropertyDefinition >> key [
	^ '>Property: ', name
]

{ #category : 'accessing' }
RicePropertyDefinition >> propertyName [
	^ name
]

{ #category : 'accessing' }
RicePropertyDefinition >> propertyValue [
	^ propertyValue ifNil: [
		propertyValue := containerDefinition asMCDefinition basicAtPropertyNamed: name ]
]

{ #category : 'patching' }
RicePropertyDefinition >> removeFromPatcher: aMCPatcher [
	"Cannot remove a property, just change it."

]
