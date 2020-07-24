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
		self treeToQuery allLeavesDo: [ :iceNode |
			stream nextPut: iceNode ] ]
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
RiDiffQuery >> diff: anIceDiff [
	diff := anIceDiff
]

{ #category : #initialization }
RiDiffQuery >> initialize [
	super initialize.
	
	onlyConsiderChanged := true.
]

{ #category : #accessing }
RiDiffQuery >> nodesForBehaviors [
	^ self nodesThatSatisfy: [ :iceNode |
		iceNode value definition isClassDefinition or: [
		iceNode value definition isTraitDefinition ] ]

]

{ #category : #accessing }
RiDiffQuery >> nodesForFiles [
	^ self nodesThatSatisfy: [ :iceNode |
		iceNode value definition isFileDefinition ]

]

{ #category : #accessing }
RiDiffQuery >> nodesForMethodExtensions [
	^ self nodesThatSatisfy: [ :iceNode |
		iceNode value definition isExtensionDefinition ]
]

{ #category : #accessing }
RiDiffQuery >> nodesForPackages [
	^ self nodesThatSatisfy: [ :iceNode |
		iceNode value definition isPackageDefinition ]
]

{ #category : #accessing }
RiDiffQuery >> nodesThatSatisfy: aBlock [
	^ Array streamContents: [ :stream |
		self treeToQuery allChildrenDo: [ :iceNode |
			(aBlock value: iceNode) ifTrue: [
				stream nextPut: iceNode ] ] ]
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
