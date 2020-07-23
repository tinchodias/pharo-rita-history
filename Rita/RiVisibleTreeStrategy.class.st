Class {
	#name : #RiVisibleTreeStrategy,
	#superclass : #Object,
	#category : #'Rita-Iceberg'
}

{ #category : #accessing }
RiVisibleTreeStrategy class >> expandedIceNodesFrom: initialIceNodes limit: limit [
	| result nextTreeLevel |
	result := IdentitySet withAll: initialIceNodes.
	nextTreeLevel := initialIceNodes.
	
	[	nextTreeLevel := nextTreeLevel flatCollect: [ :each | each children ].

		"No more children so finish"
		nextTreeLevel ifEmpty: [ ^ result ].

		"Limit would be exceeded with next level expanded, 
		so collapse them and all their children."
		nextTreeLevel size + result size > limit ifTrue: [ ^ result ].

		"Then expand and iterate on next tree level"
		result addAll: nextTreeLevel ] repeat.

]
