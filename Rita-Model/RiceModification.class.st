"
I am a modification in a tree. I contain the definition I'm changing (right) and the new (left) version of the definition. I know what is the icon for modification and how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceModification',
	#superclass : 'RiceOperation',
	#instVars : [
		'oldDefinition'
	],
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'instance creation' }
RiceModification class >> left: leftDefinition right: rightDefinition [

	^ self new
		leftDefinition: leftDefinition;
		rightDefinition: rightDefinition;
		yourself
]

{ #category : 'comparing' }
RiceModification >> = anotherOperation [

	^ super = anotherOperation
		and: [ self rightDefinition = anotherOperation rightDefinition ]
]

{ #category : 'visiting' }
RiceModification >> accept: aVisitor [
	
	^ aVisitor visitModification: self
]

{ #category : 'accessing' }
RiceModification >> description [
	^ definition key asString,
			(self isOnlyLowImpact
				ifTrue: [ ' [low impact] ' ]
				ifFalse: [ '' ])
]

{ #category : 'as yet unclassified' }
RiceModification >> icon [
	
	^ self iconNamed: #changeUpdate
]

{ #category : 'operations' }
RiceModification >> inverse [
	
	^ RiceModification left: self rightDefinition right: self leftDefinition
]

{ #category : 'testing' }
RiceModification >> isModification [
	
	^ true
]

{ #category : 'testing' }
RiceModification >> isOnlyLowImpact [
	^ definition isLowImpactAppliedTo: oldDefinition 
]

{ #category : 'accessing' }
RiceModification >> leftContents [
	
	^ definition contents
]

{ #category : 'merging' }
RiceModification >> mergeWithLeftAddition: anIceAddition [ 
	
	"This should not happen. If I represent a modification of a node, that means that the original definition existed on the base version.
	Thus, the right version can never ADD an already existing version. It can remove it or modify it."
	self shouldNotImplement
]

{ #category : 'merging' }
RiceModification >> mergeWithLeftModification: anIceModification [ 
	
	"If the modification is the same, I can just keep any of them."
	anIceModification leftDefinition = self leftDefinition 
		ifTrue: [ ^ RiceNonConflictingOperation operation: anIceModification ].
		
	^ RiceConflictingOperation left: anIceModification right: self
]

{ #category : 'merging' }
RiceModification >> mergeWithLeftNoOperation: anIceNoModification [ 
	
	^ RiceNonConflictingOperation operation: self
]

{ #category : 'merging' }
RiceModification >> mergeWithLeftRemoval: anIceRemoval [ 
	
	^ RiceConflictingOperation left: anIceRemoval right: self
]

{ #category : 'merging' }
RiceModification >> mergeWithOperation: anOperation [
	
	^ anOperation mergeWithLeftModification: self
]

{ #category : 'accessing' }
RiceModification >> oldDefinition [
	
	^ oldDefinition
]

{ #category : 'accessing' }
RiceModification >> rightContents [
	
	^ oldDefinition contents
]

{ #category : 'accessing' }
RiceModification >> rightDefinition [
	
	^ oldDefinition
]

{ #category : 'accessing' }
RiceModification >> rightDefinition: aDefinition [
	
	oldDefinition := aDefinition
]
