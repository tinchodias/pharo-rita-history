Class {
	#name : #RiTextWidthKeeper,
	#superclass : #Object,
	#category : #'Rita-IceTip'
}

{ #category : #convenience }
RiTextWidthKeeper class >> stringFor: aString font: aFont maxSize: anInteger [
	| width |
	width := aFont widthOfString: aString.
	^ (width <= anInteger or: [ aString size <= 3 ])
		ifTrue: [ aString ]
		ifFalse: [ self stringFor: ((aString allButLast: 2), '…') font: aFont maxSize: anInteger ]
]