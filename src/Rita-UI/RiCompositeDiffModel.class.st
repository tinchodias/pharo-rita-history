"
I am the diff of a range of commits the user selected together: the cumulative diff from the first ancestor outside the range up to its newest member.

I am built from a fixed RiCompositeElement, so unlike RiParentDiffModel and RiPinDiffModel I do not need to be told what to diff to: my own endpoints are the base and the tip. This is why #iceDiffFrom: ignores its argument.
"
Class {
	#name : 'RiCompositeDiffModel',
	#superclass : 'RiDiffModel',
	#instVars : [
		'riCompositeElement'
	],
	#category : 'Rita-UI-Models',
	#package : 'Rita-UI',
	#tag : 'Models'
}

{ #category : 'instance creation' }
RiCompositeDiffModel class >> riCompositeElement: aRiCompositeElement [

	^ self new
		  riCompositeElement: aRiCompositeElement;
		  yourself
]

{ #category : 'accessing' }
RiCompositeDiffModel >> iceDiffFrom: anIgnoredRiElement [
	"I already know both ends of my range, so the element I am asked to diff to is irrelevant."

	^ riCompositeElement targetRiElement diffTo: riCompositeElement sourceRiElement
]

{ #category : 'accessing' }
RiCompositeDiffModel >> icon [

	^ self iconNamed: #diff
]

{ #category : 'accessing' }
RiCompositeDiffModel >> riCompositeElement [

	^ riCompositeElement
]

{ #category : 'initialization' }
RiCompositeDiffModel >> riCompositeElement: aRiCompositeElement [

	riCompositeElement := aRiCompositeElement
]

{ #category : 'testing' }
RiCompositeDiffModel >> shouldCompareTo: aRiElement [
	"A pin compares to a single element, so it never applies to a range of elements."

	^ false
]

{ #category : 'accessing' }
RiCompositeDiffModel >> title [

	^ 'Diff over {1} commits ({2} to {3})' format: {
			  riCompositeElement size.
			  riCompositeElement newestElement shortId.
			  riCompositeElement oldestElement shortId }
]
