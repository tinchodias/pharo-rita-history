Class {
	#name : #RiFTTableContainer,
	#superclass : #FTTableContainerMorph,
	#instVars : [
		'valuableForMouseEnter',
		'valuableForMouseLeave'
	],
	#category : #'Rita-UI-FastTable'
}

{ #category : #accessing }
RiFTTableContainer >> blockForMouseEnter: anObject [
	valuableForMouseEnter := anObject
]

{ #category : #accessing }
RiFTTableContainer >> blockForMouseLeave: anObject [
	valuableForMouseLeave := anObject
]

{ #category : #updating }
RiFTTableContainer >> transformRow: morph index: rowIndex [

	RiFTTableRowMorph adoptInstance: morph.
	morph
		valuableForMouseEnter:
			(MessageSend
				receiver: valuableForMouseEnter
				selector: #value:
				argument: rowIndex);
		valuableForMouseLeave:
			(MessageSend
				receiver: valuableForMouseLeave
				selector: #value:
				argument: rowIndex)
]

{ #category : #updating }
RiFTTableContainer >> updateExposedRows [
	super updateExposedRows.
	exposedRows keysAndValuesDo: [ :rowIndex :morph |
		self transformRow: morph index: rowIndex ]
]

{ #category : #accessing }
RiFTTableContainer >> valuableForMouseEnter [
	^ valuableForMouseEnter
]

{ #category : #accessing }
RiFTTableContainer >> valuableForMouseLeave [
	^ valuableForMouseLeave
]
