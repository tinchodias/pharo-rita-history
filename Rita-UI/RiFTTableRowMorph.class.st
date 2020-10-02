Class {
	#name : #RiFTTableRowMorph,
	#superclass : #FTTableRowMorph,
	#category : #'Rita-UI-FastTable'
}

{ #category : #'event handling' }
RiFTTableRowMorph >> mouseEnter: evt [
	self valueOfProperty: #ritaMouseEnter ifPresentDo: [ :valuable | valuable value ].
	^ super mouseEnter: evt.
	
]

{ #category : #'event handling' }
RiFTTableRowMorph >> mouseLeave: evt [
	self valueOfProperty: #ritaMouseLeave ifPresentDo: [ :valuable | valuable value ].
	^ super mouseLeave: evt.
	
]

{ #category : #'event handling' }
RiFTTableRowMorph >> valuableForMouseEnter: aValuable [
	self setProperty: #ritaMouseEnter toValue: aValuable
]

{ #category : #'event handling' }
RiFTTableRowMorph >> valuableForMouseLeave: aValuable [
	self setProperty: #ritaMouseLeave toValue: aValuable
]
