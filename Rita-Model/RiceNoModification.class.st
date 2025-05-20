"
I am a no modification in a tree. I am useful to represent a container (that did not change) containing elements that did change. I contain the definition I represent to be able to show it. I delegate the icon to my definition and I know how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceNoModification',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceNoModification >> accept: aVisitor [
	
	^ aVisitor visitNoModification: self
]

{ #category : 'testing' }
RiceNoModification >> hasChanges [
	
	^ false
]

{ #category : 'as yet unclassified' }
RiceNoModification >> icon [

	^ definition icon
]

{ #category : 'operations' }
RiceNoModification >> inverse [
	
	^ self
]

{ #category : 'testing' }
RiceNoModification >> isConflict [
	^ false
]

{ #category : 'testing' }
RiceNoModification >> isNoModification [
	
	^ true
]

{ #category : 'accessing' }
RiceNoModification >> leftContents [
	
	^ definition contents
]

{ #category : 'merging' }
RiceNoModification >> mergeWithLeftAddition: anIceAddition [ 
	
	"This should not happen. If I represent a no modification of a node, that means that the original definition existed on the base version.
	Thus, the right version can never ADD an already existing version. It can remove it or modify it."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceNoModification >> mergeWithLeftModification: anIceModification [ 
	
	^ RiceNonConflictingOperation operation: anIceModification
]

{ #category : 'merging' }
RiceNoModification >> mergeWithLeftNoOperation: anIceNoModification [ 
	
	"There was no modifications on both sides, I can just return the left side"
	^ RiceNonConflictingOperation operation: anIceNoModification
]

{ #category : 'merging' }
RiceNoModification >> mergeWithLeftRemoval: anIceRemoval [
	
	"We assume that if I'm in the operation tree this means my children have modifications.
	So a removal of a tree with modifications should be a conflict.
	
	This should maybe be enhanced: if my children are removals maybe this should not be a conflict, but this is the simplest solution right now."
	^ RiceConflictingOperation left: anIceRemoval right: self
]

{ #category : 'merging' }
RiceNoModification >> mergeWithOperation: anOperation [
	
	^ anOperation mergeWithLeftNoOperation: self
]
