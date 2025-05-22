"
I am an addition in a tree. I contain the definition I'm adding. I know what is the icon for addition and how to calculate a conflict with other operations.
"
Class {
	#name : 'RiceAddition',
	#superclass : 'RiceOperation',
	#category : 'Rita-Model-Changes',
	#package : 'Rita-Model',
	#tag : 'Changes'
}

{ #category : 'visiting' }
RiceAddition >> accept: aVisitor [
	
	^ aVisitor visitAddition: self
]

{ #category : 'as yet unclassified' }
RiceAddition >> icon [
	
	^ self iconNamed: #changeAdd
]

{ #category : 'operations' }
RiceAddition >> inverse [
	
	^ RiceRemoval definition: definition
]

{ #category : 'testing' }
RiceAddition >> isAddition [
	
	^ true
]

{ #category : 'contents' }
RiceAddition >> leftContents [
	
	^ definition contents
]

{ #category : 'accessing' }
RiceAddition >> rightContents [
	
	^ ''
]
