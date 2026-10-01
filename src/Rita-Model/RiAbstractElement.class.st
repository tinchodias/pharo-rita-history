"
Common superclass of the things Rita can show a diff of: a single element of a repository (RiElement) or a group of elements the user selected together (RiCompositeElement).

The public API is the two endpoints of a range:

- #sourceRiElement, the older end: what the diff starts from. Answering nil when there is nothing older to start from, typically the root commit or the whole history.
- #targetRiElement, the newer end: what the diff ends at. Answering nil when there is no target, like the uncommitted working copy.

The direction is the one of RiElement>>diffTo:: a diff runs from the newer element to the older one, as in 'Diff to Parent'.
"
Class {
	#name : 'RiAbstractElement',
	#superclass : 'Object',
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'testing' }
RiAbstractElement class >> isAbstract [
	^ self == RiAbstractElement
]

{ #category : 'testing' }
RiAbstractElement >> isComposite [

	^ false
]

{ #category : 'testing' }
RiAbstractElement >> isUncommited [
	^ false
]

{ #category : 'accessing' }
RiAbstractElement >> repository [
	"Answer the RiRepository that contains me."

	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiAbstractElement >> sourceRiElement [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
RiAbstractElement >> targetRiElement [
	^ self subclassResponsibility
]
