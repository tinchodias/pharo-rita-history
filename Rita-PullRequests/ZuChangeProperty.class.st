Class {
	#name : #ZuChangeProperty,
	#superclass : #ClyProperty,
	#instVars : [
		'matchingIceNode',
		'plugin'
	],
	#category : #'Rita-PullRequests-Calypso'
}

{ #category : #tmp }
ZuChangeProperty class >> instance [
	^ self new
]

{ #category : #accessing }
ZuChangeProperty >> matchingIceNode [
	^ matchingIceNode
]

{ #category : #accessing }
ZuChangeProperty >> matchingIceNode: anIceNode [

	matchingIceNode := anIceNode
]

{ #category : #accessing }
ZuChangeProperty >> plugin: aZuEnvironmentPlugin [

	plugin := aZuEnvironmentPlugin
]

{ #category : #accessing }
ZuChangeProperty >> pullRequestConversationItems [

	^ plugin pullRequestConversationItems select: [ :each |
		each hasMapping and: [ each mapping iceNode == matchingIceNode ] ]

]
