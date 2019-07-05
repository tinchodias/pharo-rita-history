Class {
	#name : #HiMCommandHistory,
	#superclass : #Object,
	#instVars : [
		'commandsToUndo',
		'commandsToRedo'
	],
	#category : #'Rita-Navigator'
}

{ #category : #accessing }
HiMCommandHistory >> canRedo [
	^ commandsToRedo notEmpty
]

{ #category : #accessing }
HiMCommandHistory >> canUndo [
	^ commandsToUndo notEmpty
]

{ #category : #accessing }
HiMCommandHistory >> commandsToRedo [
	^ commandsToRedo
]

{ #category : #accessing }
HiMCommandHistory >> commandsToUndo [
	^ commandsToUndo
]

{ #category : #accessing }
HiMCommandHistory >> executeAndRegister: aCommand [
	aCommand execute.
	commandsToUndo addLast: aCommand.
	commandsToRedo removeAll.

]

{ #category : #initialization }
HiMCommandHistory >> initialize [
	super initialize.
	
	commandsToRedo := LinkedList new.
	commandsToUndo := LinkedList new.
]

{ #category : #accessing }
HiMCommandHistory >> redo [
	| aCommand |
	aCommand := commandsToRedo removeFirst.
	aCommand execute.
	commandsToUndo addLast: aCommand.

]

{ #category : #accessing }
HiMCommandHistory >> undo [
	| aCommand |
	aCommand := commandsToUndo removeLast.
	aCommand inverse execute.

	commandsToRedo addFirst: aCommand
]
