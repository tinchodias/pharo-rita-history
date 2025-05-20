"
I am a removal in a tree. I contain the definition I'm removing. I know what is the icon for removal and how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceRemoval',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceRemoval >> accept: aVisitor [
	
	^ aVisitor visitRemoval: self
]

{ #category : 'as yet unclassified' }
RiceRemoval >> icon [

	^ self iconNamed: #changeRemove
]

{ #category : 'operations' }
RiceRemoval >> inverse [
	
	^ RiceAddition definition: definition
]

{ #category : 'testing' }
RiceRemoval >> isRemoval [
	
	^ true
]

{ #category : 'accessing' }
RiceRemoval >> leftContents [
	
	^ ''
]

{ #category : 'merging' }
RiceRemoval >> mergeWithLeftAddition: anIceAddition [ 
	
	"This should not happen. If I represent a removal of a node, that means that the original definition existed on the base version.
	Thus, the right version can never ADD an already existing version. It can remove it too or modify it."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceRemoval >> mergeWithLeftModification: anIceModification [ 
	
	^ RiceConflictingOperation
		left: anIceModification
		right: self
]

{ #category : 'merging' }
RiceRemoval >> mergeWithLeftNoOperation: anIceNoModification [ 
	
	"We assume that if the IceNoModification is in the tree this means its children have modifications.
	So a removal of a tree with modifications should be a conflict.
	
	This should maybe be enhanced: if my children are removals maybe this should not be a conflict, but this is the simplest solution right now."
	^ RiceConflictingOperation left: anIceNoModification right: self
]

{ #category : 'merging' }
RiceRemoval >> mergeWithLeftRemoval: anIceRemoval [ 
	
	^ RiceNonConflictingOperation operation: anIceRemoval
]

{ #category : 'merging' }
RiceRemoval >> mergeWithOperation: anOperation [
	
	^ anOperation mergeWithLeftRemoval: self
]
