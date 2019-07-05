Class {
	#name : #HiMNodeCommand,
	#superclass : #HiMCommand,
	#instVars : [
		'node'
	],
	#category : #'Rita-Navigator-UI-Commands'
}

{ #category : #accessing }
HiMNodeCommand >> node [
	^ node
]

{ #category : #accessing }
HiMNodeCommand >> node: anObject [
	node := anObject
]
