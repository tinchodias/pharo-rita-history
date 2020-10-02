Class {
	#name : #RiCommitBrowseUtility,
	#superclass : #Object,
	#category : #'Rita-UI-Support'
}

{ #category : #opening }
RiCommitBrowseUtility class >> browse: iceCommit [
	(self ringEnvironmentFor: iceCommit) browse
]

{ #category : #opening }
RiCommitBrowseUtility class >> ringEnvironmentFor: iceCommit [
	| aRGEnvironment |
	aRGEnvironment := RGEnvironment new.
	iceCommit packages do: [ :package | 
		(IceSavedPackageVersion fromCommit: iceCommit package: package)
			mcSnapshot importInto: aRGEnvironment asPackageNamed: package name ].
	^ aRGEnvironment
		clean;
		yourself
]
