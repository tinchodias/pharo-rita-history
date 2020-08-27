Class {
	#name : #ZuTheme,
	#superclass : #Object,
	#classInstVars : [
		'currentInstance'
	],
	#category : #Zurich
}

{ #category : #accessing }
ZuTheme class >> current [
	^ currentInstance ifNil: [ currentInstance := self new ]
]

{ #category : #accessing }
ZuTheme >> cellBackgroundColor [
	^ Color orange alpha: 0.25
]

{ #category : #accessing }
ZuTheme >> changeIconSelector [
	^ #diff
]
