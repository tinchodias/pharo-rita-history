Class {
	#name : #RiIceOperationColorVisitor,
	#superclass : #Object,
	#instVars : [
		'aesthetics'
	],
	#category : #'Rita-Roassal3'
}

{ #category : #'instance creation' }
RiIceOperationColorVisitor class >> newForAesthetics: aRiAestheticsModel [
	^ self basicNew
		initializeForAesthetics: aRiAestheticsModel;
		yourself
]

{ #category : #initialization }
RiIceOperationColorVisitor >> initializeForAesthetics: aRiAestheticsModel [ 
	self initialize.
	aesthetics := aRiAestheticsModel.

]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitAddition: anIceAddition [ 
	^ aesthetics colorForLineInsert
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitModification: anIceModification [ 
	^ aesthetics colorForLineModification
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitNoModification: anIceNoModification [
	^ aesthetics colorForLineNoModification
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitRemoval: anIceRemoval [
	^ aesthetics colorForLineRemove
]
