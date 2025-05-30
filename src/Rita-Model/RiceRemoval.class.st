"
I am a removal in a tree. I contain the definition I'm removing. I know what is the icon for removal and how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceRemoval',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceRemoval >> accept: aVisitor [
	
	^ aVisitor visitRemoval: self
]

{ #category : 'as yet unclassified' }
RiceRemoval >> icon [

	^ self iconNamed: #changeRemove
]

{ #category : 'operations' }
RiceRemoval >> inverse [
	
	^ RiceAddition definition: definition
]

{ #category : 'testing' }
RiceRemoval >> isRemoval [
	
	^ true
]

{ #category : 'accessing' }
RiceRemoval >> leftContents [
	
	^ ''
]
