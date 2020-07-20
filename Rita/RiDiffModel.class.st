Class {
	#name : #RiDiffModel,
	#superclass : #Object,
	#category : #'Rita-UI-Models'
}

{ #category : #accessing }
RiDiffModel >> allChildrenNodes [
	self shouldBeImplemented.
]

{ #category : #accessing }
RiDiffModel >> iceDiffTo: targetRiCommit [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
RiDiffModel >> shouldCompareTo: aRiCommit [ 
	^ self subclassResponsibility
]

{ #category : #accessing }
RiDiffModel >> title [
	^ self subclassResponsibility
]
