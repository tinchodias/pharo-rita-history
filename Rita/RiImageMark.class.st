Class {
	#name : #RiImageMark,
	#superclass : #RiMark,
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiImageMark >> accept: aVisitor [
	^ aVisitor visitImageMark: self
]