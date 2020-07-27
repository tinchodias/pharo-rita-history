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
	| tmp2 |
	tmp2 := currentInstance.
	^ tmp2 ifNil: [ currentInstance := self new ] ifNotNil: [ tmp2 ]
]

{ #category : #accessing }
ZuTheme >> cellBackgroundColor [
	^ Color orange alpha: 0.25
]

{ #category : #accessing }
ZuTheme >> changeIconSelector [
	^ #diff
]
