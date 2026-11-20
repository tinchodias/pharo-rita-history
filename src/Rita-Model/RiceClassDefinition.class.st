"
I represent a class read from an Iceberg repository, either from a commit or from the working directory in disk.

My contents is the class definition code.

See my superclasses for more information.
"
Class {
	#name : 'RiceClassDefinition',
	#superclass : 'RiceMethodContainerDefinition',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceClassDefinition >> accept: aVisitor [ 
	
	^ aVisitor visitClassDefinition: self
]

{ #category : 'accessing' }
RiceClassDefinition >> basicName [
	^ name
]

{ #category : 'accessing' }
RiceClassDefinition >> contents [

	^ self definition
]

{ #category : 'as yet unclassified' }
RiceClassDefinition >> icon [
	^ self iconNamed: #class
]

{ #category : 'testing' }
RiceClassDefinition >> isClassDefinition [
	
	^ true
]

{ #category : 'testing' }
RiceClassDefinition >> isLowImpactAppliedTo: anotherClassDefinition [
	"The definitions are equal, ignoring their comments"

	^ self variables = anotherClassDefinition variables and: [
		  (self propertyValues associations reject: [ :each | #( comment commentStamp ) includes: each key ])
		  = (anotherClassDefinition propertyValues associations reject: [ :each | #( comment commentStamp ) includes: each key ]) ]
]
