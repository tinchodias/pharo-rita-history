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
	^ aesthetics insertColor
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitModification: anIceModification [ 
	^ aesthetics modificationColor 
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitNoModification: anIceNoModification [
	^ aesthetics colorForLineNoModification
]

{ #category : #visiting }
RiIceOperationColorVisitor >> visitRemoval: anIceRemoval [
	^ aesthetics removeColor
]
