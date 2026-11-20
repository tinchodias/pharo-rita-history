"
I represent a variable of an IceClassDefinition or IceTraitDefinition.

Variables have a name, that identify them, and a type. They can be added and removed from the container.
"
Class {
	#name : 'RiceVariableDefinition',
	#superclass : 'RiceContainedDefinition',
	#instVars : [
		'mcVariableDefinition'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'comparing' }
RiceVariableDefinition >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	^ super = anObject
		and: [ mcVariableDefinition = anObject mcVariableDefinition ]
]

{ #category : 'visiting' }
RiceVariableDefinition >> accept: aVisitor [
	^ aVisitor visitVariableDefinition: self
]

{ #category : 'accessing' }
RiceVariableDefinition >> contents [
	
	^ 'Variable of type: ', self typeToShow
]

{ #category : 'comparing' }
RiceVariableDefinition >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ super hash bitXor: mcVariableDefinition hash
]

{ #category : 'accessing' }
RiceVariableDefinition >> icon [
	^ self iconNamed: #menuPin
]

{ #category : 'accessing' }
RiceVariableDefinition >> key [
	^ '>Variable (' , self typeToShow, '): ', mcVariableDefinition name
]

{ #category : 'accessing' }
RiceVariableDefinition >> mcVariableDefinition [
	^ mcVariableDefinition
]

{ #category : 'accessing' }
RiceVariableDefinition >> mcVariableDefinition: aMCVariableDefinition [
	mcVariableDefinition := aMCVariableDefinition.
	self name: mcVariableDefinition name
]

{ #category : 'printing' }
RiceVariableDefinition >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $[;
		print: self typeToShow;
		nextPut: $]

]

{ #category : 'accessing' }
RiceVariableDefinition >> typeToShow [
	^ mcVariableDefinition class type
]
