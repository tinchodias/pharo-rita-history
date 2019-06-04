Class {
	#name : #RiSummaryElement,
	#superclass : #Object,
	#instVars : [
		'commits'
	],
	#category : #'Rita-Summary'
}

{ #category : #accessing }
RiSummaryElement >> addCommit: aRiCommit [ 
	self commits add: aRiCommit
]

{ #category : #accessing }
RiSummaryElement >> commits [
	^ commits ifNil: [ 
		commits := OrderedCollection new ]
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
