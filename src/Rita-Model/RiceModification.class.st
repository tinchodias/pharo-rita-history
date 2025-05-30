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
