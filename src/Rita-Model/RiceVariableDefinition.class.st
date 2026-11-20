"
I represent a variable of an IceClassDefinition or IceTraitDefinition.

Variables have a name, that identify them, and a type. They can be added and removed from the container.
"
Class {
	#name : 'RiceVariableDefinition',
	#superclass : 'RiceContainedDefinition',
	#instVars : [
		'variableType'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'comparing' }
RiceVariableDefinition >> = anObject [

	^ super = anObject and: [ variableType = anObject variableType ]
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

	^ super hash bitXor: variableType hash
]

{ #category : 'accessing' }
RiceVariableDefinition >> icon [
	^ self iconNamed: #menuPin
]

{ #category : 'accessing' }
RiceVariableDefinition >> key [

	^ '>Variable (' , self typeToShow , '): ' , name
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

	^ variableType
]

{ #category : 'accessing' }
RiceVariableDefinition >> variableType [
	"Answer the type of the variable, such as 'instance' or 'class'"

	^ variableType
]

{ #category : 'accessing' }
RiceVariableDefinition >> variableType: aString [

	variableType := aString
]
