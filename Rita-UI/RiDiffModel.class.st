Class {
	#name : 'RiDiffModel',
	#superclass : 'Object',
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'accessing' }
RiDiffModel >> iceDiffTo: targetRiCommit [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiDiffModel >> icon [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiDiffModel >> shouldCompareTo: aRiCommit [ 
	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiDiffModel >> title [
	^ self subclassResponsibility
]
