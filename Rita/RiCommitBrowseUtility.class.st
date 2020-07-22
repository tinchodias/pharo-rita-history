Class {
	#name : #RiCommitBrowseUtility,
	#superclass : #Object,
	#category : #'Rita-Ring2'
}

{ #category : #opening }
RiCommitBrowseUtility class >> browse: iceCommit [
	| aRGEnvironment |
	aRGEnvironment := RGEnvironment new.
	iceCommit packages do: [ :package | 
		(IceSavedPackageVersion fromCommit: iceCommit package: package)
			mcSnapshot importInto: aRGEnvironment asPackageNamed: package name ].
	aRGEnvironment
		clean;
		browse
]
