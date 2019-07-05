Class {
	#name : #HiMCommand,
	#superclass : #Object,
	#instVars : [
		'navigator'
	],
	#category : #'Rita-Navigator'
}

{ #category : #accessing }
HiMCommand >> navigator [
	^ navigator
]

{ #category : #accessing }
HiMCommand >> navigator: anObject [
	navigator := anObject
]
