"
I am an IceDefinition that have some source code in my contents.

See my sub/superclasses for more information.
"
Class {
	#name : 'RiceCodeDefinition',
	#superclass : 'RiceDefinition',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'as yet unclassified' }
RiceCodeDefinition class >> named: aName source: aString [
	
	^ (super named: aName)
		source: aString;
		yourself
]

{ #category : 'comparing' }
RiceCodeDefinition >> = anotherDefinition [

	^ super = anotherDefinition
		and: [ self contents = anotherDefinition contents ]
]

{ #category : 'patching' }
RiceCodeDefinition >> addModification: anotherIceDefinition toPatcher: aMCPatcher [ 
	
	self subclassResponsibility
]

{ #category : 'patching' }
RiceCodeDefinition >> addToPatcher: aMCPatcher [ 
	
	self subclassResponsibility
]

{ #category : 'properties' }
RiceCodeDefinition >> allPropertyNames [
	^ #()
]

{ #category : 'properties' }
RiceCodeDefinition >> childrenDefinitions [
	^ self propertyDefinitions
]

{ #category : 'comparing' }
RiceCodeDefinition >> hash [
	^ super hash bitXor: self contents hash
]

{ #category : 'properties' }
RiceCodeDefinition >> propertyDefinitions [
	^ self allPropertyNames
		collect: [ :each | 
			RicePropertyDefinition new
				name: each;
				containerIceDefinition: self;
				yourself.
			 ]
		thenReject: [ :each |
			each isDefaultValue ].

]

{ #category : 'patching' }
RiceCodeDefinition >> removeFrom: aPatcher [
	
	self subclassResponsibility
]
