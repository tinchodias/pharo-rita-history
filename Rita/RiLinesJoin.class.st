Class {
	#name : #RiLinesJoin,
	#superclass : #Object,
	#instVars : [
		'string',
		'kind',
		'to',
		'from'
	],
	#category : #'Rita-Diff'
}

{ #category : #'instance creation' }
RiLinesJoin class >> from: anIndex to: anotherIndex kind: aSymbol string: aString [
	^ self basicNew
		initializeFrom: anIndex to: anotherIndex kind: aSymbol string: aString;
		yourself
]

{ #category : #initialization }
RiLinesJoin >> initializeFrom: anIndex to: anotherIndex kind: aSymbol string: aString [
	self initialize.
	from := anIndex.
	to := anotherIndex.
	string := aString.
	kind := aSymbol
]

{ #category : #printing }
RiLinesJoin >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: self rawkind;
		space;
		print: from;
		nextPutAll: ' to ';
		print: to;
		nextPutAll: ')'


]

{ #category : #accessing }
RiLinesJoin >> rawfrom [
	^ from
]

{ #category : #accessing }
RiLinesJoin >> rawkind [
	^ kind
]

{ #category : #accessing }
RiLinesJoin >> rawstring [
	^ string value
]

{ #category : #accessing }
RiLinesJoin >> rawto [
	^ to
]
