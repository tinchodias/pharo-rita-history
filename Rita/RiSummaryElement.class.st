Class {
	#name : #RiSummaryElement,
	#superclass : #Object,
	#instVars : [
		'commits',
		'ancestors'
	],
	#category : #'Rita-Summary'
}

{ #category : #accessing }
RiSummaryElement >> addAncestor: aRiSummaryElement [ 
	self ancestors add: aRiSummaryElement
]

{ #category : #accessing }
RiSummaryElement >> addCommit: aRiCommit [ 
	self commits add: aRiCommit
]

{ #category : #accessing }
RiSummaryElement >> ancestors [
	^ ancestors ifNil: [ 
		ancestors := OrderedCollection new ]
]

{ #category : #accessing }
RiSummaryElement >> commits [
	^ commits ifNil: [ 
		commits := OrderedCollection new ]
]

{ #category : #testing }
RiSummaryElement >> hasMarks [
	^ self marks notEmpty
]

{ #category : #accessing }
RiSummaryElement >> marks [
	"The elements are headed by the one that generates this summary element."
	
	^ commits first marks
]

{ #category : #printing }
RiSummaryElement >> printOn: aStream [
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: self commits size;
		nextPut: $).
]
