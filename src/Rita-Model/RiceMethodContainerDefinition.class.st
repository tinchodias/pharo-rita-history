"
I am an abstract class representing an IceDefinition that is a container of methods. I.e., a class, a trait or an extension.

I have a name which is the name of the container I represent. If I'm meta-side, I add to my name a suffix class. For example: Integer class.

I also contain the monticello definition that corresponds to me.

See my super/subclasses for more information.
"
Class {
	#name : 'RiceMethodContainerDefinition',
	#superclass : 'RiceCodeDefinition',
	#instVars : [
		'propertyValues',
		'variables',
		'definition'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceMethodContainerDefinition class >> named: aString [
	
	^ self new
		name: aString;
		yourself
]

{ #category : 'patching' }
RiceMethodContainerDefinition >> allPropertyNames [
	"Answer the names of the properties of the container, in the order given by the backend"

	^ self propertyValues keys
]

{ #category : 'as yet unclassified' }
RiceMethodContainerDefinition >> browse [
	
	| browsed |
	browsed := Smalltalk globals at: name.
	browsed isMeta ifTrue: [ browsed classSide ].
	browsed browse
]

{ #category : 'as yet unclassified' }
RiceMethodContainerDefinition >> canBeBrowsed [
	
	^ Smalltalk globals includesKey: name
]

{ #category : 'as yet unclassified' }
RiceMethodContainerDefinition >> canBrowseReferences [
	
	^ self canBeBrowsed
]

{ #category : 'private' }
RiceMethodContainerDefinition >> childrenDefinitions [
	^ self propertyDefinitions, self variableDefinitions
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> definition [
	"Answer the text that defines the container, as shown to the user. The backend gives it."

	^ definition ifNil: [ '' ]
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> definition: aString [

	definition := aString
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> propertyValueAt: aPropertyName [

	^ self propertyValues at: aPropertyName ifAbsent: [ nil ]
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> propertyValues [
	"Answer an ordered dictionary of the properties of the container, such as its superclass name, its comment or its traits. The backend gives their values."

	^ propertyValues ifNil: [ propertyValues := OrderedDictionary new ]
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> propertyValues: anOrderedDictionary [

	propertyValues := anOrderedDictionary
]

{ #category : 'patching' }
RiceMethodContainerDefinition >> variableDefinitions [

	^ self variables collect: [ :each |
		  RiceVariableDefinition new
			  name: each key;
			  variableType: each value;
			  containerIceDefinition: self;
			  yourself ]
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> variables [
	"Answer the variables of the container as associations from the name of the variable to its type, such as 'instance' or 'class'"

	^ variables ifNil: [ variables := #(  ) ]
]

{ #category : 'accessing' }
RiceMethodContainerDefinition >> variables: aCollectionOfAssociations [

	variables := aCollectionOfAssociations
]
