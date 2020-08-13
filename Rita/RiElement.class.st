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

{ #category : #accessing }
RiElement >> allAncestors [
	| ancestors |
	ancestors := OrderedCollection new.
	self allAncestorsDo: [ :each | ancestors addIfNotPresent: each ].
	^ ancestors

]

{ #category : #enumeration }
RiElement >> allAncestorsDo: aBlockClosure [
	self ancestors do: [ :each |
		aBlockClosure value: each.
		each allAncestorsDo: aBlockClosure ].

]

{ #category : #accessing }
RiElement >> allChildren [
	| children |
	children := OrderedCollection new.
	self allChildrenDo: [ :each | children addIfNotPresent: each ].
	^ children

]

{ #category : #accessing }
RiElement >> allChildrenDo: aBlockClosure [ 
	self children do: [ :each |
		aBlockClosure value: each.
		each allChildrenDo: aBlockClosure ]

]

{ #category : #accessing }
RiElement >> ancestorToDiffIfPresent: presentBlockClosure ifAbsent: absentBlockClosure [
	"Detect the first ancestor (potentially ignores other ancestors, in case of merge, as usually tools do)."

	^ self ancestors
		ifEmpty: absentBlockClosure
		ifNotEmpty: [ :col | presentBlockClosure value: col first ]
]

{ #category : #accessing }
RiElement >> ancestors [
	"Answer a collection of RiElement sub-instances."

	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> author [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> children [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> comment [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> dateAndTime [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> detectInAllAncestors: aBlockClosure ifFound: foundBlockClosure [
	self allAncestorsDo: [ :each | 
		(aBlockClosure value: each)
			ifTrue: [ ^ foundBlockClosure cull: each ] ]
]

{ #category : #accessing }
RiElement >> detectInAllChildren: aBlockClosure ifFound: foundBlockClosure [
	self allChildrenDo: [ :each | 
		(aBlockClosure value: each)
			ifTrue: [ ^ foundBlockClosure cull: each ] ]
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
RiElement >> shortDescription [
	^ self subclassResponsibility
]

{ #category : #accessing }
RiElement >> shortId [
	^ self subclassResponsibility
]

{ #category : #enumeration }
RiElement >> withAllAncestorsDo: aBlockClosure [ 
	aBlockClosure value: self.
	self allAncestorsDo: aBlockClosure.
]
