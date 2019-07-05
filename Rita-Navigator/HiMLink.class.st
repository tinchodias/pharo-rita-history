Class {
	#name : #HiMLink,
	#superclass : #Object,
	#instVars : [
		'from',
		'to'
	],
	#category : #'Rita-Navigator'
}

{ #category : #'instance creation' }
HiMLink class >> from: aHiMNode to: anotherHiMNode [
	^ self new
		from: aHiMNode;
		to: anotherHiMNode;
		yourself
]

{ #category : #accessing }
HiMLink >> from [
	^ from
]

{ #category : #accessing }
HiMLink >> from: anObject [
	from := anObject
]

{ #category : #printing }
HiMLink >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPut: $(;
		print: from object;
		nextPutAll: '->';
		print: to object;
		nextPut: $).
]

{ #category : #accessing }
HiMLink >> to [
	^ to
]

{ #category : #accessing }
HiMLink >> to: anObject [
	to := anObject
]
