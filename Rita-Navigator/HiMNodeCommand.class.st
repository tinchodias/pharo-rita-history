Class {
	#name : #HiMNodeCommand,
	#superclass : #HiMCommand,
	#instVars : [
		'node'
	],
	#category : #'Rita-Navigator'
}

{ #category : #accessing }
HiMNodeCommand >> node [
	^ node
]

{ #category : #accessing }
HiMNodeCommand >> node: anObject [
	node := anObject
]
