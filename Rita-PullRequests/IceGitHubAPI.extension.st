Extension { #name : #IceGitHubAPI }

{ #category : #'*Rita-PullRequests' }
IceGitHubAPI >> addReviewComment: owner project: projectName pullRequest: aNumber data: aDictionary [
	^ self 
		post: 'repos/', owner, '/', projectName, '/pulls/', aNumber asString, '/comments'
		with: [ :client |
			client 
				entity: (ZnEntity text: (STON toJsonString: aDictionary));
				contentType: ZnMimeType applicationJson ]
]

{ #category : #'*Rita-PullRequests' }
IceGitHubAPI >> getListPullRequestFiles: owner project: projectName number: aNumber [
	^ self
		getPaginated: 'repos/', owner, '/', projectName, '/pulls/', aNumber asString, '/files'
]

{ #category : #'*Rita-PullRequests' }
IceGitHubAPI >> useComfortFadeAcceptMediaType [
	"See: https://developer.github.com/v3/pulls/comments/#list-review-comments-on-a-pull-request"

	self acceptMediaType: 'application/vnd.github.comfort-fade-preview+json'
]
