Class {
	#name : #RiWorkdirMark,
	#superclass : #RiMark,
	#category : #'Rita-Core'
}

{ #category : #visiting }
RiWorkdirMark >> accept: aVisitor [
	^ aVisitor visitWorkdirMark: self
]

{ #category : #accessing }
RiWorkdirMark >> description [
	^ 'Workdir mark'
]
