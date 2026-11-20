Extension { #name : 'RiceChangeImporter' }

{ #category : '*Rita-Iceberg' }
RiceChangeImporter >> visitGitChange: anIceGitChange [ 

	| importer |
	importer := RiceGitChangeImporter new
		path: anIceGitChange path;
		diff: diff;
		version: version;
		yourself.
	importer importOn: parentNode.
]

{ #category : '*Rita-Iceberg' }
RiceChangeImporter >> visitImageChange: anIceImageChange [ 

	| importer |
	importer := RiceMCPackageImporter new
		package: anIceImageChange package;
		version: version;
		yourself.
	^ importer importOn: (self ensureSourceCodeParentNodeIn: parentNode)
]

{ #category : '*Rita-Iceberg' }
RiceChangeImporter >> visitMemoryChange: anIceMemoryChange [ 
	
	| importer |
	importer := RiceMCPackageImporter new
		package: anIceMemoryChange package;
		version: version;
		yourself.
	^ importer importOn: parentNode
]
