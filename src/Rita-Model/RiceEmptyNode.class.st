"
I am a null object representing an empty node of a tree. I'm used together with IceNode.
"
Class {
	#name : 'RiceEmptyNode',
	#superclass : 'RiceAbstractNode',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceEmptyNode >> accept: aVisitor [
	
	^ aVisitor visitEmptyNode: self
]

{ #category : 'adding' }
RiceEmptyNode >> addTo: anotherNode [ 
	"I'm empty, so I do not add myself to a tree."
]

{ #category : 'enumerating' }
RiceEmptyNode >> anySatisfy: aBlockClosure [ 
	
	^ false
]

{ #category : 'accessing' }
RiceEmptyNode >> children [
	
	^ #()
]

{ #category : 'enumerating' }
RiceEmptyNode >> collect: aBlockClosure [ 

	^ self
]

{ #category : 'enumerating' }
RiceEmptyNode >> collectWithPath: aBlockClosure [ 
	^ self
]

{ #category : 'enumerating' }
RiceEmptyNode >> do: aBlock [
	"Do nothing"
]

{ #category : 'enumerating' }
RiceEmptyNode >> firstNodeSuchThat: conditionBlock ifNone: noneBlock [
	
	^ (conditionBlock value: self)
		ifTrue: [ self ]
		ifFalse: noneBlock
]

{ #category : 'testing' }
RiceEmptyNode >> hasChanges [
	
	^ false
]

{ #category : 'accessing' }
RiceEmptyNode >> includesKey: aString [ 
	
	^ false
]

{ #category : 'testing' }
RiceEmptyNode >> isEmpty [
	
	^ true
]

{ #category : 'testing' }
RiceEmptyNode >> isEmptyNode [
	
	^ true
]

{ #category : 'merging' }
RiceEmptyNode >> mergeWith: anotherNode onLeft: leftBlock onRight: rightBlock onMerge: mergeBlock [
	
	^ anotherNode collect: rightBlock
]

{ #category : 'accessing' }
RiceEmptyNode >> path [

	^ RelativePath new
]

{ #category : 'accessing' }
RiceEmptyNode >> resolve: aRelativePath ifPresent: presentBlock ifAbsent: absentBlock [ 
	^ absentBlock value
]

{ #category : 'enumerating' }
RiceEmptyNode >> select: aBlockClosure [ 
	
	^ self
]
