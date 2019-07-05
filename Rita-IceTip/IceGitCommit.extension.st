Extension { #name : #IceGitCommit }

{ #category : #'*Rita-IceTip' }
IceGitCommit >> authorEmail [
	^ self libgitCommit author email
]
