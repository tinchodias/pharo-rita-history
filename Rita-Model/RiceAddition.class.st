"
I am an addition in a tree. I contain the definition I'm adding. I know what is the icon for addition and how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceAddition',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceAddition >> accept: aVisitor [
	
	^ aVisitor visitAddition: self
]

{ #category : 'as yet unclassified' }
RiceAddition >> icon [
	
	^ self iconNamed: #changeAdd
]

{ #category : 'operations' }
RiceAddition >> inverse [
	
	^ RiceRemoval definition: definition
]

{ #category : 'testing' }
RiceAddition >> isAddition [
	
	^ true
]

{ #category : 'contents' }
RiceAddition >> leftContents [
	
	^ definition contents
]

{ #category : 'merging' }
RiceAddition >> mergeWithLeftAddition: anIceAddition [ 
	
	"If the addition is the same, I can just keep any of them."
	anIceAddition definition = self definition 
		ifTrue: [ ^ RiceNonConflictingOperation operation: anIceAddition ].
		
	^ RiceConflictingOperation left: anIceAddition right: self
]

{ #category : 'merging' }
RiceAddition >> mergeWithLeftModification: anIceModification [ 
	
	"This should not happen. If I represent an addition of a node, that means that the original definition did not exist on the base version.
	Thus, the left version can never MODIFY a non existing version. It can add it too."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceAddition >> mergeWithLeftNoOperation: anIceNoModification [ 
	
	"This should not happen. If I represent an addition of a node, that means that the original definition did not exist on the base version.
	Thus, the left version can never have an operation on the same element."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceAddition >> mergeWithLeftRemoval: anIceRemoval [ 
	
	"This should not happen. If I represent an addition of a node, that means that the original definition did not exist on the base version.
	Thus, the left version can never REMOVE a non existing version. It can add it too."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceAddition >> mergeWithOperation: anOperation [
	
	^ anOperation mergeWithLeftAddition: self
]

{ #category : 'accessing' }
RiceAddition >> rightContents [
	
	^ ''
]
