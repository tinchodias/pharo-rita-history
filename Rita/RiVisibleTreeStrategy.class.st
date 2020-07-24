Class {
	#name : #RiVisibleTreeStrategy,
	#superclass : #Object,
	#category : #'Rita-Iceberg'
}

{ #category : #accessing }
RiVisibleTreeStrategy class >> defaultLimit [
	^ 20
]

{ #category : #accessing }
RiVisibleTreeStrategy class >> expandedIceNodesFrom: initialIceNodes [
	^ self expandedIceNodesFrom: initialIceNodes limit: self defaultLimit
]

{ #category : #accessing }
RiVisibleTreeStrategy class >> expandedIceNodesFrom: initialIceNodes limit: limit [
	| result nextTreeLevel next2Levels |
	result := IdentitySet withAll: initialIceNodes.
	nextTreeLevel := initialIceNodes.
	
	[	nextTreeLevel := nextTreeLevel flatCollect: [ :each | each children ].

		"No more children so finish"
		nextTreeLevel ifEmpty: [ ^ result ].

		next2Levels := nextTreeLevel flatCollect: [ :each | each children ].

		"Limit would be exceeded with next level expanded, 
		so collapse them and all their children."
		nextTreeLevel size + next2Levels size + result size > limit ifTrue: [ ^ result ].

		"Then expand and iterate on next tree level"
		result addAll: nextTreeLevel ] repeat.

]
