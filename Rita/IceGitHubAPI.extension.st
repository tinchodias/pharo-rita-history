Extension { #name : #IceGitHubAPI }

{ #category : #'*Rita' }
IceGitHubAPI >> graphql: aGraphQLString [
	^ self jsonContentsWithValidationDo: [
		| client |
		client := self newGraphQLRequest.
		client 
			entity: (ZnEntity text: ('{ "query" : ', (STON toJsonString: aGraphQLString), ' }'));
			contentType: ZnMimeType applicationJson.
		client
			post;
			response ]
]

{ #category : #'*Rita' }
IceGitHubAPI >> listPullRequestComments: owner project: projectName [
	^ self getPaginated: 'repos/', owner, '/', projectName, '/pulls/comments'
]

{ #category : #'*Rita' }
IceGitHubAPI >> listPullRequestComments: owner project: projectName number: aNumber [
	^ self
		getPaginated: 'repos/', owner, '/', projectName, '/pulls/', aNumber asString, '/comments'
]

{ #category : #'*Rita' }
IceGitHubAPI >> listPullRequestReviews: owner project: projectName number: aNumber [
	^ self
		getPaginated: 'repos/', owner, '/', projectName, '/pulls/', aNumber asString, '/reviews'
]

{ #category : #'*Rita' }
IceGitHubAPI >> newGraphQLRequest [
	^ ZnClient new in: [ :this |
		this prepareRequest: [ :request | request setAuthorization: 'bearer ', MartinPersonalToken ]
"		this
			username: self credentials username 
			password: self credentials password" ];
		url: 'https://api.github.com/graphql';
		yourself
]
