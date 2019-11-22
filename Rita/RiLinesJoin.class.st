Class {
	#name : #RiLinesJoin,
	#superclass : #Object,
	#instVars : [
		'rawfrom',
		'rawto',
		'rawpatch'
	],
	#category : #'Rita-Diff'
}

{ #category : #printing }
RiLinesJoin >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		print: self rawkind;
		space;
		print: rawfrom;
		nextPutAll: ' to ';
		print: rawto;
		nextPutAll: ')'


]

{ #category : #accessing }
RiLinesJoin >> rawfrom [
	^ rawfrom
]

{ #category : #accessing }
RiLinesJoin >> rawfrom: anObject [
	rawfrom := anObject
]

{ #category : #accessing }
RiLinesJoin >> rawkind [
	^ rawpatch key
]

{ #category : #accessing }
RiLinesJoin >> rawpatch [
	^ rawpatch
]

{ #category : #accessing }
RiLinesJoin >> rawpatch: anObject [
	rawpatch := anObject
]

{ #category : #accessing }
RiLinesJoin >> rawstring [
	^ rawpatch value
]

{ #category : #accessing }
RiLinesJoin >> rawto [
	^ rawto
]

{ #category : #accessing }
RiLinesJoin >> rawto: anObject [
	rawto := anObject
]
