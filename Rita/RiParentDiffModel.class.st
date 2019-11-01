Class {
	#name : #RiParentDiffModel,
	#superclass : #RiDiffModel,
	#category : #'Rita-UI'
}

{ #category : #accessing }
RiParentDiffModel >> iceDiffTo: targetRiCommit [
	^ targetRiCommit iceCommit diffToParent
]

{ #category : #accessing }
RiParentDiffModel >> title [
	^ 'Diff to parent'
]
