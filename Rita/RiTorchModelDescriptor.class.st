"
I am polymorphic to RSUMLClassDescriptor.
"
Class {
	#name : #RiTorchModelDescriptor,
	#superclass : #Object,
	#category : #'Rita-Roassal3'
}

{ #category : #private }
RiTorchModelDescriptor >> childrenToShowFor: node withClassName: aClassName [
	^ (node children
		select: [ :each | each value definition class name = aClassName ])
		sorted: [ :a :b | a value definition class name < b value definition class name ]
]

{ #category : #accessing }
RiTorchModelDescriptor >> classProperties [
	^ [ :node | self childrenToShowFor: node withClassName: #IcePropertyDefinition ]
]

{ #category : #accessing }
RiTorchModelDescriptor >> classname [
	^ [ :node | node value name ]
]

{ #category : #accessing }
RiTorchModelDescriptor >> instVars [
	^ [ :node | self childrenToShowFor: node withClassName: #IceVariableDefinition ]
]

{ #category : #accessing }
RiTorchModelDescriptor >> methods [
	^ [ :node | self methodsToShowFor: node ]
]

{ #category : #accessing }
RiTorchModelDescriptor >> methodsLimit [
	^ SmallInteger maxVal
]

{ #category : #private }
RiTorchModelDescriptor >> methodsToShowFor: iceNodeWithBehavior [

	| methodNodes |
	methodNodes := iceNodeWithBehavior children
		select: [ :each | each value definition isMethodDefinition ].
	methodNodes := methodNodes
		sorted: [ :a :b | 
			a value class = b value class
				ifTrue: [ a value definition linesOfCode > b value definition linesOfCode ]
				ifFalse: [ a value class name < b value class name ] ].
	^ methodNodes
]
