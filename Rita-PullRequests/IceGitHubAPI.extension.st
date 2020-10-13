Extension { #name : #IceGitHubAPI }

{ #category : #'*Rita-PullRequests' }
IceGitHubAPI >> useComfortFadeAcceptMediaType [
	"See: https://developer.github.com/v3/pulls/comments/#list-review-comments-on-a-pull-request"

	self acceptMediaType: 'application/vnd.github.comfort-fade-preview+json'
]
