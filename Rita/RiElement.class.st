"
Represents an element in the contents list of a repository.
"
Class {
	#name : #RiElement,
	#superclass : #Object,
	#instVars : [
		'marks'
	],
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiElement >> accept: aVisitor [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> addMark: aRiMark [
	self marks add: aRiMark.
	aRiMark element: self.
	^ aRiMark
]

{ #category : #enumeration }
RiElement >> allAncestorsDo: aBlockClosure [
	self ancestors do: [ :each |
		aBlockClosure value: each.
		each allAncestorsDo: aBlockClosure ].

]

{ #category : #accessing }
RiElement >> ancestors [
	"Answer a collection of RiElement sub-instances."

	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> author [
	^ ''
]

{ #category : #accessing }
RiElement >> comment [
	^ ''
]

{ #category : #accessing }
RiElement >> date [
	^ ''
]

{ #category : #testing }
RiElement >> isUncommited [
	^ false
]

{ #category : #accessing }
RiElement >> marks [
	^ marks ifNil: [ marks := OrderedCollection new ]
]

{ #category : #accessing }
RiElement >> repository [
	"Answer the RiRepository that contains me."

	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> shortId [
	^ ''
]

{ #category : #enumeration }
RiElement >> withAllAncestorsDo: aBlockClosure [ 
	aBlockClosure value: self.
	self allAncestorsDo: aBlockClosure.
]
