Class {
	#name : #RiDiffQuery,
	#superclass : #Object,
	#instVars : [
		'diff',
		'onlyConsiderChanged',
		'treeToQuery'
	],
	#category : #'Rita-Diff'
}

{ #category : #accessing }
RiDiffQuery >> allLeafChildren [
	^ Array streamContents: [ :stream |
		self treeToQuery allLeavesDo: [ :node |
			stream nextPut: node ] ]
]

{ #category : #private }
RiDiffQuery >> basicTreeToQuery [
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

{ #category : #accessing }
RiDiffQuery >> nodesForBehaviors [
	^ Array streamContents: [ :stream |
		self treeToQuery allChildrenDo: [ :node |
			node value definition isClassDefinition
				ifTrue: [ stream nextPut: node ] ] ]
]

{ #category : #accessing }
RiDiffQuery >> nodesForFiles [
	^ Array streamContents: [ :stream |
		self treeToQuery allChildrenDo: [ :node |
			node value definition isFileDefinition
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

{ #category : #accessing }
RiDiffQuery >> onlyConsiderChanged [
	^ onlyConsiderChanged
]

{ #category : #accessing }
RiDiffQuery >> onlyConsiderChanged: anObject [
	onlyConsiderChanged := anObject
]

{ #category : #accessing }
RiDiffQuery >> treeToQuery [
	^ treeToQuery ifNil: [ treeToQuery := self basicTreeToQuery ]
]
