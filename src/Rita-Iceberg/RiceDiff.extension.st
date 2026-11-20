Extension { #name : 'RiceDiff' }

{ #category : '*Rita-Iceberg' }
RiceDiff >> buildForAllFiles [

	| files changes |
	files := (source fileSystem childNames, target fileSystem childNames) asSet.
	changes := files collect: [ :each | IceGitChange on: each ].
	
	self buildForChanges: changes
]
