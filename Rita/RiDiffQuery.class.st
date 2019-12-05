Class {
	#name : #RiDiffQuery,
	#superclass : #Object,
	#instVars : [
		'diff',
		'onlyConsiderChanged'
	],
	#category : #Rita
}

{ #category : #accessing }
RiDiffQuery >> allLeafChildren [
	^ Array streamContents: [ :stream |
		self treeToQuery allChildrenDo: [ :node |
			node isEmpty ifTrue: [ stream nextPut: node ] ] ]
]

{ #category : #accessing }
RiDiffQuery >> diff [
	^ diff
]

{ #category : #accessing }
RiDiffQuery >> diff: anObject [
	diff := anObject
]

{ #category : #initialization }
RiDiffQuery >> initialize [
	super initialize.
	
	onlyConsiderChanged := true.
]

{ #category : #'as yet unclassified' }
RiDiffQuery >> nodesForBehaviors [
	^ Array
		streamContents: [ :stream | 
			self treeToQuery
				allChildrenDo: [ :node | 
					node value definition isClassDefinition
						ifTrue: [ stream nextPut: node ] ] ]
]

{ #category : #accessing }
RiDiffQuery >> nodesForMethodExtensions [
	^ Array
		streamContents: [ :stream | 
			self treeToQuery
				allChildrenDo: [ :node | 
					node value definition isExtensionDefinition
						ifTrue: [ stream nextPut: node ] ] ]
]

{ #category : #'as yet unclassified' }
RiDiffQuery >> onlyConsiderChanged [
	^ onlyConsiderChanged
]

{ #category : #accessing }
RiDiffQuery >> onlyConsiderChanged: anObject [
	onlyConsiderChanged := anObject
]

{ #category : #'as yet unclassified' }
RiDiffQuery >> treeToQuery [
	^ self onlyConsiderChanged
		ifTrue: [ diff tree ]
		ifFalse: [
			"FIX"
			IceDiff new
				sourceVersion: diff sourceVersion;
				targetVersion: diff targetVersion;
				buildForAllFiles;
				mergedTree ]
]

{ #category : #'as yet unclassified' }
RiDiffQuery >> visitNoModification: anIceNoModification [ 
	self shouldBeImplemented.
]
