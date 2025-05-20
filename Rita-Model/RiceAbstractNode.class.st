"
My subclasses implement a tree used for diffing and merging.
"
Class {
	#name : 'RiceAbstractNode',
	#superclass : 'Object',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'accessing' }
RiceAbstractNode >> accept: aVisitor [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> addTo: anotherNode [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> allChildren [
	"Answer a collection with my direct and indirect children."

	^ Array streamContents: [ :stream |
		self allChildrenDo: [ :each | stream nextPut: each ] ]
	

]

{ #category : 'accessing' }
RiceAbstractNode >> allChildrenDo: aBlockClosure [
	"Evaluate aBlockClosure with my direct and indirect children."
	
	self childrenDo: [ :each |
		aBlockClosure value: each.
		each allChildrenDo: aBlockClosure ]
]

{ #category : 'accessing' }
RiceAbstractNode >> allLeavesDo: aBlockClosure [
	"Evaluate aBlockClosure with all empty nodes, including self and all (direct and indirect) children."

	self isEmpty
		ifTrue: [ aBlockClosure value: self ]
		ifFalse: [ 
			self childrenDo: [ :each |
				each allLeavesDo: aBlockClosure ] ]
]

{ #category : 'accessing' }
RiceAbstractNode >> anySatisfy: aBlockClosure [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> children [
	"Answer the (direct) children of this node."

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
RiceAbstractNode >> childrenDo: aBlockClosure [ 
	
	self children do: aBlockClosure
]

{ #category : 'accessing' }
RiceAbstractNode >> collect: aBlockClosure [
	"Collect the results of aBlockClosure on my value and the values of my children."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> collectWithPath: aBlockClosure [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> do: aBlockClosure [
	"Evaluate aBlockClosure on my value and the values of my children."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> firstNodeSuchThat: conditionBlock [ 
	
	^ self firstNodeSuchThat: conditionBlock ifNone: [ NotFound signalFor: conditionBlock ]
]

{ #category : 'accessing' }
RiceAbstractNode >> firstNodeSuchThat: foundBlock ifNone: noneBlock [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> hasChanges [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> includesKey: anObject [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> isEmpty [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> isEmptyNode [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> mergeWith: anotherNode onLeft: leftBlock onRight: rightBlock onMerge: mergeBlock [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> notEmpty [

	^ self isEmpty not
]

{ #category : 'accessing' }
RiceAbstractNode >> path [
	"Answer a RelativePath to the top parent."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> resolve: aRelativePath ifPresent: presentBlock ifAbsent: absentBlock [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiceAbstractNode >> select: aBlockClosure [

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
RiceAbstractNode >> withAllChildrenDo: aBlockClosure [

	aBlockClosure value: self.
	self allChildrenDo: aBlockClosure
]
