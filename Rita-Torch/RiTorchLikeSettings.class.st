Class {
	#name : #RiTorchLikeSettings,
	#superclass : #Object,
	#instVars : [
		'colorByPackage',
		'draggable'
	],
	#category : #'Rita-Torch-Settings'
}

{ #category : #accessing }
RiTorchLikeSettings >> colorByPackage [
	^ colorByPackage
]

{ #category : #accessing }
RiTorchLikeSettings >> colorByPackage: anObject [
	colorByPackage := anObject
]

{ #category : #accessing }
RiTorchLikeSettings >> draggable [
	^ draggable
]

{ #category : #accessing }
RiTorchLikeSettings >> draggable: anObject [
	draggable := anObject
]

{ #category : #initialization }
RiTorchLikeSettings >> initialize [
	super initialize.
	
	colorByPackage := false.
	draggable := false.

]
