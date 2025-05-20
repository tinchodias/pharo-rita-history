"
I am an abstract class representing an IceDefinition that is a container of methods. I.e., a class, a trait or an extension.

I have a name which is the name of the container I represent. If I'm meta-side, I add to my name a suffix class. For example: Integer class.

I also contain the monticello definition that corresponds to me.

See my super/subclasses for more information.
"
Class {
	#name : #RiceMethodContainerDefinition,
	#superclass : #RiceCodeDefinition,
	#instVars : [
		'mcDefinition'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceMethodContainerDefinition class >> named: aString [
	
	^ self new
		name: aString;
		yourself
]

{ #category : #patching }
RiceMethodContainerDefinition >> allPropertyNames [
	^ MCClassDefinition instVarNames copyWithoutAll: #(name variables commentStamp)
]

{ #category : #patching }
RiceMethodContainerDefinition >> asMCDefinition [
	^ mcDefinition
]

{ #category : #'as yet unclassified' }
RiceMethodContainerDefinition >> browse [
	
	| browsed |
	browsed := Smalltalk globals at: name.
	browsed isMeta ifTrue: [ browsed classSide ].
	browsed browse
]

{ #category : #'as yet unclassified' }
RiceMethodContainerDefinition >> canBeBrowsed [
	
	^ Smalltalk globals includesKey: name
]

{ #category : #'as yet unclassified' }
RiceMethodContainerDefinition >> canBrowseReferences [
	
	^ self canBeBrowsed
]

{ #category : #private }
RiceMethodContainerDefinition >> childrenDefinitions [
	^ self propertyDefinitions, self variableDefinitions
]

{ #category : #patching }
RiceMethodContainerDefinition >> mcDefinition [
	^ mcDefinition
]

{ #category : #patching }
RiceMethodContainerDefinition >> mcDefinition: aMCDefinition [
	mcDefinition := aMCDefinition
]

{ #category : #patching }
RiceMethodContainerDefinition >> removeFrom: aPatcher [
	
	aPatcher removeClass: self
]

{ #category : #patching }
RiceMethodContainerDefinition >> variableDefinitions [
	^ mcDefinition variables
		collect: [ :each | 
			RiceVariableDefinition new
				mcVariableDefinition: each;
				containerIceDefinition: self;
				yourself ]
]
