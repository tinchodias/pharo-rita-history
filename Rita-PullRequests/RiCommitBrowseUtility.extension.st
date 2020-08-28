Extension { #name : #RiCommitBrowseUtility }

{ #category : #'*Rita-PullRequests' }
RiCommitBrowseUtility class >> browseDiff: iceDiff [
	| env |
	env := self ringEnvironmentFor: iceDiff sourceVersion.
	
	LastZuEnvironmentPlugin := (ZuEnvironmentPlugin new iceDiff: iceDiff; yourself).
	
	env
		zurichBrowseAs: 'Changes'
		extraEnvironmentPlugin: LastZuEnvironmentPlugin.

]
