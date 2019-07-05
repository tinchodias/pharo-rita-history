Class {
	#name : #HiMCommand,
	#superclass : #Object,
	#instVars : [
		'navigator'
	],
	#category : #'Rita-Navigator-UI-Commands'
}

{ #category : #accessing }
HiMCommand >> navigator [
	^ navigator
]

{ #category : #accessing }
HiMCommand >> navigator: anObject [
	navigator := anObject
]
