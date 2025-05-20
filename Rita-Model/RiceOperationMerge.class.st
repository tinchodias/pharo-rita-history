"
I represent a merge between two operations. I know if I'm a conflict or not, if I have changes, and the user can use me to resolve a conflict.
"
Class {
	#name : 'RiceOperationMerge',
	#superclass : 'Object',
	#instVars : [
		'chosen'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceOperationMerge >> accept: aVisitor [
	
	^ self subclassResponsibility
]

{ #category : 'morphic-compatibility' }
RiceOperationMerge >> actualClass [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> chosenOperation [
	
	self subclassResponsibility
]

{ #category : 'resolution' }
RiceOperationMerge >> clearSelection [
	
	chosen := nil
]

{ #category : 'morphic-compatibility' }
RiceOperationMerge >> contextClass [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> definition [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> description [
	self subclassResponsibility
]

{ #category : 'testing' }
RiceOperationMerge >> hasChanges [

	^ self chosenOperation hasChanges
]

{ #category : 'as yet unclassified' }
RiceOperationMerge >> icon [

	self isRightChosen ifTrue: [ ^ self iconNamed: #changeBlock ].
	self isLeftChosen ifTrue: [ ^ self iconNamed: #forward ].
	
	^ self operationIcon
]

{ #category : 'testing' }
RiceOperationMerge >> isConflict [
	self subclassResponsibility
]

{ #category : 'resolution' }
RiceOperationMerge >> isLeftChosen [
	self subclassResponsibility
]

{ #category : 'morphic-compatibility' }
RiceOperationMerge >> isLoadable [
	^ false
]

{ #category : 'testing' }
RiceOperationMerge >> isResolved [
	
	^ chosen notNil
]

{ #category : 'resolution' }
RiceOperationMerge >> isRightChosen [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> key [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> leftContents [
	self subclassResponsibility
]

{ #category : 'as yet unclassified' }
RiceOperationMerge >> operationIcon [
	self subclassResponsibility
]

{ #category : 'accessing' }
RiceOperationMerge >> rightContents [
	self subclassResponsibility
]

{ #category : 'resolution' }
RiceOperationMerge >> selectLeft [
	self subclassResponsibility
]

{ #category : 'resolution' }
RiceOperationMerge >> selectRight [
	self subclassResponsibility
]
