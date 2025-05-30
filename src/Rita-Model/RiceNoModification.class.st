"
I am a no modification in a tree. I am useful to represent a container (that did not change) containing elements that did change. I contain the definition I represent to be able to show it. I delegate the icon to my definition and I know how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceNoModification',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceNoModification >> accept: aVisitor [
	
	^ aVisitor visitNoModification: self
]

{ #category : 'testing' }
RiceNoModification >> hasChanges [
	
	^ false
]

{ #category : 'as yet unclassified' }
RiceNoModification >> icon [

	^ definition icon
]

{ #category : 'operations' }
RiceNoModification >> inverse [
	
	^ self
]

{ #category : 'testing' }
RiceNoModification >> isConflict [
	^ false
]

{ #category : 'testing' }
RiceNoModification >> isNoModification [
	
	^ true
]

{ #category : 'accessing' }
RiceNoModification >> leftContents [
	
	^ definition contents
]
