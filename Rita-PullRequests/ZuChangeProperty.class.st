"
I'm a property for Calypso items. Please refer to my superclass for more information.
"
Class {
	#name : #ZuChangeProperty,
	#superclass : #ClyProperty,
	#instVars : [
		'matchingIceNode',
		'plugin'
	],
	#category : #'Rita-PullRequests-Calypso'
}

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

	^ plugin pullRequestConversationItemsFor: matchingIceNode
]
