"
I represent an abstract change.
"
Class {
	#name : 'RiceChange',
	#superclass : 'Object',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'displaying' }
RiceChange >> accept: anIceChangeImporter [
	^ self subclassResponsibility
]

{ #category : 'displaying' }
RiceChange >> displayingProgressString [
	^ self subclassResponsibility
]
