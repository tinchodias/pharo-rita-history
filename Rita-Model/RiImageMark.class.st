Class {
	#name : 'RiImageMark',
	#superclass : 'RiMark',
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'visiting' }
RiImageMark >> accept: aVisitor [
	^ aVisitor visitImageMark: self
]

{ #category : 'accessing' }
RiImageMark >> description [
	^ 'Image mark'
]
