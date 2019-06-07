Class {
	#name : #RiWorkingCopyMark,
	#superclass : #RiMark,
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiWorkingCopyMark >> accept: aVisitor [
	^ aVisitor visitWorkingCopyMark: self
]

{ #category : #accessing }
RiWorkingCopyMark >> workingCopy [
	self flag: #fix.
	^ element repository iceRepository workingCopy 
]
