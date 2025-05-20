"
I reprensent a non-conflict between two operations that can be solved automatically. The user can still override the automatic choice using #selectLeft and #selectRight.
"
Class {
	#name : 'RiceNonConflictingOperation',
	#superclass : 'RiceOperationMerge',
	#instVars : [
		'operation'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceNonConflictingOperation class >> operation: anOperation [
	
	^ self new
		operation: anOperation;
		yourself
]

{ #category : 'visiting' }
RiceNonConflictingOperation >> accept: aVisitor [
	
	^ aVisitor visitNonConflictingOperation: self
]

{ #category : 'morphic-compatibility' }
RiceNonConflictingOperation >> actualClass [
	
	^ operation definition actualClass
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> chosenOperation [
	
	^ chosen
		ifNil: [ operation ]
		ifNotNil: [ chosen ]
]

{ #category : 'morphic-compatibility' }
RiceNonConflictingOperation >> contextClass [
	
	^ operation contextClass
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> definition [
	
	"This is just for compatibility"
	^ operation definition
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> description [
	
	"Any of my instances should have the same description"
	^ operation description
]

{ #category : 'testing' }
RiceNonConflictingOperation >> isConflict [

	^ false
]

{ #category : 'resolution' }
RiceNonConflictingOperation >> isLeftChosen [
	
	^ chosen = operation
]

{ #category : 'resolution' }
RiceNonConflictingOperation >> isRightChosen [
	
	^ chosen = operation inverse
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> key [
	
	"Any of my operations should have the same key"
	^ operation key
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> leftContents [
	
	^ operation leftContents
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> operation: anIceModification [ 
	operation := anIceModification
]

{ #category : 'as yet unclassified' }
RiceNonConflictingOperation >> operationIcon [
	
	^ operation icon
]

{ #category : 'as yet unclassified' }
RiceNonConflictingOperation >> preferredColor [
	
	^ self isResolved
		ifTrue: [ Color gray ]
		ifFalse: [ nil ]
]

{ #category : 'accessing' }
RiceNonConflictingOperation >> rightContents [
	
	^ operation rightContents
]

{ #category : 'resolution' }
RiceNonConflictingOperation >> selectLeft [
	
	chosen := operation
]

{ #category : 'resolution' }
RiceNonConflictingOperation >> selectRight [
	
	chosen := operation inverse
]
