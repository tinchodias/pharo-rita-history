Class {
	#name : #RiCommitBrowseUtility,
	#superclass : #Object,
	#category : #'Rita-Ring2'
}

{ #category : #opening }
RiCommitBrowseUtility class >> browse: iceCommit [
	(self ringEnvironmentFor: iceCommit) browse
]

{ #category : #opening }
RiCommitBrowseUtility class >> browseDiff: iceDiff [
	| env |
	env := self ringEnvironmentFor: iceDiff sourceVersion.
	
	LastZuEnvironmentPlugin := (ZuEnvironmentPlugin new iceDiff: iceDiff; yourself).
	
	env
		zurichBrowseAs: 'Changes'
		extraEnvironmentPlugin: LastZuEnvironmentPlugin.

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
