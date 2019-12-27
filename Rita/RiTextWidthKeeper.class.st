"
I help to abbreviate text according into a maximum width.
"
Class {
	#name : #RiTextWidthKeeper,
	#superclass : #Object,
	#category : #'Rita-Roassal3'
}

{ #category : #convenience }
RiTextWidthKeeper class >> endingTruncationFor: aString font: aFont maxSize: anInteger [
	| width |
	width := aFont widthOfString: aString.
	^ (width <= anInteger or: [ aString size <= 3 ])
		ifTrue: [ aString ]
		ifFalse: [ self endingTruncationFor: ((aString allButLast: 2), '…') font: aFont maxSize: anInteger ]
]

{ #category : #convenience }
RiTextWidthKeeper class >> middleTruncationFor: originalString font: aFont maxSize: max [
	| length width result |
	result := originalString.
	length := originalString size.
	
	[	width := aFont widthOfString: result.
		width <= max or: [ result size <= 5 ] ] whileFalse: [
			length := length - 1.
			result := originalString contractTo: length ].
	^ result

]

{ #category : #convenience }
RiTextWidthKeeper class >> startingTruncationFor: aString font: aFont maxSize: anInteger [
	| width |
	width := aFont widthOfString: aString.
	^ (width <= anInteger or: [ aString size <= 3 ])
		ifTrue: [ aString ]
		ifFalse: [ self startingTruncationFor: ('…', (aString allButFirst: 2)) font: aFont maxSize: anInteger ]
]
