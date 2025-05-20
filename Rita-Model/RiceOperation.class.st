"
I represent a merge operation. I know how to install myself in the system, how to inverse myself and how to show the definitions I'm being applied to. Check my subclasses for more information.
"
Class {
	#name : 'RiceOperation',
	#superclass : 'Object',
	#instVars : [
		'definition'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceOperation class >> definition: aDefinition [
	
	^ self new
		definition: aDefinition;
		yourself
]

{ #category : 'comparing' }
RiceOperation >> = anotherOperation [

	^ self species = anotherOperation species
		and: [ self leftDefinition = anotherOperation leftDefinition ]
]

{ #category : 'visiting' }
RiceOperation >> accept: aVisitor [
	
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RiceOperation >> browse [
	
	^ self leftDefinition browse
]

{ #category : 'as yet unclassified' }
RiceOperation >> canBeBrowsed [
	
	^ self leftDefinition canBeBrowsed
]

{ #category : 'as yet unclassified' }
RiceOperation >> canBrowseReferences [
	
	^ false
]

{ #category : 'morphic-compatibility' }
RiceOperation >> contextClass [
	
	^ definition contextClass
]

{ #category : 'accessing' }
RiceOperation >> definition [
	^ definition
]

{ #category : 'accessing' }
RiceOperation >> definition: aDefinition [

	definition := aDefinition
]

{ #category : 'accessing' }
RiceOperation >> description [
	
	^ definition key
]

{ #category : 'testing' }
RiceOperation >> hasChanges [
	
	^ true
]

{ #category : 'comparing' }
RiceOperation >> hash [
	^ self leftDefinition hash
]

{ #category : 'as yet unclassified' }
RiceOperation >> icon [
	
	self subclassResponsibility
]

{ #category : 'operations' }
RiceOperation >> install [
	
	self leftDefinition install
]

{ #category : 'operations' }
RiceOperation >> inverse [
	
	self subclassResponsibility
]

{ #category : 'testing' }
RiceOperation >> isAddition [
	
	^ false
]

{ #category : 'testing' }
RiceOperation >> isConflict [
	^false.
]

{ #category : 'testing' }
RiceOperation >> isModification [
	
	^ false
]

{ #category : 'testing' }
RiceOperation >> isNoModification [
	
	^ false
]

{ #category : 'testing' }
RiceOperation >> isOnlyLowImpact [
	^ false
]

{ #category : 'testing' }
RiceOperation >> isRemoval [
	
	^ false
]

{ #category : 'testing' }
RiceOperation >> isResolved [
	
	^ false
]

{ #category : 'accessing' }
RiceOperation >> key [
	
	^ definition key
]

{ #category : 'accessing' }
RiceOperation >> leftContents [
	
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperation >> leftDefinition [

	^ definition
]

{ #category : 'accessing' }
RiceOperation >> leftDefinition: aNode [

	definition := aNode
]

{ #category : 'merging' }
RiceOperation >> mergeWithLeftAddition: anIceAddition [ 
	
	self subclassResponsibility
]

{ #category : 'merging' }
RiceOperation >> mergeWithLeftModification: anIceModification [ 
	
	^ self subclassResponsibility
]

{ #category : 'merging' }
RiceOperation >> mergeWithLeftNoOperation: anIceNoModification [ 
	
	^ self subclassResponsibility
]

{ #category : 'merging' }
RiceOperation >> mergeWithLeftRemoval: anIceRemoval [ 
	
	self subclassResponsibility
]

{ #category : 'merging' }
RiceOperation >> mergeWithOperation: anOperation [
	
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperation >> name [
	
	^ definition name
]

{ #category : 'as yet unclassified' }
RiceOperation >> preferredColor [

	"Use the default color"
	^ nil
]

{ #category : 'printing' }
RiceOperation >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: definition;
		nextPut: $)

]

{ #category : 'accessing' }
RiceOperation >> rightContents [
	
	^ definition contents
]
