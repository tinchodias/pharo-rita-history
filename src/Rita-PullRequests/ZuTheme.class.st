"
I represent an aesthetic visual theme for the Rita-PullRequests Calypso extension.
"
Class {
	#name : #ZuTheme,
	#superclass : #Object,
	#classInstVars : [
		'currentInstance'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #accessing }
ZuTheme class >> current [

	^ currentInstance ifNil: [ currentInstance := self new ]
]

{ #category : #accessing }
ZuTheme >> cellBackgroundColor [

	^ Smalltalk ui theme caretColor alpha: 0.07
]

{ #category : #accessing }
ZuTheme >> changeIconSelector [

	^ #paint "#glamorousLargeGrayCircleEmphasized" "#diff"
]

{ #category : #accessing }
ZuTheme >> conversationIcon [

	^ self iconNamed: self conversationIconSelector
]

{ #category : #accessing }
ZuTheme >> conversationIconSelector [

	^ #announcement
]
