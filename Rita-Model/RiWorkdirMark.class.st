Class {
	#name : 'RiWorkdirMark',
	#superclass : 'RiMark',
	#category : 'Rita-Model-Core',
	#package : 'Rita-Model',
	#tag : 'Core'
}

{ #category : 'visiting' }
RiWorkdirMark >> accept: aVisitor [
	^ aVisitor visitWorkdirMark: self
]

{ #category : 'accessing' }
RiWorkdirMark >> description [
	^ 'Workdir mark'
]
