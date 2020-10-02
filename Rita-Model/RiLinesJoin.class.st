Class {
	#name : #RiLinesJoin,
	#superclass : #Object,
	#instVars : [
		'string',
		'kind',
		'to',
		'from'
	],
	#category : #'Rita-Model-Diff'
}

{ #category : #'instance creation' }
RiLinesJoin class >> from: anIndex to: anotherIndex kind: aSymbol string: aString [
	^ self basicNew
		initializeFrom: anIndex to: anotherIndex kind: aSymbol string: aString;
		yourself
]

{ #category : #accessing }
RiLinesJoin >> diffString [
	^ string
]

{ #category : #accessing }
RiLinesJoin >> fromIndex [
	^ from
]

{ #category : #initialization }
RiLinesJoin >> initializeFrom: anIndex to: anotherIndex kind: aSymbol string: aString [
	self initialize.
	from := anIndex.
	to := anotherIndex.
	string := aString.
	kind := aSymbol
]

{ #category : #accessing }
RiLinesJoin >> kindSymbol [
	^ kind
]

{ #category : #printing }
RiLinesJoin >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: kind;
		space;
		print: from;
		nextPutAll: ' to ';
		print: to;
		nextPutAll: ')'


]

{ #category : #accessing }
RiLinesJoin >> toIndex [
	^ to
]
