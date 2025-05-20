"
I reprensent a conflict between two operations that can be solved by using #selectLeft and #selectRight.
"
Class {
	#name : #RiceConflictingOperation,
	#superclass : #RiceOperationMerge,
	#instVars : [
		'leftOperation',
		'rightOperation'
	],
	#category : #'Rita-Model-Changes'
}

{ #category : #'instance creation' }
RiceConflictingOperation class >> left: leftOperation right: rightOperation [
	
	^ self new
		leftOperation: leftOperation;
		rightOperation: rightOperation;
		yourself
]

{ #category : #visiting }
RiceConflictingOperation >> accept: aVisitor [
	
	^ aVisitor visitConflictingOperation: self
]

{ #category : #'morphic-compatibility' }
RiceConflictingOperation >> actualClass [
	
	^ leftOperation definition actualClass
]

{ #category : #resolution }
RiceConflictingOperation >> chosenOperation [

	^ chosen
]

{ #category : #'morphic-compatibility' }
RiceConflictingOperation >> contextClass [
	
	^ leftOperation contextClass
]

{ #category : #accessing }
RiceConflictingOperation >> definition [
	
	"This is just for compatibility"
	^ leftOperation definition
]

{ #category : #accessing }
RiceConflictingOperation >> description [
	
	"Any of my instances should have the same description"
	^ leftOperation description
]

{ #category : #testing }
RiceConflictingOperation >> isConflict [

	^ true
]

{ #category : #resolution }
RiceConflictingOperation >> isLeftChosen [
	
	^ chosen = leftOperation
]

{ #category : #resolution }
RiceConflictingOperation >> isRightChosen [
	
	^ chosen = rightOperation
]

{ #category : #accessing }
RiceConflictingOperation >> key [
	
	"Any of my operations should have the same key"
	^ leftOperation key
]

{ #category : #accessing }
RiceConflictingOperation >> leftContents [
	
	^ leftOperation leftContents
]

{ #category : #accessing }
RiceConflictingOperation >> leftOperation: anOperation [
	
	leftOperation := anOperation
]

{ #category : #'as yet unclassified' }
RiceConflictingOperation >> operationIcon [
	^ self iconNamed: #changeUpdate
]

{ #category : #'as yet unclassified' }
RiceConflictingOperation >> preferredColor [
	
	^ self isResolved
		ifTrue: [ Color gray ]
		ifFalse: [ Color red ]
]

{ #category : #accessing }
RiceConflictingOperation >> rightContents [
	
	^ rightOperation leftContents
]

{ #category : #accessing }
RiceConflictingOperation >> rightOperation: anOperation [
	
	rightOperation := anOperation
]

{ #category : #resolution }
RiceConflictingOperation >> selectLeft [
	
	chosen := leftOperation
]

{ #category : #resolution }
RiceConflictingOperation >> selectRight [
	
	chosen := rightOperation
]
